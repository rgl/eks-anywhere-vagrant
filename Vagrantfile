CONFIG_DOMAIN = 'eksa.test'
CONFIG_PANDORA_FQDN = "pandora.#{CONFIG_DOMAIN}"
CONFIG_PANDORA_IP_ADDRESS = '10.10.0.2'
CONFIG_DOCKER_VERSION = '24.0.2' # NB execute apt-cache madison docker-ce to known the available versions.
CONFIG_EKSCTL_ANYWHERE_VERSION = '0.16.1' # see https://github.com/aws/eks-anywhere/releases
CONFIG_EKSCTL_VERSION = '0.147.0' # see https://github.com/weaveworks/eksctl/releases
CONFIG_KUBECTL_VERSION = '1.27.3' # see https://github.com/kubernetes/kubernetes/releases
CONFIG_KREW_VERSION = 'v0.4.3' # see https://github.com/kubernetes-sigs/krew/releases
CONFIG_K9S_VERSION = 'v0.27.4' # see https://github.com/derailed/k9s/releases

# see https://launchpad.net/ubuntu/+archivemirrors
# see https://launchpad.net/ubuntu/+mirror/mirrors.ptisp.pt-archive
CONFIG_UBUNTU_MIRROR = 'http://mirrors.ptisp.pt/ubuntu/'

hosts = """
127.0.0.1	localhost
#{CONFIG_PANDORA_IP_ADDRESS} #{CONFIG_PANDORA_FQDN}

# The following lines are desirable for IPv6 capable hosts
::1     localhost ip6-localhost ip6-loopback
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
"""

Vagrant.configure(2) do |config|
  config.vm.box = 'ubuntu-22.04-amd64'

  config.vm.provider 'libvirt' do |lv, config|
    lv.memory = 2*1024
    lv.cpus = 4
    lv.cpu_mode = 'host-passthrough'
    lv.nested = true
    lv.keymap = 'pt'
    lv.machine_virtual_size = 60 # [GiB]
    lv.disk_driver :discard => 'unmap', :cache => 'unsafe'
    # configure the vagrant synced folder.
    lv.memorybacking :source, :type => 'memfd'  # required for virtiofs.
    lv.memorybacking :access, :mode => 'shared' # required for virtiofs.
    config.vm.synced_folder '.', '/vagrant', type: 'virtiofs'
    #config.vm.synced_folder '.', '/vagrant', type: 'nfs', nfs_version: '4.2', nfs_udp: false
  end

  config.vm.provision "shell", path: "provision-resize-disk.sh"

  config.vm.define :pandora do |config|
    config.vm.provider 'libvirt' do |lv, config|
      lv.memory = 16*1024
    end
    config.vm.hostname = CONFIG_PANDORA_FQDN
    config.vm.network :private_network, ip: CONFIG_PANDORA_IP_ADDRESS, libvirt__forward_mode: 'none', libvirt__dhcp_enabled: false
    config.vm.provision 'shell', inline: 'echo "$1" >/etc/hosts', args: [hosts]
    config.vm.provision 'shell', path: 'provision-apt-cacher.sh', args: [CONFIG_UBUNTU_MIRROR, CONFIG_PANDORA_FQDN]
    config.vm.provision 'shell', path: 'provision-base.sh', args: [CONFIG_UBUNTU_MIRROR, CONFIG_PANDORA_FQDN]
    config.vm.provision 'shell', path: 'provision-certificate.sh', args: [CONFIG_PANDORA_FQDN]
    config.vm.provision 'shell', path: 'provision-dns-server.sh', args: [CONFIG_PANDORA_IP_ADDRESS, CONFIG_PANDORA_FQDN]
    config.vm.provision 'shell', path: 'provision-docker.sh', args: [CONFIG_DOCKER_VERSION], reset: true
    config.vm.provision 'shell', path: 'provision-eksctl-anywhere.sh', args: [CONFIG_EKSCTL_ANYWHERE_VERSION]
    config.vm.provision 'shell', path: 'provision-eksctl.sh', args: [CONFIG_EKSCTL_VERSION]
    config.vm.provision 'shell', path: 'provision-kubectl.sh', args: [CONFIG_KUBECTL_VERSION, CONFIG_KREW_VERSION]
    config.vm.provision 'shell', path: 'provision-k9s.sh', args: [CONFIG_K9S_VERSION]
    config.vm.provision 'shell', path: 'provision-management-cluster.sh', privileged: false
  end
end
