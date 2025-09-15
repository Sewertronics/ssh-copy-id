param(
    [Parameter(Mandatory=$true)]
    [string]$Target
)

if ($Target -notmatch "^(.+)@(.+)$") {
    Write-Error "Target must be in format user@host"
    exit 1
}
$User, $RemoteHost = $matches[1], $matches[2]

ssh "$User@$RemoteHost" 'cat >> ~/.bashrc <<
export SSH_AUTH_SOCK=\"\${SSH_AUTH_SOCK:-\$(find /tmp/ -type s -name '\''agent.*'\'' 2>/dev/null | head -n1)}\"'
