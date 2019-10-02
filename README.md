# Simple Kubernetes Server Bootstrap

## Description
This repository contains a script to bootstrap a newly installed Ubuntu installation to the latest Kubernetes. NTP is disabled as it is expected to be managed with a kubernetes deployment.

## Server Build Instructions
These instructions are intended for building the server and get Kubernetes going:

1. Install Ubuntu Server Edition (currently tested with 19.04)
2. Update the server credentials and IP in the project.conf file.
3. Update the ansible/files/id_rsa.pub with a Public RSA key to be added to the server user.
4. Execute "make install-python". This will remotly install python on the server. (The password will need to be entered when run.)
5. Execute "make provision". This will execute the setup script with the ansible container.
6. A file will be created locally: "/tmp/kubeconfig" copy or map this file to KUBECONFIG. This is the Kubernetes config file for the new server.
7. Execute a kubectl command to test the cluster (single node) is responding.
