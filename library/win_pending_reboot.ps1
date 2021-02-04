#!powershell

#Requires -Module Ansible.ModuleUtils.Legacy

#Requires -Version 2.0

$ErrorActionPreference = "Stop"

$result = @{}

$params = Parse-Args -arguments $args -supports_check_mode $true
$check_mode = Get-AnsibleParam -obj $params -name "_ansible_check_mode" -type "bool" -default $false
$diff_mode = Get-AnsibleParam -obj $params -name "_ansible_diff" -type "bool" -default $false

$SkipComponentBasedServicing = Get-AnsibleParam -obj $params -name "skip_component_based_servicing" -type "bool" -failifempty $false -default $false
$skipWindowsUpdate = Get-AnsibleParam -obj $params -name "skip_windows_update" -type "bool" -failifempty $false -default $false
$skipPendingFileRename = Get-AnsibleParam -obj $params -name "skip_pending_file_rename" -type "bool" -failifempty $false -default $false
$skipPendingComputerRename = Get-AnsibleParam -obj $params -name "skip_pending_computer_rename" -type "bool" -failifempty $false -default $false
$SkipCcmClientSDK = Get-AnsibleParam -obj $params -name "skip_pending_computer_rename" -type "bool" -failifempty $false -default $true

$set_args = @{
    ErrorAction                 = "Stop"
    check_mode                  = $check_mode
    diff_mode                   = $diff_mode
    SkipComponentBasedServicing = $SkipComponentBasedServicing
    skipWindowsUpdate           = $skipWindowsUpdate
    skipPendingFileRename       = $skipPendingFileRename
    skipPendingComputerRename   = $skipPendingComputerRename
    SkipCcmClientSDK            = $SkipCcmClientSDK
}

# Localized messages
data LocalizedData {
    # culture="en-US"
    ConvertFrom-StringData @'
    UnableToQueryCCM             = Unable to query CCM_ClientUtilities: {0}
'@
}

Function Get-TargetResource {
    <#
    .SYNOPSIS
    Get informations where a Windows Server might indicate that a reboot is pending.
    .PARAMETER SkipCcmClientSDK
    Specifies whether to skip reboots triggered by the ConfigMgr client
    #>
    [CmdletBinding()]
    [OutputType([Hashtable])]
    param
    (
        [Parameter()]
        [bool]
        $SkipCcmClientSDK = $true
    )

    $ComponentBasedServicingKeys = (Get-ChildItem 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\').Name
    if ($ComponentBasedServicingKeys) {
        $ComponentBasedServicing = $ComponentBasedServicingKeys.Split("\") -contains "RebootPending"
    }
    else {
        $ComponentBasedServicing = $false
    }

    $WindowsUpdateKeys = (Get-ChildItem 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\').Name
    if ($WindowsUpdateKeys) {
        $WindowsUpdate = $WindowsUpdateKeys.Split("\") -contains "RebootRequired"
    }
    else {
        $WindowsUpdate = $false
    }

    $PendingFileRename = (Get-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\').PendingFileRenameOperations.Length -gt 0
    $ActiveComputerName = (Get-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Control\ComputerName\ActiveComputerName').ComputerName
    $PendingComputerName = (Get-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Control\ComputerName\ComputerName').ComputerName
    $PendingComputerRename = $ActiveComputerName -ne $PendingComputerName

    $result = @{
        component_based_servicing = $ComponentBasedServicing
        windows_update            = $WindowsUpdate
        pending_file_rename       = $PendingFileRename
        pending_computer_rename   = $PendingComputerRename
    }

    if (-not $SkipCcmClientSDK) {
        $CCMSplat = @{
            NameSpace   = 'ROOT\ccm\ClientSDK'
            Class       = 'CCM_ClientUtilities'
            Name        = 'DetermineIfRebootPending'
            ErrorAction = 'Stop'
        }

        Try {
            $CCMClientSDK = Invoke-WmiMethod @CCMSplat
            $SCCMSDK = ($CCMClientSDK.ReturnValue -eq 0) -and ($CCMClientSDK.IsHardRebootPending -or $CCMClientSDK.RebootPending)
            $result += { ccm_client_sdk = $SCCMSDK }
        }
        Catch {
            Write-Warning ($LocalizedData.UnableToQueryCCM -f $_);
        }
    }

    return $result
}

function Test-TargetResource {
    <#
    .SYNOPSIS
    Checks for pending Windows Reboots.
    .DESCRIPTION
    Examines three specific registry locations where a Windows Server might indicate that a reboot is pending.
    .PARAMETER SkipComponentBasedServicing
    Specifies whether to skip reboots triggered by the Component-Based Servicing component
    .PARAMETER SkipWindowsUpdate
    Specifies whether to skip reboots triggered by Windows Update
    .PARAMETER SkipPendingFileRename
    Specifies whether to skip pending file rename reboots
    .PARAMETER SkipPendingComputerRename
    Specifies whether to skip reboots triggered by a pending computer rename
    .PARAMETER SkipCcmClientSDK
    Specifies whether to skip reboots triggered by the ConfigMgr client
    #>
    param(
        [bool]
        $SkipComponentBasedServicing = $false,
        [bool]
        $SkipWindowsUpdate = $false,
        [bool]
        $SkipPendingFileRename = $false,
        [bool]
        $SkipPendingComputerRename = $false,
        [bool]
        $SkipCcmClientSDK = $true
    )

    $status = Get-TargetResource -SkipCcmClientSDK $SkipCcmClientSDK
    $reboot_required = $false

    if (-not $SkipComponentBasedServicing -and $status.component_based_servicing) {
        Write-Verbose 'Pending component based servicing reboot found.'
        $reboot_required = $true
    }

    if (-not $SkipWindowsUpdate -and $status.windows_update) {
        Write-Verbose 'Pending Windows Update reboot found.'
        $reboot_required = $true
    }

    if (-not $SkipPendingFileRename -and $status.pending_file_rename) {
        Write-Verbose 'Pending file rename found.'
        $reboot_required = $true
    }

    if (-not $SkipPendingComputerRename -and $status.pending_computer_rename) {
        Write-Verbose 'Pending computer rename found.'
        $reboot_required = $true
    }

    $status += @{ reboot_required = $reboot_required }

    return $status
}

$result = Test-TargetResource @set_args

Exit-Json -obj $result