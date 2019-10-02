#!/usr/bin/make
# Project Makefile
include project.conf
export $(shell sed 's/=.*//' project.conf)

REVERSE_DATE=$(shell date +'%Y%m%d')

.PHONY: all build validate prompt

all: provision

provision: provision-single

provision-single:
	@echo -e Provisioning Server...
	@CMDLINE="-e PYTHONWARNINGS=ignore::UserWarning geoffh1977/ansible ansible-playbook -i ${serverIp}, -e serverIp=${serverIp} -e singleNode=true -e ansible_user=${serverUsername} -e ansible_ssh_pass=${serverPassword} -e ansible_sudo_pass=${serverPassword} ansible/setup_server.yml" scripts/container.sh

provision-cluster:
	@echo -e Provisioning Server...
	@CMDLINE="geoffh1977/ansible ansible-playbook -i ${serverIp}, -e serverIp=${serverIp} -e singleNode=false -e ansible_user=${serverUsername} -e ansible_ssh_pass=${serverPassword} -e ansible_sudo_pass=${serverPassword} ansible/setup_server.yml" scripts/container.sh

install-python:
	@ssh -o "UserKnownHostsFile=/dev/null" -o "StrictHostKeyChecking=no" -t ${serverUsername}@${serverIp} 'sudo apt-get install -y python'
