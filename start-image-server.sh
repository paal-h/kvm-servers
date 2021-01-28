#!/bin/bash

pushd .
cd ansible
ansible-playbook image-server.yml
popd
