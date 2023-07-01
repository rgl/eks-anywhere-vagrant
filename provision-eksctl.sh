#!/bin/bash
source /vagrant/lib.sh

EKSCTL_VERSION="${1:-0.147.0}"; shift || true

# install the binaries.
if [ ! -f /usr/local/bin/eksctl ]; then
    eksctl_url="https://github.com/weaveworks/eksctl/releases/download/v${EKSCTL_VERSION}/eksctl_Linux_amd64.tar.gz"
    t="$(mktemp -q -d --suffix=.eksctl)"
    wget -qO- "$eksctl_url" | tar xzf - -C "$t"
    install -m 755 "$t/eksctl" /usr/local/bin
    rm -rf "$t"
fi

# install the bash completions.
eksctl completion bash >/usr/share/bash-completion/completions/eksctl
