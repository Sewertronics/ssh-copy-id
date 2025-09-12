# Requires: SSH and optional SSH agent on Windows
# Usage: .\ssh-copy-id.ps1 -User "ubuntu" -RemoteHost "10.74.90.100"

param(
    [Parameter(Mandatory = $true)] [string]$User,
    [Parameter(Mandatory = $true)] [string]$RemoteHost
)

$winUser = $env:USERNAME
$pattern = "${User}@${RemoteHost}"

# Get key from agent and append Windows username at the end
$selectedKey = ssh-add -L | Where-Object { $_ -match $pattern } | ForEach-Object { "$_ [$winUser]" }

if (-not $selectedKey) {
    Write-Error "[FAIL] No key found in ssh-agent with pattern '$pattern'"
    exit 1
}

Write-Host "[INFO] Found matching key: $selectedKey"

# Remote command: ensure .ssh and authorized_keys exist, append key if missing
$remoteCmd = @"
mkdir -p ~/.ssh
chmod 700 ~/.ssh
touch ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
grep -qxF '$selectedKey' ~/.ssh/authorized_keys || echo '$selectedKey' >> ~/.ssh/authorized_keys
"@ -replace "`r",""

# Execute SSH forcing password authentication
ssh -o PubkeyAuthentication=no "$User@$RemoteHost" $remoteCmd

if ($LASTEXITCODE -eq 0) {
    Write-Host "[OK] Key ensured on $User@$RemoteHost"
} else {
    Write-Error "[FAIL] Could not update key on $User@$RemoteHost"
}
