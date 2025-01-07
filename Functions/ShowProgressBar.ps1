Function Show-ProgressBar {

    Param(
        [String]$Activity = "Processing",
        [ValidateSet('Processing', 'Running', 'Updating', 'Backing Up', 'Restoring', 'Rebuilding', 'Configuring', 'Saving', 'Loading', 'Downloading')]
        [String]$Status = "Running",
        [Int]$IdNum = '1',
        [ValidateSet(01, 05, 10, 20, 25, 50)]
        [Int]$Percent = '10',
        [Int]$MilliSec = "500"

    )

    <#
    .SYNOPSIS
        Displays a progress bar in the active window.

    .DESCRIPTION
         This function uses the Write-Progress cmdlet to display a progress bar for a specified duration. 
         It's useful for visually representing task completion progress.

    .PARAMETER Activity
         Specifies the activity name displayed on the progress bar. Default is "Processing".

    .PARAMETER Status
        Specifies the status text displayed with the progress bar. Default is "Running...".

    .PARAMETER IdNum
        Specifies the ID number of the progress bar. Default is 1

    .PARAMETER Percent
        Specifies the percentage the progress bar progresses. Default is 10%

    .PARAMETER MilliSec
        Specifies the duration (in milliseconds) for which the progress bar is displayed. Default is 500 milliseconds (1/2 * 1 Second).

    .EXAMPLE
        Show-ProgressBar

        This command displays the progress bar in the default 10% increments for the default 500 milliseconds each with the default
        activity string and status string. 

    .EXAMPLE
        Show-ProgressBar -Activity "Running some code" -Status Processing -Percent 25 -MilliSec 1500

        This command displays the progress bar in 25% increments for 1500 milliseconds (1.5 Seconds) with the activity
        message "Running some code" with the status text "Processing"
        

    .NOTES
        Author:...... s0nt3k
        E-Mail:...... s0nt3k@protonmail.com
        Date:........ January 6, 2025
        PS1FIdN:..... 771343-100-1000
        Version:..... 1.0.5021
    #>
    
    For ($X = 1; $X -lt 100; $X+=$Percent) {
        Write-Progress -Activity $Activity -Status "$Status..." -Id $IdNum -PercentComplete $X
        Start-Sleep -Milliseconds $MilliSec
    }
} # End: Progress-Bar
