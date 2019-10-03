#!/bin/bash
source ./project.conf

cat << EOF > flux/patch-deploy.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: flux
spec:
  template:
    spec:
      containers:
        - name: flux
          args:
            - --manifest-generation=true
            - --memcached-hostname=memcached.flux
            - --memcached-service=
            - --ssh-keygen-dir=/var/fluxd/keygen
            - --git-branch=master
            - --git-path=${gitPath}
            - --git-user=${gitUser}
            - --git-email=${gitEmail}
            - --git-url=${gitUrl}

EOF
