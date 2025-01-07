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
    Function IdN:... 771343-100-1100
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
