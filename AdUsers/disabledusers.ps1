<#
.SYNOPSIS
    Locates disabled user accounts in the Adatum.com domain.

.DESCRIPTION
    Queries Active Directory on the LON-DC1 domain controller for all user
    accounts whose account is disabled, and returns key identifying
    properties for each one.

.PARAMETER SearchBase
    Optional. Limits the search to a specific OU or container
    (e.g. "OU=Sales,DC=Adatum,DC=com"). If omitted, the entire domain is searched.

.PARAMETER OutputPath
    Optional. If specified, exports the results to a CSV file at this path.

.EXAMPLE
    Get-DisabledADUser

    Returns all disabled user accounts in Adatum.com.

.EXAMPLE
    Get-DisabledADUser -SearchBase "OU=Sales,DC=Adatum,DC=com" -OutputPath "C:\Reports\DisabledUsers.csv"

    Returns disabled user accounts only in the Sales OU and exports the results to a CSV file.
#>
function Get-DisabledADUser {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [string]$Server = 'LON-DC1.Adatum.com',

        [Parameter(Mandatory = $false)]
        [string]$SearchBase,

        [Parameter(Mandatory = $false)]
        [string]$OutputPath
    )

    # Ensure the ActiveDirectory module is available before querying the domain.
    if (-not (Get-Module -ListAvailable -Name ActiveDirectory)) {
        Write-Error "The ActiveDirectory module is not installed. Install RSAT-AD-PowerShell and try again."
        return
    }

    Import-Module ActiveDirectory -ErrorAction Stop

    $params = @{
        Filter     = 'Enabled -eq $false'
        Properties = 'DistinguishedName', 'LastLogonDate', 'Description'
        Server     = $Server
    }

    if ($SearchBase) {
        $params['SearchBase'] = $SearchBase
    }

    try {
        $disabledUsers = Get-ADUser @params |
        Select-Object Name, SamAccountName, DistinguishedName, LastLogonDate, Description |
        Sort-Object Name
    }
    catch {
        Write-Error "Failed to query Active Directory on '$Server': $_"
        return
    }

    if (-not $disabledUsers) {
        Write-Output "No disabled user accounts were found."
        return
    }

    if ($OutputPath) {
        $disabledUsers | Export-Csv -Path $OutputPath -NoTypeInformation
        Write-Output "Exported $($disabledUsers.Count) disabled user account(s) to '$OutputPath'."
    }

    return $disabledUsers
}
