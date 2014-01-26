# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

BOX = RUBY_PLATFORM.index("x86_64").nil? ? "precise32" : "precise64" 

PROVISION_SCRIPT = <<END

install_package()
{
    PACKAGE=$1

    if ! dpkg -l "$PACKAGE" | grep ^ii; then
        apt-get install -y $PACKAGE
    fi
}

LAST_UPDATE=$(stat --format %Y /var/cache/apt/pkgcache.bin)
CURRENT_TIME=$(date +%s)

if [ "$LAST_UPDATE" -lt $(($CURRENT_TIME-24*60*60)) ]; then
    apt-get update
fi

install_package git
install_package curl

if ! [ -f /usr/local/rvm/scripts/rvm ]; then
    curl -L https://get.rvm.io | bash -s stable --ruby=2.1.0

    echo "" >> /etc/bashrc
    echo ". /usr/local/rvm/scripts/rvm" >> /etc/bashrc
    . /usr/local/rvm/scripts/rvm
fi

if ! [ /usr/local/rvm/gems/ruby-2.1.0/bin/bundle ]; then
    gem install bundler
fi

cd /home/vagrant/poker-croupier && bundle install

END

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = BOX
  config.vm.box_url = "http://files.vagrantup.com/#{BOX}.box"

  config.vm.provision :shell, :inline => PROVISION_SCRIPT

  config.vm.synced_folder ".", "/home/vagrant/poker-croupier"

  config.vm.network :private_network, ip: "10.1.0.101"
end