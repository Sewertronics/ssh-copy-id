# Requires: SSH and optional SSH agent on Windows
# Usage: .\ssh-copy-id "ubuntu@10.74.90.100"

param(
    [Parameter(Mandatory = $true)]
    [string]$Target
)

# Validate and split target
if ($Target -notmatch "^(.+)@(.+)$") {
    Write-Error "[FAIL] Target must be in format user@host"
    exit 1
}
$User, $RemoteHost = $matches[1], $matches[2]

$winUser = $env:USERNAME
$pattern = "$User@$RemoteHost"

# Get key from agent and append Windows username at the end
$selectedKey = ssh-add -L | Where-Object { $_ -match $pattern } | ForEach-Object { "$_ [$winUser]" }
if (-not $selectedKey) {
    Write-Error "[FAIL] No matching SSH key found in ssh-agent for '$pattern'.
    Tip: Make sure your key is loaded into the Bitwarden SSH agent and that its name includes the server identifier (e.g., '$pattern')."
    exit 1
}

Write-Host "[INFO] Found matching key: $selectedKey"

# Remote authorized_keys path
$authKeys = "~/.ssh/authorized_keys"

# Prepare remote command
$remoteCmd = @"
mkdir -p ~/.ssh
chmod 700 ~/.ssh
touch $authKeys
chmod 600 $authKeys
# Ensure last line ends with newline only if file is non-empty
if [ -s $authKeys ]; then
    tail -c1 $authKeys | read -r _ || echo >> $authKeys
fi
grep -qxF '$selectedKey' $authKeys || echo '$selectedKey' >> $authKeys
"@ -replace "`r",""

# Execute SSH forcing password authentication
ssh -o PubkeyAuthentication=no "$User@$RemoteHost" $remoteCmd

if ($LASTEXITCODE -eq 0) {
    Write-Host "[OK] Key ensured on $User@$RemoteHost"
} else {
    Write-Error "[FAIL] Could not update key on $User@$RemoteHost"
}
