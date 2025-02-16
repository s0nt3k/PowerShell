function Backup-DriversToUSB {
    param (
        [string]$USBDriveLetter
    )
    
    # Validate if the drive letter exists
    if (-Not (Test-Path "$USBDriveLetter`:\")) {
        Write-Host "Error: The specified drive letter '$USBDriveLetter' is not available." -ForegroundColor Red
        return
    }
    
    # Set the backup directory on the USB drive
    $BackupPath = "$USBDriveLetter`:\DriverBackup"
    
    # Create the backup directory if it does not exist
    if (-Not (Test-Path $BackupPath)) {
        New-Item -ItemType Directory -Path $BackupPath | Out-Null
    }
    
    # Export drivers to the specified directory
    try {
        Write-Host "Exporting drivers to $BackupPath ..." -ForegroundColor Cyan
        Export-WindowsDriver -Online -Destination $BackupPath
        Write-Host "Driver backup completed successfully!" -ForegroundColor Green
    } catch {
        Write-Host "Error occurred while exporting drivers: $_" -ForegroundColor Red
    }
}
