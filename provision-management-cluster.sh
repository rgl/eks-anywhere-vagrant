#!/bin/bash
source /vagrant/lib.sh

mkdir clusters
pushd clusters

CLUSTER_NAME=management

# create the cluster.
# TODO set the k8s version.
eksctl anywhere generate clusterconfig \
    $CLUSTER_NAME \
    --provider docker \
    >$CLUSTER_NAME.yaml
eksctl anywhere create cluster \
    -f $CLUSTER_NAME.yaml

# export kubeconfig.
install -d ~/.kube
ln -s \
    "${PWD}/${CLUSTER_NAME}/${CLUSTER_NAME}-eks-a-cluster.kubeconfig" \
    ~/.kube/config
ip_address="$(ip addr show eth1 | perl -ne '/inet (.+)\/\d+/ && print $1')"
sed -E "s,127.0.0.1,$ip_address,g" \
    ~/.kube/config \
    | sudo bash -c 'cat >/vagrant/shared/kubeconfig'

# show information about the environment.
docker ps
kubectl get nodes -o wide
kubectl get ns
