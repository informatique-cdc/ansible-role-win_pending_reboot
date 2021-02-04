#!/usr/bin/python
# -*- coding: utf-8 -*-

# This is a windows documentation stub.  Actual code lives in the .ps1
# file of the same name.

# Copyright: (c) 2019, Informatique CDC.
# The MIT License (MIT) (see LICENSE)

from __future__ import absolute_import, division, print_function
__metaclass__ = type


ANSIBLE_METADATA = {'metadata_version': '1.0',
                    'status': ['preview'],
                    'supported_by': 'community'}


DOCUMENTATION = r'''
---
module: win_pending_reboot
short_description: Checks for pending Windows Reboots
description:
    - This Ansible module examines three specific registry locations where a Windows Server might indicate that a reboot is pending.
options:
    skip_component_based_servicing:
        description:
            - Specifies whether to skip reboots triggered by the Component-Based Servicing component
        required: false
        type: bool
        default: 'no'
    skip_windows_update:
        description:
            - Specifies whether to skip reboots triggered by Windows Update
        required: false
        type: bool
        default: 'no'
    skip_pending_file_rename:
        description:
          -  Specifies whether to skip pending file rename reboots
        required: false
        type: bool
        default: 'no'
    skip_pending_computer_rename:
        description:
          -  Specifies whether to skip reboots triggered by a pending computer rename
        required: false
        type: bool
        default: 'no'
    skip_ccm_client_sdk:
        description:
          -  Specifies whether to skip reboots triggered by the ConfigMgr client
        required: false
        type: bool
        default: 'yes'
author:
    - Stéphane Bilqué (@sbilque)
notes:
    - This module uses some partial or full parts of open source functions in PowerShell from the following source.
    - xPendingReboot U(https://github.com/PowerShell/xPendingReboot.git)
    - ansible-windows-pending-reboot U(https://github.com/valerius257/ansible-windows-pending-reboot)
'''

EXAMPLES = r'''
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
'''

RETURN = r'''
component_based_servicing:
    description: C(True) when the Component-Based Servicing component requested a reboot.
    returned: success
    type: bool
    sample: False
windows_update:
    description: C(True) when the Windows Update requested a reboot.
    returned: success
    type: bool
    sample: False
pending_file_rename:
    description: C(True) when a pending file rename triggered a reboot.
    returned: success
    type: bool
    sample: False
pending_computer_rename:
    description: C(True) when a pending computer rename triggered a reboot.
    returned: success
    type: bool
    sample: False
ccm_client_sdk:
    description: C(True) when the ConfigMgr client triggered a reboot.
    returned: success and I(skip_ccm_client_sdk) = C(no)
    type: bool
    sample: False
reboot_required:
    description: C(True) when the target server requires a reboot.
    returned: success
    type: bool
    sample: True
'''
