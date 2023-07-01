#!/bin/bash
source /vagrant/lib.sh

EKSCTL_ANYWHERE_VERSION="${1:-0.16.1}"; shift || true

# install the binaries.
if [ ! -f /usr/local/bin/eksctl-anywhere ]; then
    # see https://anywhere.eks.amazonaws.com/docs/getting-started/install/
    eksctl_anywhere_url="https://github.com/aws/eks-anywhere/releases/download/v${EKSCTL_ANYWHERE_VERSION}/eksctl-anywhere-v${EKSCTL_ANYWHERE_VERSION}-linux-amd64.tar.gz"
    t="$(mktemp -q -d --suffix=.eksctl-anywhere)"
    wget -qO- "$eksctl_anywhere_url" | tar xzf - -C "$t"
    install -m 755 "$t/eksctl-anywhere" /usr/local/bin
    rm -rf "$t"
fi
