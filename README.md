# 🔑 Add SSH Key to Remote Server

[![PowerShell](https://img.shields.io/badge/language-PowerShell-blue?logo=powershell)](https://docs.microsoft.com/powershell/)
[![Platform](https://img.shields.io/badge/platform-Windows-lightgrey?logo=windows)](https://www.microsoft.com/windows/)
[![SSH](https://img.shields.io/badge/SSH-Enabled-green?logo=ssh)](https://www.openssh.com/)
[![License](https://img.shields.io/badge/license-MIT-green)](LICENSE)
[![Script](https://img.shields.io/badge/type-script-yellow)](add-sshkey.ps1)

This PowerShell script adds an SSH public key from your local `ssh-agent` to a remote server's `authorized_keys` file. It preserves the key’s original comment and appends your Windows username for identification. The script ensures the `.ssh` directory and `authorized_keys` file exist, sets correct permissions, and can optionally use password authentication.

## 🌟 Features

- ✅ Appends public key **only once** to avoid duplicates
- 📝 Preserves original key comment and appends your Windows username
- 🛠 Works even if `.ssh` or `authorized_keys` does not exist
- 🔐 Can force **password authentication** to avoid `Too many authentication failures`
- ⚡ Simple usage on Windows PowerShell
- 🧩 Safe with multiple keys in your SSH agent
- 📌 Keeps permissions secure for `.ssh` and `authorized_keys`

## 📋 Requirements

- 🖥 Windows PowerShell (5.1+) or PowerShell 7+
- 🔧 SSH installed (`ssh` command available)
- 🗝 Optional: SSH agent running with keys loaded (e.g., via Bitwarden)
- 🌐 Remote server accessible over SSH

## 🚀 Usage

```powershell
# Basic usage
.\ssh-copy-id.ps1 -User "ubuntu" -RemoteHost "10.74.90.100"
```

## ©️ Copyright

<img src="https://sewertronics.com/wp-content/uploads/2024/06/sewertronics-logo-CMYK-black.png.webp" alt="Docker Logo" width="200" align="right">
© 2025 Sewertronics Sp z o.o.

This project is licensed under the [MIT License](LICENSE).

All rights reserved. Redistribution and use in source and binary forms, with or without modification, are permitted under the terms of the MIT License.
