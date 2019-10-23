#!/usr/bin/python
# -*- coding: utf-8 -*-

# This is a windows documentation stub.  Actual code lives in the .ps1
# file of the same name.

# Copyright 2019 Informatique CDC. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License

from __future__ import absolute_import, division, print_function
__metaclass__ = type


ANSIBLE_METADATA = {'metadata_version': '1.0',
                    'status': ['preview'],
                    'supported_by': 'communoty'}


DOCUMENTATION = '''
---
module: win_pending_reboot
short_description: Role for checking for pending Windows Reboots.
description:
    - "This role examines three specific registry locations where a Windows Server might indicate that a reboot is pending."
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
author: "Stéphane Bilqué"
'''

EXAMPLES = '''
- name: get the pending reboot status
  win_pending_reboot:
    skip_ccm_client_sdk: no
  register: test_pending_reboot_result

- name: reboot if need
  win_reboot:
  when: test_pending_reboot_result.reboot_required
'''

RETURN = '''
component_based_servicing:
  description: True when the Component-Based Servicing component requested a reboot
  returned: success
  type: boolean
  sample: False
windows_update:
  description: True when the Windows Update requested a reboot
  returned: success
  type: boolean
  sample: False
pending_file_rename:
  description: True when a pending file rename triggered a reboot
  returned: success
  type: boolean
  sample: False
pending_computer_rename:
  description: True when a pending computer rename triggered a reboot
  returned: success
  type: boolean
  sample: False
ccm_client_sdk:
  description: True when the ConfigMgr client triggered a reboot
  returned: success and C(skip_ccm_client_sdk) = no
  type: boolean
  sample: False
reboot_required:
  description: True when the target server requires a reboot
  returned: success
  type: boolean
  sample: True  
'''