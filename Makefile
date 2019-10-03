#!/usr/bin/make
# Project Makefile
include project.conf
export $(shell sed 's/=.*//' project.conf)

REVERSE_DATE=$(shell date +'%Y%m%d')

.PHONY: all build validate prompt

all: deploy-python provision deploy-flux

provision: provision-single

provision-single:
	@echo -e Provisioning Server...
	@CMDLINE="-e PYTHONWARNINGS=ignore::UserWarning geoffh1977/ansible ansible-playbook -i ${serverIp}, -e serverIp=${serverIp} -e singleNode=true -e ansible_user=${serverUsername} -e ansible_ssh_pass=${serverPassword} -e ansible_sudo_pass=${serverPassword} ansible/setup_server.yml" scripts/container.sh

provision-cluster:
	@echo -e Provisioning Server...
	@CMDLINE="geoffh1977/ansible ansible-playbook -i ${serverIp}, -e serverIp=${serverIp} -e singleNode=false -e ansible_user=${serverUsername} -e ansible_ssh_pass=${serverPassword} -e ansible_sudo_pass=${serverPassword} ansible/setup_server.yml" scripts/container.sh

deploy-python:
	@echo "Remotely Install Python..."
	@ssh -o "UserKnownHostsFile=/dev/null" -o "StrictHostKeyChecking=no" -t ${serverUsername}@${serverIp} 'sudo apt-get install -y python'

deploy-flux:
	@echo Setup Flux...
	@scripts/write-flux-deploy.sh
	@kubectl -n flux create secret generic flux-git-deploy --from-file=identity=${gitKeyPath} --dry-run -o yaml > flux/patch-key.yaml
	@KUBECONFIG="/tmp/kubeconfig" kubectl -n flux apply -k flux
	@rm -f flux/patch-deploy.yaml flux/patch-key.yaml

