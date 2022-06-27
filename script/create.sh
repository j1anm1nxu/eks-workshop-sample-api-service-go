#!/usr/bin/env bash
#
echo "CodeDeploy create.sh"
#
# /usr/local/bin/kubectl apply -f /var/tmp/eks/hello-k8s.yml
/usr/local/bin/kubectl apply -f /var/tmp/eks/replicaset.yml

