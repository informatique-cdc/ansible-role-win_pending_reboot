# win_pending_reboot - Checks for pending Windows Reboots

## Synopsis

* This Ansible module examines three specific registry locations where a Windows Server might indicate that a reboot is pending.

## Parameters

| Parameter     | Choices/<font color="blue">Defaults</font> | Comments |
| ------------- | ---------|--------- |
|__skip_component_based_servicing__<br><font color="purple">boolean</font> | __Choices__: <ul><li><font color="blue">__no &#x2190;__</font></li><li>yes</li></ul> | Specifies whether to skip reboots triggered by the Component-Based Servicing component |
|__skip_windows_update__<br><font color="purple">boolean</font> | __Choices__: <ul><li><font color="blue">__no &#x2190;__</font></li><li>yes</li></ul> | Specifies whether to skip reboots triggered by Windows Update |
|__skip_pending_file_rename__<br><font color="purple">boolean</font> | __Choices__: <ul><li><font color="blue">__no &#x2190;__</font></li><li>yes</li></ul> | Specifies whether to skip pending file rename reboots |
|__skip_pending_computer_rename__<br><font color="purple">boolean</font> | __Choices__: <ul><li><font color="blue">__no &#x2190;__</font></li><li>yes</li></ul> | Specifies whether to skip reboots triggered by a pending computer rename |
|__skip_ccm_client_sdk__<br><font color="purple">boolean</font> | __Choices__: <ul><li>no</li><li><font color="blue">__yes &#x2190;__</font></li></ul> | Specifies whether to skip reboots triggered by the ConfigMgr client |

## Examples

```yaml
---
- hosts: localhost

  roles:
    - win_pending_reboot

  tasks:

    - name: get the pending reboot status
      win_pending_reboot:
        skip_ccm_client_sdk: no
      register: test_pending_reboot_result

    - name: reboot if need
      win_reboot:
      when: test_pending_reboot_result.reboot_required

```

## Return Values

Common return values are documented [here](https://docs.ansible.com/ansible/latest/reference_appendices/common_return_values.html#common-return-values), the following are the fields unique to this module:

| Key    | Returned   | Description |
| ------ |------------| ------------|
|__component_based_servicing__<br><font color="purple">boolean</font> | success | `True` when the Component-Based Servicing component requested a reboot.<br><br>__Sample:__<br><font color=blue>False</font> |
|__windows_update__<br><font color="purple">boolean</font> | success | `True` when the Windows Update requested a reboot.<br><br>__Sample:__<br><font color=blue>False</font> |
|__pending_file_rename__<br><font color="purple">boolean</font> | success | `True` when a pending file rename triggered a reboot.<br><br>__Sample:__<br><font color=blue>False</font> |
|__pending_computer_rename__<br><font color="purple">boolean</font> | success | `True` when a pending computer rename triggered a reboot.<br><br>__Sample:__<br><font color=blue>False</font> |
|__ccm_client_sdk__<br><font color="purple">boolean</font> | success and _skip_ccm_client_sdk_ = `no` | `True` when the ConfigMgr client triggered a reboot.<br><br>__Sample:__<br><font color=blue>False</font> |
|__reboot_required__<br><font color="purple">boolean</font> | success | `True` when the target server requires a reboot.<br><br>__Sample:__<br><font color=blue>True</font> |

## Notes

* This module uses some partial or full parts of open source functions in PowerShell from the following source.
* xPendingReboot <https://github.com/PowerShell/xPendingReboot.git>
* ansible-windows-pending-reboot <https://github.com/valerius257/ansible-windows-pending-reboot>

## Authors

* Stéphane Bilqué (@sbilque)

## License

This project is licensed under the MIT License.

See [LICENSE](LICENSE) to see the full text.
