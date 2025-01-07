Function Set-GlobalVarables {

Clear-Host
# Set global varables

$Global:FullDateTime = (Get-Date)
$Global:DateTime = (Get-Date -Format "| yyyy-MM-dd | HH:mm")
$Global:DirName = (Get-Date -Format "DyyMMddTHHmmss")
$Global:EventLOG = ".\logs\seclog.txt"
$Global:BoarderForeColor = "Yellow"
$Global:MenuTitleForeColor = "Green"
$Global:MenuOptionColor = "Yellow"
$Global:MenuForeColor = "Cyan"
$Global:FooterMenuForeColor = "Green"

} # End: Set-GlobalVarables

Function Show-ProgressBar {

    # This function displays a progress bar in the Windows Terminal, PowerShell or Command prompt

    Param(
        [String]$Activity = "Running Cmdlets",
        [String]$Status = "Processing...",
        [Int]$Id = '1',
        [Int]$Increments = '10',
        [Int]$MillisecondsDelay = "500"

    )
    
    For ($X = 1; $X -lt 100; $X+=$Increments) {
        Write-Progress -Activity $Activity $Status -Id $Id -PercentComplete $X
        Start-Sleep -Milliseconds $MillisecondsDelay
    }
} # End: Show-ProgressBar

function Show-PopupWindowMessage {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, HelpMessage = "The message to display in the popup window.")]
        [string]$Message,

        [Parameter(Mandatory = $true, HelpMessage = "The title of the popup window.")]
        [string]$Title,

        [Parameter(Mandatory = $false, HelpMessage = "The button type: 'OK', 'YesNo', or 'YesNoCancel'.")]
        [ValidateSet("OK", "YesNo", "YesNoCancel")]
        [string]$ButtonType = "OK"
    )

<#
.SYNOPSIS
    Displays a popup window with customizable buttons (OK, Yes/No, or Yes/No/Cancel).

.DESCRIPTION
    This function uses the Windows Presentation Foundation (WPF) to create a popup dialog box.
    You can specify whether to display "OK", "Yes/No", or "Yes/No/Cancel" buttons.

.PARAMETER Message
    The message displayed in the popup window.

.PARAMETER Title
    The title of the popup window.

.PARAMETER ButtonType
    Specifies the button type to display: "OK", "YesNo", or "YesNoCancel". Default is "OK".

.EXAMPLE
    Show-PopupWindow -Message "Operation completed successfully!" -Title "Info" -ButtonType "OK"

    Displays a popup window with an "OK" button.

.EXAMPLE
    Show-PopupWindow -Message "Do you want to continue?" -Title "Confirmation" -ButtonType "YesNo"

    Displays a popup window with "Yes" and "No" buttons and returns the user's response.

.EXAMPLE
    Show-PopupWindow -Message "Save changes before exiting?" -Title "Save Changes" -ButtonType "YesNoCancel"

    Displays a popup window with "Yes", "No", and "Cancel" buttons and returns the user's response.

.NOTES
    Author:......... s0nt3k
    E-Mail:......... s0nt3k@protonmail.com
    Date:........... January 6, 2025
    Function IdN:... 343-100-0001
    Version:........ 1.0.5021
#>

    Add-Type -AssemblyName PresentationFramework

    switch ($ButtonType) {
        "OK" {
            [System.Windows.MessageBox]::Show($Message, $Title, [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information) | Out-Null
        }
        "YesNo" {
            $result = [System.Windows.MessageBox]::Show($Message, $Title, [System.Windows.MessageBoxButton]::YesNo, [System.Windows.MessageBoxImage]::Question)
            return $result
        }
        "YesNoCancel" {
            $result = [System.Windows.MessageBox]::Show($Message, $Title, [System.Windows.MessageBoxButton]::YesNoCancel, [System.Windows.MessageBoxImage]::Question)
            return $result
        }
    }
} # End: Show-PopupWindow

function Copy-AndChangeDirectory {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false)]
        [string]$SourceFilePath = "./HostBlocking.ps1",

        [Parameter(Mandatory=$false)]
        [string]$DestinationDirectory = "C:\xTekFolder\Hosts-Script"
    )

    try {
        # Ensure the destination directory exists, create it if not
        if (-not (Test-Path -Path $DestinationDirectory -PathType Container)) {
            New-Item -ItemType Directory -Path $DestinationDirectory -Force | Out-Null
            Write-Host "Created directory: $DestinationDirectory" -ForegroundColor Green
        }

        # Copy the file to the destination directory
        Copy-Item -Path $SourceFilePath -Destination $DestinationDirectory -Force
        Write-Host "File '$SourceFilePath' copied to '$DestinationDirectory'" -ForegroundColor Green

        # Change the current working directory
        Set-Location -Path $DestinationDirectory
        Write-Host "Current working directory changed to '$DestinationDirectory'" -ForegroundColor Green
    }
    catch {
        Write-Host "An error occurred: $_" -ForegroundColor Red
    }
} # End: Copy-AndChangeDirectory

function Ensure-DirectoryExists {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false)]
        [string]$DirectoryPath = ".\bin"
    )

    try {
        # Check if the directory exists
        if (-not (Test-Path -Path $DirectoryPath -PathType Container)) {
            # Create the directory if it doesn't exist
            New-Item -ItemType Directory -Path $DirectoryPath -Force | Out-Null
            Write-Host "Directory '$DirectoryPath' was created successfully." -ForegroundColor Green
        }
        else {
            Write-Host "Directory '$DirectoryPath' already exists." -ForegroundColor Yellow
        }
    }
    catch {
        Write-Host "An error occurred: $_" -ForegroundColor Red
    }
} # End: Ensure-DirectoryExists

function SetupDirectories {

Ensure-DirectoryExists -DirectoryPath C:\xTekFolder\Hosts-Script

Copy-AndChangeDirectory

Ensure-DirectoryExists -DirectoryPath .\bin

Ensure-DirectoryExists -DirectoryPath .\log

Ensure-DirectoryExists -DirectoryPath .\pub
} # End: SetupDirectories

function Ensure-ScriptSetup {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false)]
        [string]$ExpectedDirectory = "C:\xTekFolder\Hosts-Script"
    )

    try {
        # Get the current directory
        $currentDirectory = Get-Location

        # Check if the current directory matches the expected directory
        if ($currentDirectory.Path -ne $ExpectedDirectory) {
            Write-Host "Current directory is not '$ExpectedDirectory'. Calling SetupDirectories..." -ForegroundColor Yellow
            SetupDirectories
        }
        else {
            Show-TelemetryBlockingMenu
        }
    }
    catch {
        Write-Host "An error occurred in Ensure-CurrentDirectory: $_" -ForegroundColor Red
    }
} # End: Ensure-ScriptSetup

function Get-LineFromOnlineFile {
    param (
        [Parameter(Mandatory=$false)]
        [string]$Url = "https://gitlab.com/hagezi/mirror/-/raw/main/dns-blocklists/hosts/native.winoffice.txt",        # The URL of the online text file
        
        [Parameter(Mandatory=$true)]
        [int]$LineNumber     # The line number to extract
    )
    
    try {
        # Fetch the content of the file
        $fileContent = (Invoke-WebRequest -Uri $Url -UseBasicParsing).Content
        
        # Convert the content into an array of lines
        $lines = $fileContent -split "`r?`n"
        
        # Validate the line number
        if ($LineNumber -lt 1 -or $LineNumber -gt $lines.Length) {
            Write-Error "Line number $LineNumber is out of range. The file has $($lines.Length) lines."
            return
        }
        
        # Assign the text of the specified line to the variable
        $script:LineText = $lines[$LineNumber - 1]
       # Write-Output "Line $LineNumber $script:LineText"
       $VersionNumber = $script:LineText.Substring(11)
        Write-Host "  " -NoNewLine
        Write-Host "Online Telemetry Blocklist Version:..... " -ForegroundColor Yellow -BackgroundColor Blue -NoNewLine
        Write-Host "$VersionNumber" -ForegroundColor Green -BackgroundColor Black
        
    } catch {
        Write-Error "An error occurred: $_"
    }
} # End: Get-LineFromOnlineFile

function Get-InstalledHostsFileLine {
    param (
        [Parameter(Mandatory = $true)]
        [int]$LineNumber     # The line number to extract
    )
    
    try {
        # Define the path to the Windows hosts file
        $hostsFilePath = "$env:WinDir\System32\drivers\etc\hosts"
        
        # Check if the hosts file exists
        if (-Not (Test-Path -Path $hostsFilePath)) {
            Write-Error "Hosts file not found at $hostsFilePath"
            return
        }
        
        # Read the content of the hosts file
        $fileContent = Get-Content -Path $hostsFilePath
        
        # Validate the line number
        if ($LineNumber -lt 1 -or $LineNumber -gt $fileContent.Length) {
            Write-Error "Line number $LineNumber is out of range. The file has $($fileContent.Length) lines."
            return
        }
        
        # Assign the text of the specified line to the variable
        $script:LineText = $fileContent[$LineNumber - 1]
      #  Write-Output "Line $LineNumber $script:LineText"

        $VersionNumber = $LineText.Substring(11)
        
        Write-Host "  " -NoNewLine
        Write-Host "Installed Telemetry Blocklist Version:.. " -ForegroundColor Yellow -BackgroundColor Blue -NoNewLine
        Write-Host "$VersionNumber`n" -ForegroundColor Green -BackgroundColor Black
    } catch {
        Write-Error "An error occurred: $_"
    }
} # End: Get-InstalledHostsFileLine

function Find-HostsFileLineNumber {
    param (
        [Parameter(Mandatory = $true)]
        [string]$SearchString # The string to search for in the hosts file
    )
    
    try {
        # Define the path to the Windows hosts file
        $hostsFilePath = "$env:WinDir\System32\drivers\etc\hosts"
        
        # Check if the hosts file exists
        if (-Not (Test-Path -Path $hostsFilePath)) {
            Write-Error "Hosts file not found at $hostsFilePath"
            return
        }
        
        # Read the content of the hosts file
        $fileContent = Get-Content -Path $hostsFilePath
        
        # Search for the string and get the line index
        $index = $fileContent | Select-String -Pattern $SearchString | Select-Object -First 1 -ExpandProperty LineNumber
        
        if ($null -eq $index) {
            Write-Output "String '$SearchString' not found in the hosts file."
            $script:LineNumber = $null
        } else {
            # Assign the line number to the variable
            $script:LineNumber = $index
           # Write-Output "String '$SearchString' found on line $LineNumber."
            Return $LineNumber
        }
    } catch {
        Write-Error "An error occurred: $_"
    }
} # End: Find-HostsFileLineNumber

function Check-TelemetryBlocklistStatus {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false)]
        [string]$FilePath = "$env:windir\System32\drivers\etc\hosts"
    )

    try {
        # Ensure the script is running with administrative privileges
        if (-not (Test-Path -Path $FilePath)) {
            throw "The specified Hosts file was not found: $FilePath"
        }

        # Read the contents of the Hosts file
        $hostsContent = Get-Content -Path $FilePath -ErrorAction Stop

        # Search for the specific string
        if ($hostsContent -match "# Title: HaGeZi's Windows/Office Tracker DNS Blocklist") {
            Write-Host
            Write-Host "  " -NoNewLine
            Write-Host "Microsoft Telemetry Blocklist Status:... " -ForegroundColor Yellow -BackgroundColor Blue -NoNewLine
            Write-Host "DNSList Installed" -ForegroundColor Green -BackgroundColor Black

            $EntryCount = Manage-WindowsHostsFile -Action Count-Entries
            Write-Host "  " -NoNewLine
            Write-Host "Windows Hosts File Total Entry Count:... " -ForegroundColor Yellow -BackgroundColor Blue -NoNewLine
            Write-Host "$EntryCount Valid Entries" -ForegroundColor Green -BackgroundColor Black
            Write-Host

            Get-LineFromOnlineFile -LineNumber 8
            $GetLineNumber = Find-HostsFileLine -SearchString "# Version:"
            Get-InstalledHostsFileLine -LineNumber $GetLineNumber


        }
        else {
             Write-Host
             Write-Host "  " -NoNewLine
             Write-Host "Microsoft Telemetry Blocklist Status:.... " -ForegroundColor Yellow -BackgroundColor Blue -NoNewLine
             Write-Host " Not Installed " -ForegroundColor Green -BackgroundColor Black

             $EntryCount = Manage-WindowsHostsFile -Action Count-Entries

             Write-Host "  " -NoNewLine
             Write-Host "Windows Hosts File Total Entry Count:.... " -ForegroundColor Yellow -BackgroundColor Blue -NoNewLine
             Write-Host "$EntryCount Valid Entries" -ForegroundColor Green -BackgroundColor Black
             Write-Host
        }
    }
    catch {
        Write-Host "An error occurred: $_" -ForegroundColor Red
    }
} # End: Check-TelemetryBlocklistStatus

# Script Menus

function Show-TelemetryBlockingMenu {
    Clear-Host
    Write-Host " ============================================================= " -ForegroundColor $BoarderForeColor
  
    Check-TelemetryBlocklistStatus
  
    Write-Host " ============================================================= " -ForegroundColor $BoarderForeColor   
    Write-Host " |               Telemetry Blocking Script Menu              | " -ForegroundColor $MenuTitleForeColor 
    Write-Host " ============================================================= " -ForegroundColor $BoarderForeColor 
    Write-Host "                                                            " -ForegroundColor $MenuForeColor      
	Write-Host "  [1] Install"                                                      -ForegroundColor $MenuOptionColor     -NoNewLine
 #  Write-Host "Block Microsoft Windows & Office Telemetry Data.      "       -ForegroundColor $MenuForeColor
    Write-Host " Microsoft Native Telemetry DNS-Blocklist. "       -ForegroundColor $MenuForeColor      
	Write-Host "  [2] Remove"                                                      -ForegroundColor $MenuOptionColor     -NoNewLine
#   Write-Host "Unblock Microsoft Windows & Office Telemetry Data.    "       -ForegroundColor $MenuForeColor       
    Write-Host "  Microsoft Native Telemetry DNS-Blocklist. "       -ForegroundColor $MenuForeColor
	Write-Host "  [3] Update"                                                      -ForegroundColor $MenuOptionColor     -NoNewLine
    Write-Host "  Microsoft Native Telemetry DNS-Blocklist. "       -ForegroundColor $MenuForeColor
	Write-Host
    Write-Host "  [4] Update"                                                      -ForegroundColor Gray     -NoNewLine
    Write-Host "  Network Adapter DNS Server IP Addresses.          "       -ForegroundColor Gray       
    Write-Host "                                                            " -ForegroundColor $MenuForeColor       
    Write-Host " ============================================================= " -ForegroundColor $BoarderForeColor  
    Write-Host " | [M]ain Menu | [H]ost File Menu | [S]ettings | [T]erminate | " -ForegroundColor $FooterMenuForeColor
    Write-Host " ============================================================= " -ForegroundColor $BoarderForeColor
    
    $choice = Read-Host "`nPlease select an option"

    switch ($choice) {
        1 { MenuOption1; Show-TelemetryBlockingMenu }
        2 { MenuOption2; Show-TelemetryBlockingMenu }
        3 { Write-Output "`nMenu: Option[03]`n"; Pause; Show-TelemetryBlockingMenu }
        M { Main-Menu }
        H { Show-WindowsHostsFileMenu }
        S { Settings-Menu }
        T { Exit-Script }
        default {
            Write-Host "`nInvalid choice. Please try again.`n"
            Pause
            Show-TelemetryBlockingMenu
        }
    }
} # End: Show-TelemetryBlockingMenu

function Show-WindowsHostsFileMenu {
    Clear-Host
    Write-Host " ============================================================= " -ForegroundColor $BoarderForeColor    
    Write-Host " |                  Windows Hosts File Menu                  | " -ForegroundColor $MenuTitleForeColor 
    Write-Host " ============================================================= " -ForegroundColor $BoarderForeColor   
    Write-Host "                                                              " -ForegroundColor $MenuForeColor      
	Write-Host "    [ 1] "                                                      -ForegroundColor $MenuOptionColor     -NoNewLine
    Write-Host "Create Windows Hosts File Backup.                       "       -ForegroundColor $MenuForeColor      
	Write-Host "    [ 2] "                                                      -ForegroundColor $MenuOptionColor     -NoNewLine
    Write-Host "Restore Windows Hosts File Backup.                      "       -ForegroundColor $MenuForeColor       
	Write-Host "    [ 3] "                                                      -ForegroundColor $MenuOptionColor     -NoNewLine
    Write-Host "Rebild Orginial Windows OEM Hosts File.                 "       -ForegroundColor $MenuForeColor
	Write-Host "    [ 4] "                                                      -ForegroundColor Gray     -NoNewLine       
    Write-Host "Add a Single Windows Hosts File Entry.                    "       -ForegroundColor Gray
	Write-Host "    [ 5] "                                                      -ForegroundColor Gray     -NoNewLine       
    Write-Host "Add Windows Hosts Entery List from File.                   "       -ForegroundColor Gray
	Write-Host "    [ 6] "                                                      -ForegroundColor Gray     -NoNewLine       
    Write-Host "Remove a Single Windows Hosts File Entry.                 "       -ForegroundColor Gray
	Write-Host "    [ 7] "                                                      -ForegroundColor Gray     -NoNewLine       
    Write-Host "Remove Windows Hosts Entry List from File.                "       -ForegroundColor Gray       
 	Write-Host "    [ 8] "                                                      -ForegroundColor $MenuOptionColor     -NoNewLine       
    Write-Host "Check for Douplicate Entries and Remove.                   "       -ForegroundColor $MenuForeColor 
	Write-Host "    [ 9] "                                                      -ForegroundColor $MenuOptionColor     -NoNewLine       
    Write-Host "Count The Total Number of Hosts Entries.                   "       -ForegroundColor $MenuForeColor 
	Write-Host "    [10] "                                                      -ForegroundColor $MenuOptionColor     -NoNewLine       
    Write-Host "Add Hosts File to Defender's Exclusion List.         "       -ForegroundColor $MenuForeColor
	Write-Host "    [11] "                                                      -ForegroundColor $MenuOptionColor     -NoNewLine       
    Write-Host "Remove Hosts File from Defender's Exclusion List.         "       -ForegroundColor $MenuForeColor
	Write-Host "    [12] "                                                      -ForegroundColor $MenuOptionColor     -NoNewLine       
    Write-Host "Verify Hosts File is Excluded from Defender.         "       -ForegroundColor $MenuForeColor
    Write-Host " ============================================================= " -ForegroundColor $BoarderForeColor 
    Write-Host " | [M]ain Menu | [P]revious Menu | [S]ettings | [T]erminate  | " -ForegroundColor $FooterMenuForeColor
    Write-Host " ============================================================= " -ForegroundColor $BoarderForeColor
    
    $choice = Read-Host "`nPlease select an option"

    switch ($choice) {
        1 { Manage-WindowsHostsFile -Action Backup-HostsFile; Show-WindowsHostsFileMenu }
        2 { Manage-WindowsHostsFile -Action Restore-HostsBackup; Show-WindowsHostsFileMenu }
        3 { Manage-WindowsHostsFile -Action Rebuild-Original; Show-WindowsHostsFileMenu }
        4 { Write-Output "Menu: option [04]" }
        5 { Write-Output "Menu: option [05]" }
        6 { Write-Output "Menu: option [06]" }
        7 { Write-Output "Menu: option [07]" }
        8 { Manage-WindowsHostsFile -Action Remove-Duplicates; Show-WindowsHostsFileMenu }
        9 { $EntryCount = Manage-WindowsHostsFile -Action Count-Entries
            Show-PopupWindowMessage -Message "The Windows Hosts File has $EntryCount Valid Entries" -Title "s0nt3k PS1 Script"
            Show-WindowsHostsFileMenu 
          }
       10 { Manage-DefenderHostsExclusion -Action Enable; Show-WindowsHostsFileMenu }
       11 { Manage-DefenderHostsExclusion -Action Disable; Show-WindowsHostsFileMenu }
       12 { Manage-DefenderHostsExclusion -Action Status; Show-WindowsHostsFileMenu }
        M { Main-Menu }
        P { Show-TelemetryBlockingMenu }
        S { Settings-Menu }
        T { Exit-Script }
        default {
            Write-Host "`nInvalid choice. Please try again.`n"
            Pause
            Show-WindowsHostsFileMenu
        }
    }
} # End: Show-WindowsHostsFileMenu


function Move-XbinFiles {
    # Define the source and destination directories
    $SourceDir = "./bin"
    $DestinationDir = "./bin/prexbins"

    # Ensure the destination directory exists
    if (-not (Test-Path -Path $DestinationDir)) {
        Write-Host "Creating destination directory: $DestinationDir" -ForegroundColor Yellow
        New-Item -Path $DestinationDir -ItemType Directory | Out-Null
    }

    # Get all .xbin files in the source directory
    $xbinFiles = Get-ChildItem -Path $SourceDir -Filter "*.xbin" -File

    if ($xbinFiles.Count -eq 0) {
        Write-Host "No .xbin files found in the source directory." -ForegroundColor Cyan
        return
    }

    # Move each .xbin file to the destination directory
    foreach ($file in $xbinFiles) {
        try {
            Move-Item -Path $file.FullName -Destination $DestinationDir
            Write-Host "Moved file: $($file.Name) to $DestinationDir" -ForegroundColor Green
        } catch {
            Write-Host "Error moving file: $($file.Name). $_" -ForegroundColor Red
        }
    }
} # End: Move-XbinFiles


function Manage-DefenderHostsExclusion {
    param (
        [ValidateSet("Enable", "Disable", "Status")]
        [string]$Action
    )

    $FunctionName = "Manage-DefenderHostsExclusion  "

    # Define the path to the Windows hosts file
    $HostsFilePath = "C:\\Windows\\System32\\drivers\\etc\\hosts"

    # Get the current list of Defender exclusions
    $Exclusions = Get-MpPreference | Select-Object -ExpandProperty ExclusionPath

    switch ($Action) {
        "Enable" {
            if ($HostsFilePath -in $Exclusions) {
             #   $StatusMessage = "The hosts file is already in the Windows Defender exclusions list."
             #   Out-File -FilePath $EventLOG -InputObject "$DateTime | $FunctionName | $StatusMessage |" -Append
             Show-PopupWindowMessage -Message "The hosts file is already in the Windows Defender exclusions list." -Title "s0nt3k's PS1 Script" -ButtonType OK
            } else {
                Add-MpPreference -ExclusionPath $HostsFilePath
              #  $StatusMessage = "The hosts file has been added to the Windows Defender exclusions list."
              #  Out-File -FilePath $EventLOG -InputObject "$DateTime | $FunctionName | $StatusMessage |" -Append
              Show-PopupWindowMessage -Message "The hosts file has been added to the Windows Defender exclusions list." -Title "s0nt3k's PS1 Script" -ButtonType OK
            }
        }

        "Disable" {
            if ($HostsFilePath -in $Exclusions) {
                Remove-MpPreference -ExclusionPath $HostsFilePath
              #  $StatusMessage = "The hosts file has been removed from the Windows Defender exclusions list."
              #  Out-File -FilePath $EventLOG -InputObject "$DateTime | $FunctionName | $StatusMessage |" -Append
               Show-PopupWindowMessage -Message "The hosts file has been removed from the Windows Defender exclusions list." -Title "s0nt3k's PS1 Script" -ButtonType OK
            } else {
              #  $StatusMessage = "The hosts file is not in the Windows Defender exclusions list."
              #  Out-File -FilePath $EventLOG -InputObject "$DateTime | $FunctionName | $StatusMessage |" -Append
              Show-PopupWindowMessage -Message "The hosts file is not in the Windows Defender exclusions list." -Title "s0nt3k's PS1 Script" -ButtonType OK
            }
        }

        "Status" {
            if ($HostsFilePath -in $Exclusions) {
              #  $StatusMessage = "The hosts file is currently in the Windows Defender exclusions list."
                Show-PopupWindowMessage -Message "The Windows Hosts file is currently listed in the Windows Defender exclusions list." -Title "s0nt3k's PS1 Script" -ButtonType OK
                Out-File -FilePath $EventLOG -InputObject "$DateTime | $FunctionName | $StatusMessage |" -Append
            } else {
              #  $StatusMessage = "The hosts file is not in the Windows Defender exclusions list."
                Show-PopupWindowMessage -Message "The Windows Hosts file is not listed in the Windows Defender exclusions list." -Title "s0nt3k's PS1 Script" -ButtonType OK
                Out-File -FilePath $EventLOG -InputObject "$DateTime | $FunctionName | $StatusMessage |" -Append
            }
        }
    }

    Write-Output $StatusMessage
} # End: Manage-DefenderHostsExclusion

function Manage-RealTimeProtection {
    param (
        [Parameter(Mandatory = $true)]
        [ValidateSet('Enable', 'Disable', 'Show')]
        [string]$Status,

        [int]$Time
    )

    $FunctionName = "Manage-RealTimeProtection      "

    function Show-ProgressBar {
        param (
            [int]$Duration
        )
        $progress = 0
        $increment = 100 / $Duration

        for ($i = 0; $i -lt $Duration; $i++) {
            $progress += $increment
            Write-Progress -Activity "Windows Defender Real-Time Protection" -Status "Time Remaining: $(($Duration - $i))" -PercentComplete $progress
            Start-Sleep -Seconds 1
        }
    }

    $StatusMessage = ""

    switch ($Status) {
        'Enable' {
            $StatusMessage = "Enabling Windows Defender Real-Time Protection..."
            Set-MpPreference -DisableRealtimeMonitoring $false
            Out-File -FilePath $EventLOG -InputObject "$DateTime | $FunctionName | $StatusMessage |" -Append
        }
        'Disable' {
            $StatusMessage = "Disabling Windows Defender Real-Time Protection..."
            Set-MpPreference -DisableRealtimeMonitoring $true
            Out-File -FilePath $EventLOG -InputObject "$DateTime | $FunctionName | $StatusMessage |" -Append
        }
        'Show' {
            $state = Get-MpPreference | Select-Object -ExpandProperty DisableRealtimeMonitoring
            if ($state) {
                $StatusMessage = "Windows Defender Real-Time Protection is currently DISABLED."
                Out-File -FilePath $EventLOG -InputObject "$DateTime | $FunctionName | $StatusMessage |" -Append
            } else {
                $StatusMessage = "Windows Defender Real-Time Protection is currently ENABLED."
                Out-File -FilePath $EventLOG -InputObject "$DateTime | $FunctionName | $StatusMessage |" -Append
            }
        }
    }

    if ($Time -and ($Status -eq 'Enable' -or $Status -eq 'Disable')) {
        Show-ProgressBar -Duration $Time

        # Reverse the action after the specified time
        if ($Status -eq 'Enable') {
            $StatusMessage = "Disabling Windows Defender Real-Time Protection after $Time seconds..."
            Out-File -FilePath $EventLOG -InputObject "$DateTime | $FunctionName | $StatusMessage |" -Append
            Set-MpPreference -DisableRealtimeMonitoring $true
        } elseif ($Status -eq 'Disable') {
            $StatusMessage = "Enabling Windows Defender Real-Time Protection after $Time seconds..."
            Out-File -FilePath $EventLOG -InputObject "$DateTime | $FunctionName | $StatusMessage |" -Append
            Set-MpPreference -DisableRealtimeMonitoring $false
        }
    }

    Write-Host $StatusMessage
} # End: Manage-RealTimeProtection

function Manage-WindowsHostsFile {
    param(
        [ValidateSet('Backup-HostsFile', 'Restore-HostsBackup', 'Rebuild-Original', 'Count-Entries', 'Remove-Duplicates', 'Format-HostsFile')]
        [string]$Action,
        [string]$Backup = "%WinDir%\System32\drivers\etc\hosts"
    )

    # Define the default hosts file location
    $hostsFilePath = "C:\Windows\System32\drivers\etc\hosts"

    # Ensure the hosts file exists
    if (-not (Test-Path -Path $hostsFilePath)) {
        Write-Error "The hosts file does not exist at the expected location: $hostsFilePath"
        return
    }

    switch ($Action) {

        'Backup-HostsFile' {

        $BackupFilePath = "./Pub/"

            try {
                # Ensure the Backup-HostsFile directory exists
                if (-not (Test-Path -Path $BackupFilePath)) {
                    New-Item -ItemType Directory -Path $BackupFilePath -Force | Out-Null
                }

                # Create a Backup-HostsFile of the hosts file
                $Backup = Join-Path -Path $BackupFilePath -ChildPath "hosts_Backup-HostsFile_$(Get-Date -Format yyyyMMddHHmmss).txt"
                Copy-Item -Path $hostsFilePath -Destination $Backup-HostsFileFile -Force

                Write-Output "Hosts file backed up successfully to: $Backup-HostsFileFile"
            } catch {
                Write-Error "Failed to back up the hosts file: $_"
            }
        }  # End of Backup-HostsFile

        'Restore-HostsBackup' {

        $BackupFilePath = "./Pub/"

            try {
                # Check if any Backup-HostsFile files exist
                $Backup = Get-ChildItem -Path $BackupFilePath -Filter "hosts_Backup-HostsFile_*.txt" | Sort-Object -Property LastWriteTime -Descending

                if (-not $Backup) {
                    Write-Error "No Backup-HostsFile files found in the directory: $BackupFilePath"
                    return
                }

                # Use the latest Backup-HostsFile file
                $latestBackup = $Backup[0].FullName

                Copy-Item -Path $latestBackup-HostsFile -Destination $hostsFilePath -Force
                Write-Output "Hosts file Restore-HostsBackupd successfully from: $latestBackup-HostsFile"
            } catch {
                Write-Error "Failed to Restore-HostsBackup the hosts file: $_"
            }
            
        } # End of Restore-HostsBackup

        'Rebuild-Original' {
               # Set Orginal Hosts File Path
                $OriginalFilePath = "$env:SystemRoot\System32\drivers\etc\hosts"

                # Restore-HostsBackup the original hosts file content
    
                try {
                    Write-Output "Restoring the original hosts file content..."

        $defaultContent = @"
# Copyright (c) 1993-2009 Microsoft Corp.
#
# This is a sample HOSTS file used by Microsoft TCP/IP for Windows.
#
# This file contains the mappings of IP addresses to host names. Each
# entry should be kept on an individual line. The IP address should
# be placed in the first column followed by the corresponding host name.
# The IP address and the host name should be separated by at least one
# space.
#
# Additionally, comments (such as these) may be inserted on individual
# lines or following the machine name denoted by a '#' symbol.
#
# For example:
#
#      102.54.94.97     rhino.acme.com          # source server
#       38.25.63.10     x.acme.com              # x client host
# localhost name resolution is handled within DNS itself.
#       127.0.0.1       localhost
#       ::1             localhost
"@
                   
                   Set-Content -Path $OriginalFilePath -Value $defaultContent -Force
                   Write-Output "The original hosts file has been successfully Restore-HostsBackupd."
                } catch {
                   Write-Error "Failed to Restore-HostsBackup the original hosts file: $_"
                }
            } # End of Rebuild-Original

        'Count-Entries' {

            $HostsFilePath = "C:\Windows\System32\drivers\etc\hosts"

    try {
        if (-not (Test-Path -Path $HostsFilePath)) {
            Write-Warning "The hosts file at $HostsFilePath does not exist.`n"
            return
        }

      #  Write-Host "Reading the hosts file at $HostsFilePath..."

        # Read the file, filter out comments and blank lines, and count valid entries
        $Global:HostEntryCount = (Get-Content -Path $HostsFilePath | Where-Object {
            $_ -match "^\s*\d{1,3}(\.\d{1,3}){3}\s+\S+" -and $_ -notmatch "^\s*#"
        }).Count
      #  Write-Host
      #  Write-Host "The hosts file contains $HostEntryCount valid entries."

      #   Show-PopupWindowMessage -Title 's0nt3k PS1 Script' -Message "The Windows hosts file has $HostEntryCount valid entries." -ButtonType OK
      Return $HostEntryCount

    } catch {
        Write-Error "An error occurred while reading the hosts file: $_ "
    }
    Write-Host `n
   
    Return
} # End: Count-Entries

        'Remove-Duplicates' {

    # Define paths
    $HostsFile = "C:\Windows\System32\drivers\etc\hosts"
    $LogFile = "./logs/dupentries.txt"

    # Ensure the log directory exists
    $LogDir = Split-Path -Path $LogFile
    if (-not (Test-Path -Path $LogDir)) {
        New-Item -Path $LogDir -ItemType Directory | Out-Null
    }

    # Read the hosts file
    if (-not (Test-Path -Path $HostsFile)) {
        Write-Host "Hosts file not found at $HostsFile." -ForegroundColor Red
        return
    }

    $HostEntries = Get-Content -Path $HostsFile

    # Initialize tracking
    $UniqueEntries = @{}
    $DuplicateEntries = @()

    foreach ($line in $HostEntries) {
        # Skip comments and blank lines
        if ($line -match '^\s*#' -or $line -match '^\s*$') {
            continue
        }

        # Normalize line for comparison (remove extra spaces)
        $normalizedLine = ($line -replace '\s+', ' ').Trim()

        if ($UniqueEntries.ContainsKey($normalizedLine)) {
            $DuplicateEntries += $line
        } else {
            $UniqueEntries[$normalizedLine] = $line
        }
    }

    # Write the cleaned hosts file
    $CleanedEntries = @()
    foreach ($key in $UniqueEntries.Keys) {
        $CleanedEntries += $UniqueEntries[$key]
    }

    # Add back comments and blank lines
    $CleanedEntries = $HostEntries | Where-Object { $_ -match '^\s*#' -or $_ -match '^\s*$' } + $CleanedEntries
    Set-Content -Path $HostsFile -Value $CleanedEntries

    # Log duplicate entries
    if ($DuplicateEntries.Count -gt 0) {
        $Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        $LogHeader = "Duplicate Entries Removed on $Timestamp`n"
        Add-Content -Path $LogFile -Value $LogHeader
        Add-Content -Path $LogFile -Value $DuplicateEntries -Force

        Write-Host "Duplicate entries removed and logged to $LogFile." -ForegroundColor Green
    } else {
        Write-Host "No duplicate entries found." -ForegroundColor Cyan
    }
} # End: Remove-Duplicates

        'Format-HostsFile' {

    $FilePath = "$env:windir\System32\drivers\etc\hosts"
    
    # Define the text to append
    $textToAppend = @"

# =====================================================================================
#
# Your Windows hosts file has been modified by s0nt3k.
#
# =====================================================================================

#
# USER ADDED CUSTOM ENTRIES
# =========================


#
# Microsoft Windows OS & Office Suite Telemetry Blocking List
# ===========================================================
#
"@

    try {
        # Ensure the script is running with administrative privileges
        if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
            throw "This script must be run as Administrator."
        }

        # Check if the file exists
        if (-not (Test-Path -Path $FilePath)) {
            throw "The specified Hosts file was not found: $FilePath"
        }

        # Append the text to the Hosts file
        Add-Content -Path $FilePath -Value $textToAppend
        Write-Host "Text has been successfully appended to the Hosts file." -ForegroundColor Green
    }
    catch {
        Write-Host "An error occurred: $_" -ForegroundColor Red
    }
} # End: Format-HostsFile

    } # End Switch: $Action

} # End Function: Manage-WindowsHostsFile


Function Download-DnsBlocklists {

    Param(
        [ValidateSet('MultiLight', 'MultiNormal', 'MultiPro', 'MultiProPlus', 'MultiUltimate', 'Microsoft-Telemetry')]
        [String]$DnsList,
        [String]$DownloadFolder = "./bin"
    )

    switch ($DnsList) {

        'MultiLight'{

            # Title: HaGeZi's Light DNS Blocklist
            # Description: Hand brush - Cleans the Internet and protects your privacy! Blocks Ads, Tracking, Metrics and some Badware.
            
              Invoke-WebRequest -Uri https://gitlab.com/hagezi/mirror/-/raw/main/dns-blocklists/hosts/light-compressed.txt -OutFile $DownloadFolder/light.xbin
        
        } # End of MultiLight

        'MultiNormal'{

            # Title: HaGeZi's Normal DNS Blocklist
            # Description: Broom - Cleans the Internet and protects your privacy! Blocks Ads, Affiliate, Tracking, Metrics, Telemetry, Phishing, Malware, Scam, Fake, Coins and other "Crap".

              Invoke-WebRequest -Uri https://gitlab.com/hagezi/mirror/-/raw/main/dns-blocklists/hosts/multi-compressed.txt -OutFile $DownloadFolder/normal.xbin
        
        } # End of MultiNormal

        'MultiPro'{

           # Title: HaGeZi's Pro DNS Blocklist
           # Description: Big broom - Cleans the Internet and protects your privacy! Blocks Ads, Affiliate, Tracking, Metrics, Telemetry, Phishing, Malware, Scam, Fake, Coins and other "Crap".
                
             Invoke-WebRequest -Uri https://gitlab.com/hagezi/mirror/-/raw/main/dns-blocklists/hosts/pro-compressed.txt -OutFile $DownloadFolder/pro.xbin
        
        } # End of MultiPro

        'MultiProPlus'{
               
           # Title: HaGeZi's Pro++ DNS Blocklist
           # Description: Sweeper - Aggressive cleans the Internet and protects your privacy! Blocks Ads, Affiliate, Tracking, Metrics, Telemetry, Phishing, Malware, Scam, Fake, Coins and other "Crap".
                
             Invoke-WebRequest -Uri https://raw.githubusercontent.com/hagezi/dns-blocklists/main/hosts/pro.plus-compressed.txt -OutFile $DownloadFolder/propp.xbin
        
        } # End of MultiProPlus
    
        'MultiUltimate'{
               
           # Title: HaGeZi's Ultimate DNS Blocklist
           # Description: Ultimate Sweeper - Strictly cleans the Internet and protects your privacy! Blocks Ads, Affiliate, Tracking, Metrics, Telemetry, Phishing, Malware, Scam, Free Hoster, Fake, Coins and other "Crap".
                
             Invoke-WebRequest -Uri https://gitlab.com/hagezi/mirror/-/raw/main/dns-blocklists/hosts/ultimate-compressed.txt -OutFile $DownloadFolder/ultimate.xbin
        
        } # End of MultiUltimate

        'Microsoft-Telemetry' {
        
          # Title: HaGeZi's Windows/Office Tracker DNS Blocklist
          # Description: Blocks Windows/Office native broadband tracker that track your activity.
    
            Invoke-WebRequest -Uri https://gitlab.com/hagezi/mirror/-/raw/main/dns-blocklists/hosts/native.winoffice.txt -OutFile $DownloadFolder/native.microsoft.xbin

        
        } # End of MsTelemetry
    
    } # End of Switch $DownloadFile



} # End: Download-DnsBlocklists

function Append-WindowsHostsFile {
    param (
        [string]$SourceFilePath = ".\bin\native.microsoft.xbin",
        [string]$HostsFilePath = "C:\Windows\System32\drivers\etc\hosts"
    )

    try {
        if (-not (Test-Path -Path $SourceFilePath)) {
            Write-Warning "The source file at $SourceFilePath does not exist."
            return
        }

        if (-not (Test-Path -Path $HostsFilePath)) {
            Write-Warning "The hosts file at $HostsFilePath does not exist."
            return
        }

        Write-Host "Appending content from $SourceFilePath to $HostsFilePath..."

        # Append the content of the source file to the hosts file
        Get-Content -Path $SourceFilePath | Add-Content -Path $HostsFilePath

        Write-Host "Content successfully appended to the hosts file."
    } catch {
        Write-Error "An error occurred: $_"
    }
} # End: Append-WindowsHostsFile

function Add-CustomUserHostsEntry {
    param (
        [Parameter(Mandatory = $true)]
        [string]$IPAddress,  # The IP address for the new host entry
        
        [Parameter(Mandatory = $true)]
        [string]$HostName,   # The hostname for the new entry

        [string]$HostsFilePath = "$env:SystemRoot\System32\drivers\etc\hosts" # Path to the hosts file
    )

    # Ensure the user has the necessary permissions
    if (-not (Test-Path $HostsFilePath)) {
        Write-Error "Hosts file not found at $HostsFilePath"
        return
    }

    # Write Entry to log file
   # $DateTime = (Get-Date -Format "DyyMMddTHHmmss")
   # $UsrAdds = "$IPAddress     $HostName"
   # Out-File -FilePath .\logs\usradds.host -InputObject $newEntry -Append

    # Construct the new entry
    $newEntry = "$IPAddress   $HostName"
    Out-File -FilePath .\logs\usradds.host -InputObject $newEntry -Append

    # Read the current content of the hosts file
    $hostsContent = Get-Content -Path $HostsFilePath -ErrorAction Stop
    $customEntryLine = "# ========================="

    # Check if "# CUSTOM ENTRIES" exists in the file
    if (-not ($hostsContent -contains $customEntryLine)) {
        # Add "# CUSTOM ENTRIES" to the end of the file if it's missing
        $hostsContent += $customEntryLine
    }

    # Find the index of the "# CUSTOM ENTRIES" line
    $customIndex = $hostsContent.IndexOf($customEntryLine)

    # Check if the provided entry already exists under "# CUSTOM ENTRIES"
    $entriesAfterCustomLine = $hostsContent[($customIndex + 2)..($hostsContent.Count - 1)]

    if ($entriesAfterCustomLine -contains $newEntry) {
        Write-Output "The entry '$newEntry' already exists under '# CUSTOM ENTRIES'."
        return
    }

    # Insert the new entry after "# CUSTOM ENTRIES"
    $hostsContent = $hostsContent[0..$customIndex] + $newEntry + $hostsContent[($customIndex + 1)..($hostsContent.Count - 1)]

    # Write back to the hosts file
    try {
        Set-Content -Path $HostsFilePath -Value $hostsContent -Force
        Write-Output "The entry '$newEntry' has been successfully added to the hosts file under '# CUSTOM ENTRIES'."
    } catch {
        Write-Error "Failed to write to the hosts file. Please ensure you are running as Administrator."
    }
} # End: Add-CustomUserHostsEntry


# Show-TelemetryBlockingMenu

Function MenuOption1 {

   
    Manage-DefenderHostsExclusion -Action Enable
    Start-Sleep -Milliseconds 1000
     

    Manage-WindowsHostsFile -Action Backup-HostsFile
    Start-Sleep -Milliseconds 1000
    
    Manage-WindowsHostsFile -Action Rebuild-Original
     Start-Sleep -Milliseconds 2000

    Manage-WindowsHostsFile -Action Rebuild-Original
     Start-Sleep -Milliseconds 2000
    
    Manage-WindowsHostsFile -Action Format-HostsFile
    Start-Sleep -Milliseconds 1000
        
    Download-DnsBlocklists -DnsList Microsoft-Telemetry
    Start-Sleep -Milliseconds 1000

    Append-WindowsHostsFile -SourceFilePath .\bin\native.microsoft.xbin
    Start-Sleep -Milliseconds 1000
    
    Show-PopupWindowMessage -Message "The (HaGeZi's Windows/Office Tracker DNS Blocklist) file has been installed" -Title "s0nt3k's PS1 Script" -ButtonType OK

    Show-TelemetryBlockingMenu
}

Function MenuOption2 {

    Manage-WindowsHostsFile -Action Backup-HostsFile
    Start-Sleep -Milliseconds 1000

    Manage-WindowsHostsFile -Action Rebuild-Original
    Start-Sleep -Milliseconds 1000

    Manage-DefenderHostsExclusion -Action Disable
    Start-Sleep -Milliseconds 1000

    Show-PopupWindowMessage -Message "The (HaGeZi's Windows/Office Tracker DNS Blocklist) file has been uninstalled." -Title "s0nt3k's PS1 Script" -ButtonType OK

    Show-TelemetryBlockingMenu

}

Function MenuOption3 {

            Manage-WindowsHostsFile -Action Backup-HostsFile
            Start-Sleep -Milliseconds 1000

            Manage-WindowsHostsFile -Action Rebuild-Original
            Start-Sleep -Milliseconds 1000

            Manage-WindowsHostsFile -Action Rebuild-Original
            Start-Sleep -Milliseconds 1000    

            Download-DnsBlocklists -DnsList Microsoft-Telemetry
            Start-Sleep -Milliseconds 1000

            Manage-WindowsHostsFile -Action Format-HostsFile
            Start-Sleep -Milliseconds 1000

            Append-WindowsHostsFile -SourceFilePath .\bin\native.microsoft.xbin
            Start-Sleep -Milliseconds 1000

            Show-PopupWindowMessage -Message "The latest version of (HaGeZi's Windows/Office Tracker DNS Blocklist) has been uninstalled." -Title "s0nt3k's PS1 Script" -ButtonType OK

}


Set-GlobalVarables

Ensure-ScriptSetup
