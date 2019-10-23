

### start setup code
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

Import-Module -Name $toolsDir\Ansible.ModuleUtils.Legacy.psm1 

### end setup code

$global:complex_args = @{
    "_ansible_check_mode" = $false
    "_ansible_diff" = $false
}
    
. $toolsDir\..\library\win_pending_reboot.ps1

Remove-Module -Name Ansible.ModuleUtils.Legacy
