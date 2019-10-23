# Tests

Ce dossier contient des scripts pour tester les scripts directement sur les serveurs Windows sans passer par une ressource DSC ou par Ansible.

## test-role.ps1

Ce script PowerShell permet de tester le module win_pending_reboot sans passer par Ansible.

Pour l'utiliser, il faut copier le fichier [**Ansible.ModuleUtils.Legacy.psm1**](https://github.com/ansible/ansible/blob/stable-2.7/lib/ansible/module_utils/powershell/Ansible.ModuleUtils.Legacy.psm1) de votre version de Ansible dans le même répertoire que le script.

Pour plus d'information sur le test d'un module Windows, voir la section *Windows debugging* dans [Windows Ansible Module Development Walkthrough](https://docs.ansible.com/ansible/latest/dev_guide/developing_modules_general_windows.html#developing-modules-general-windows)

## test-role.yml

Ce playbook Ansible permet de tester le module win_pending_reboot.
