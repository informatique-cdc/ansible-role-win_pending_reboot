# win_pending_reboot

win_pending_reboot est un module Ansible permettant de vérifier les redémarrages en attente pour les hôtes Windows. Il est basé en partie sur le code de la ressource DSC [xPendingReboot].

## Systèmes d'exploitation pris en charge

Les versions suivantes du système d'exploitation sont prises en charge par ce rôle :

* Windows Server 2012
* Windows Server 2012 R2
* Windows Server 2016

## Prérequis

* WMF 5.0 ou supérieure

## Options

| Paramètre     | Requis | Valeur par défaut | Valeurs possibles            | Description                                              |
|----------------|----------|--------:|--------------------|---------------------------------------------------------|
| skip_component_based_servicing | non | `no` | `yes`, `no` |  Specifies whether to skip reboots triggered by the [Component-Based Servicing component] |
| skip_windows_update | non | `no` | `yes`, `no` | Specifies whether to skip reboots triggered by Windows Update |
| skip_pending_file_rename | non | `no` | `yes`, `no` | Specifies whether to skip pending file rename reboots |
| skip_pending_computer_rename | non | `no` | `yes`, `no` | Specifies whether to skip reboots triggered by a pending computer rename |
| skip_ccm_client_sdk | non | `no` | `yes`, `no` | Specifies whether to skip reboots triggered by the ConfigMgr client |

## Exemples

```yaml
---
  roles:
    - win_pending_reboot

  tasks:

    - name: get the pending reboot status
      win_pending_reboot:
        skip_ccm_client_sdk: yes
      register: test_pending_reboot_result

    - name: reboot if need
      win_reboot:
      when: test_pending_reboot_result.reboot_required
```

## Valeurs de retour

Voici les champs propres à ce module :

| Key              | Description |   Returned| Type    | Example |
|------------------|-------------|----------:|---------|---------|
| component_based_servicing         | True when the Component-Based Servicing component requested a reboot        |  success | boolean | `False`  |
| windows_update         | True when the Windows Update requested a reboot        |  success | boolean | `False`  |
| pending_file_rename         | True when a pending file rename triggered a reboot        |  success | boolean | `False`  |
| pending_computer_rename        | True when a pending computer rename triggered a reboot        |  success | boolean | `False`  |
| ccm_client_sdk        | True when the ConfigMgr client triggered a reboot        |  success and `skip_ccm_client_sdk` equal `no` | boolean | `False`  |
| reboot_required        | True when the target server requires a reboot        |  success | boolean | `True`  |

## Informations sur l'auteur

Les personnes suivantes ont écrit ou contribuées à l'écriture de ce module :

* [Stéphane Bilqué (stephane.bilque@caissedesdepots.fr)](stephane.bilque@caissedesdepots.fr)

## Versions

Voir [CHANGELOG.md](CHANGELOG.md)

[xPendingReboot]: https://github.com/PowerShell/xPendingReboot.git
[ansible-windows-pending-reboot]: https://github.com/valerius257/ansible-windows-pending-reboot

[Component-Based Servicing component]: https://blogs.iis.net/wonyoo/servicing-via-cbs-component-based-servicing
