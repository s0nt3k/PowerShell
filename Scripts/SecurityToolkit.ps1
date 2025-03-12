Function Ensure-Admin {
    param(
        [string]$ScriptPath = $PSCommandPath  # Default to the current script
    )
    
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    $isAdmin = $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    
    if (-not $isAdmin) {
        Write-Host "Not running as administrator. Relaunching as admin..."
        
        $arguments = "-NoProfile -ExecutionPolicy Bypass -File `"$ScriptPath`""
        
        Start-Process powershell -Verb RunAs -ArgumentList $arguments
        exit
    }
    else {
        Write-Host "Running as administrator. Continuing execution..."
    }
}

Function Create-DirectoryStructure {

Write-Host "Creating Directory Structure"
Start-Sleep -Seconds 3

New-Item -ItemType Directory -Path "C:\Security"
New-Item -ItemType Directory -Path "C:\Security\Downloads"
New-Item -ItemType Directory -Path "C:\Security\Temp"
New-Item -ItemType Directory -Path "C:\Security\Security Compliance Scan Results"
# New-Item -ItemType Directory -Path "C:\Security\Security_Scan_Results"
New-Item -ItemType Directory -Path "C:\Security\Temp\Security Compliance Checker"
New-Item -ItemType Directory -Path "C:\Security\Security Compliance Checker"
New-Item -ItemType Directory -Path "C:\Security\Microsoft Security Compliance Toolkit"
New-Item -ItemType Directory -Path "C:\Security\STIG GPO Package January 2025"
New-Item -itemType Directory -Path "C:\Security\Downloads\Microsoft Security Compliance Toolkit\LGPO"
New-Item -itemType Directory -Path "C:\Security\Downloads\Microsoft Security Compliance Toolkit\PolicyAnalyzer"
New-Item -itemType Directory -Path "C:\Security\Downloads\Microsoft Security Compliance Toolkit\SetObjectSecurity"
New-Item -itemType Directory -Path "C:\Security\Downloads\Microsoft Security Compliance Toolkit\Windows 11 v24H2 Security Baseline"
New-Item -itemType Directory -Path "C:\Security\Downloads\Microsoft Security Compliance Toolkit\Microsoft 365 Apps for Enterprise 2412"
New-Item -itemType Directory -Path "C:\Security\Downloads\Microsoft Security Compliance Toolkit\Microsoft Edge v128 Security Baseline"
New-Item -itemType Directory -Path "C:\Security\Downloads\Microsoft Security Compliance Toolkit\Windows 11 Security Baseline"
New-Item -itemType Directory -Path "C:\Security\Downloads\Microsoft Security Compliance Toolkit\Windows Server 2025 Security Baseline"
New-Item -itemType Directory -Path "C:\Security\Microsoft Security Compliance Toolkit\LGPO"
New-Item -itemType Directory -Path "C:\Security\Microsoft Security Compliance Toolkit\PolicyAnalyzer"
New-Item -itemType Directory -Path "C:\Security\Microsoft Security Compliance Toolkit\SetObjectSecurity"
New-Item -itemType Directory -Path "C:\Security\Microsoft Security Compliance Toolkit\Windows 11 v24H2 Security Baseline"
New-Item -itemType Directory -Path "C:\Security\Microsoft Security Compliance Toolkit\Microsoft 365 Apps for Enterprise 2412"
New-Item -itemType Directory -Path "C:\Security\Microsoft Security Compliance Toolkit\Microsoft Edge v128 Security Baseline"
New-Item -itemType Directory -Path "C:\Security\Microsoft Security Compliance Toolkit\Windows 11 Security Baseline"
New-Item -itemType Directory -Path "C:\Security\Microsoft Security Compliance Toolkit\Windows Server 2025 Security Baseline"

}

Function Download-Files {

# Clear-Host

Write-Host "Downloading Security Compliance Checker"

Invoke-WebRequest -Uri https://dl.dod.cyber.mil/wp-content/uploads/stigs/zip/scc-5.10.1_Windows_bundle.zip -OutFile C:\Security\Downloads\scc-5.10.1_Windows_bundle.zip

Write-Host "Downloading US DoD STIG GPO Package January 2025"

Invoke-WebRequest -Uri https://dl.dod.cyber.mil/wp-content/uploads/stigs/zip/U_STIG_GPO_Package_January_2025.zip -OutFile C:\Security\Downloads\U_STIG_GPO_Package_January_2025.zip

# LGPO
Write-Host "Downloading Local Group Policy Object Editor"
Invoke-WebRequest -Uri https://download.microsoft.com/download/8/5/c/85c25433-a1b0-4ffa-9429-7e023e7da8d8/LGPO.zip -OutFile "C:\Security\Downloads\Microsoft Security Compliance Toolkit\LGPO.zip"

# Policy Analyzer
Write-Host "Downloading Policy Analyzer"
Invoke-WebRequest -Uri https://download.microsoft.com/download/8/5/c/85c25433-a1b0-4ffa-9429-7e023e7da8d8/PolicyAnalyzer.zip -OutFile "C:\Security\Downloads\Microsoft Security Compliance Toolkit\PolicyAnalyzer.zip"

#Set Object Security
Write-Host "Downloading Set Object Security"
Invoke-WebRequest -Uri https://download.microsoft.com/download/8/5/c/85c25433-a1b0-4ffa-9429-7e023e7da8d8/SetObjectSecurity.zip -OutFile "C:\Security\Downloads\Microsoft Security Compliance Toolkit\SetObjectSecurity.zip"

#Windows 11 v24H2 Security Baseline
Write-Host "Downloading Windows 11 v24H2 Security Baseline"
Invoke-WebRequest -Uri https://download.microsoft.com/download/8/5/c/85c25433-a1b0-4ffa-9429-7e023e7da8d8/Windows%2011%20v24H2%20Security%20Baseline.zip -OutFile "C:\Security\Downloads\Microsoft Security Compliance Toolkit\Windows 11 v24H2nSecurity Baseline.zip"

#Microsoft 365 Apps for Enterprise 
Write-Host "Downloading Microsoft 365 Apps for Enterprise"
Invoke-WebRequest -Uri https://download.microsoft.com/download/8/5/c/85c25433-a1b0-4ffa-9429-7e023e7da8d8/Microsoft%20365%20Apps%20for%20Enterprise%202412.zip -OutFile "C:\Security\Downloads\Microsoft Security Compliance Toolkit\Microsoft 365 Apps for Enterprise 2412.zip"

#Microsoft Edge v128 Security Baseline
Write-Host "Downloading Microsoft Edge v128 Security Baseline"
Invoke-WebRequest -Uri https://download.microsoft.com/download/8/5/c/85c25433-a1b0-4ffa-9429-7e023e7da8d8/Microsoft%20Edge%20v128%20Security%20Baseline.zip -OutFile "C:\Security\Downloads\Microsoft Security Compliance Toolkit\Microsoft Edge v128 Security Baseline.zip"

#Windows 11 Security Baseline
Write-Host "Downloading Windows 11 Security Baseline"
Invoke-WebRequest -Uri https://download.microsoft.com/download/8/5/c/85c25433-a1b0-4ffa-9429-7e023e7da8d8/Windows%2011%20Security%20Baseline.zip -OutFile "C:\Security\Downloads\Microsoft Security Compliance Toolkit\Windows 11 Security Baseline.zip"

#Windows Server 2025 Security Baseline
Write-Host "Downloading Windows Server 2025 Security Baseline"
Invoke-WebRequest -Uri https://download.microsoft.com/download/8/5/c/85c25433-a1b0-4ffa-9429-7e023e7da8d8/Windows%20Server%202025%20Security%20Baseline.zip -OutFile "C:\Security\Downloads\Microsoft Security Compliance Toolkit\Windows Server 2025 Security Baseline.zip"

#Windows Server Security Baseline
Write-Host "Downloading Windows Server Security Baseline"
Invoke-WebRequest -Uri https://download.microsoft.com/download/8/5/c/85c25433-a1b0-4ffa-9429-7e023e7da8d8/Windows%2011%20Security%20Baseline.zip -OutFile "C:\Security\Downloads\Microsoft Security Compliance Toolkit\Windows 11 Security Baseline.zip"

}

Function Unzip-File {
    param(
        [string]$zipFilePath,
        [string]$destinationPath
    )
    
    # Check if the zip file exists
    if (-Not (Test-Path $zipFilePath)) {
        Write-Host "The specified ZIP file does not exist: $zipFilePath" -ForegroundColor Red
        return
    }
    
    # Check if the destination directory exists, if not, create it
    if (-Not (Test-Path $destinationPath)) {
        Write-Host "Destination directory does not exist. Creating: $destinationPath" -ForegroundColor Yellow
        New-Item -ItemType Directory -Path $destinationPath
    }
    
    # Unzip the file
    try {
        Write-Host "Extracting files to: $destinationPath" -ForegroundColor Green
        Expand-Archive -Path $zipFilePath -DestinationPath $destinationPath -Force
        Write-Host "Extraction completed successfully." -ForegroundColor Green
    } catch {
        Write-Host "An error occurred during extraction: $_" -ForegroundColor Red
    }
}

Function Unzip-Files {

# # Clear-Host; 

Write-Host `n

Write-Host "Decompressing Security Compliance Checker Installer. `n"

Unzip-File -zipFilePath "C:\Security\Downloads\scc-5.10.1_Windows_bundle.zip" -destinationPath "C:\Security\Temp\Security Compliance Checker"

Write-Host "Decompressing Windows Security Compliance Checker App. `n"

Unzip-File -zipFilePath "C:\Security\Temp\Security Compliance Checker\scc-5.10.1_Windows\scc-5.10.1_Windows.zip" -destinationPath "C:\Security\Security Compliance Checker"

Write-Host "Decompressing US DoD STIG GPO Package for January 2025. `n"

Unzip-File -zipFilePath "C:\Security\Downloads\U_STIG_GPO_Package_January_2025.zip" -destinationPath "C:\Security\STIG GPO Package January 2025"

Write-Host "Decompressing LGPO"

Unzip-File -zipFilePath "C:\Security\Downloads\Microsoft Security Compliance Toolkit\LGPO.zip" -destinationPath "C:\Security\Microsoft Security Compliance Toolkit\LGPO"

Write-Host "Decompressing Policy Analyzer"

Unzip-File -zipFilePath "C:\Security\Downloads\Microsoft Security Compliance Toolkit\PolicyAnalyzer.zip" -destinationPath "C:\Security\Microsoft Security Compliance Toolkit\PolicyAnalyzer"

Write-Host "Decompressing Set Object Security"

Unzip-File -zipFilePath "C:\Security\Downloads\Microsoft Security Compliance Toolkit\SetObjectSecurity.zip" -destinationPath "C:\Security\Microsoft Security Compliance Toolkit\SetObjectSecurity"

Write-Host "Decompressing Windows 11 v24H2 Security Baseline"

Unzip-File -zipFilePath "C:\Security\Downloads\Microsoft Security Compliance Toolkit\Windows 11 v24H2 Security Baseline.zip" -destinationPath "C:\Security\Microsoft Security Compliance Toolkit\Windows 11 v24H2 Security Baseline" 

Write-Host "Decompressing Microsoft 365 Apps for Enterprise"

Unzip-File -zipFilePath "C:\Security\Downloads\Microsoft Security Compliance Toolkit\Microsoft 365 Apps for Enterprise 2412.zip" -destinationPath "C:\Security\Microsoft Security Compliance Toolkit\Microsoft 365 Apps for Enterprise 2412"

Write-Host "Decompressing Microsoft Edge v128 Security Baseline"

Unzip-File -zipFilePath "C:\Security\Downloads\Microsoft Security Compliance Toolkit\Microsoft Edge v128 Security Baseline.zip" -destinationPath "C:\Security\Microsoft Security Compliance Toolkit\Microsoft Edge v128 Security Baseline"

Write-Host "Decompressing Windows 11 Security Baseline"

Unzip-File -zipFilePath "C:\Security\Downloads\Microsoft Security Compliance Toolkit\Windows 11 Security Baseline.zip" -destinationPath "C:\Security\Microsoft Security Compliance Toolkit\Windows 11 Security Baseline"

Write-Host "Decompressing Windows Server 2025 Security Baseline"

Unzip-File -zipFilePath "C:\Security\Downloads\Microsoft Security Compliance Toolkit\Windows Server 2025 Security Baseline.zip" -destinationPath "C:\Security\Microsoft Security Compliance Toolkit\Windows Server 2025 Security Baseline"

Write-Host "Decompressing Windows 11 Security Baseline"

Unzip-File -zipFilePath "C:\Security\Downloads\Microsoft Security Compliance Toolkit\Windows 11 Security Baseline.zip" -destinationPath "C:\Security\Microsoft Security Compliance Toolkit\Windows 11 Security Baseline" 
 
}

Function Update-Options {

Write-Host "Rename orginal options.xml file"
Rename-Item -Path "C:\Security\Security Compliance Checker\scc_5.10.1\options.xml" -NewName "C:\Security\Security Compliance Checker\scc_5.10.1\options.xml.old"

Write-Host "Download Options.xml from repo"
Invoke-WebRequest -Uri https://raw.githubusercontent.com/s0nt3k/PowerShell/refs/heads/main/misc/options.xml -OutFile "C:\Security\Security Compliance Checker\scc_5.10.1\options.xml"


}

Function Start-SecurityComplianceScan {

Start-Process -FilePath "C:\Security\Security Compliance Checker\scc_5.10.1\cscc.exe"

}

Function Open-Windows11STIGHTML {
    param(
        [string]$searchPath = "C:\Security\Security Compliance Scan Results\",
        [string]$filePattern = "*SCC_Summary_Viewer*.html"
    )

    # Search for the file in the specified directory and subdirectories
    $file = Get-ChildItem -Path $searchPath -Recurse -Filter $filePattern -File

    # Check if the file is found
    if ($file) {
        Write-Host "File found: $($file.FullName)" -ForegroundColor Green
        # Open the file in the default web browser
        Start-Process $file.FullName
    } else {
        Write-Host "No file matching '$filePattern' found in $searchPath." -ForegroundColor Red
    }
}

Function Execute-Functions {
Clear-Host

Ensure-Admin
Create-DirectoryStructure
Download-Files
Unzip-Files
Update-Options
Start-SecurityComplianceScan
Start-Sleep -Seconds 60
Read-Host -Prompt "When Scan Has Finished Press [Enter] key to view your report"
Open-Windows11STIGHTML

}

Execute-Functions