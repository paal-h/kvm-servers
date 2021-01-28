#!/bin/bash

pushd .
cd ansible
ansible-playbook install.yml --ask-become-pass
popd
