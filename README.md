# win_pending_reboot - Checks for pending Windows Reboots

## Synopsis

This Ansible module examines three specific registry locations where a Windows Server might indicate that a reboot is pending.

## Parameters

| Parameter                      | Required | Defaults | Choices     | Comments                                                                                 |
| ------------------------------ | -------- | -------: | ----------- | ---------------------------------------------------------------------------------------- |
| skip_component_based_servicing | non      |     `no` | `yes`, `no` | Specifies whether to skip reboots triggered by the [Component-Based Servicing component] |
| skip_windows_update            | non      |     `no` | `yes`, `no` | Specifies whether to skip reboots triggered by Windows Update                            |
| skip_pending_file_rename       | non      |     `no` | `yes`, `no` | Specifies whether to skip pending file rename reboots                                    |
| skip_pending_computer_rename   | non      |     `no` | `yes`, `no` | Specifies whether to skip reboots triggered by a pending computer rename                 |
| skip_ccm_client_sdk            | non      |     `no` | `yes`, `no` | Specifies whether to skip reboots triggered by the ConfigMgr client                      |

## Examples

```yaml
---
- hosts: localhost

  roles: win_pending_reboot

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

The following are the fields unique to this module:

| Key                       | Description                                                          |                                     Returned | Type    | Example |
| ------------------------- | -------------------------------------------------------------------- | -------------------------------------------: | ------- | ------- |
| component_based_servicing | True when the Component-Based Servicing component requested a reboot |                                      success | boolean | `False` |
| windows_update            | True when the Windows Update requested a reboot                      |                                      success | boolean | `False` |
| pending_file_rename       | True when a pending file rename triggered a reboot                   |                                      success | boolean | `False` |
| pending_computer_rename   | True when a pending computer rename triggered a reboot               |                                      success | boolean | `False` |
| ccm_client_sdk            | True when the ConfigMgr client triggered a reboot                    | success and `skip_ccm_client_sdk` equal `no` | boolean | `False` |
| reboot_required           | True when the target server requires a reboot                        |                                      success | boolean | `True`  |

## License

MIT

See [LICENSE](LICENSE) to see the full text.

## Author Information

* [Stéphane Bilqué](https://github.com/sbilque)

## Open Source Components

This module uses some partial or full parts of open source functions in PowerShell from the following source :

| Name                                | Source |
| ----------------------------------- | ------ |
| xPendingReboot                      |        [GitHub](https://github.com/PowerShell/xPendingReboot.git)                                |
| ansible-windows-pending-reboot      |        [GitHub](https://github.com/valerius257/ansible-windows-pending-reboot)                   |

[Component-Based Servicing component]: https://blogs.iis.net/wonyoo/servicing-via-cbs-component-based-servicing
