Invoke-WebRequest -Uri "https://github.com/s0nt3k/PowerShell/blob/main/Scripts/HostsDnsBlocklist.ps1" -OutFile .\HostsDnsBlocklist.ps1

Start-Process powershell.exe -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File .\HostsDnsBlocklist.ps1' -Verb RunAs
