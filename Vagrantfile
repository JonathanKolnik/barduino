# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "precise64"
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"

  config.vm.network :forwarded_port, host: 8080, guest: 3000

  config.vm.network :private_network, ip: "192.168.33.20"
  config.vm.synced_folder ".", "/vagrant", nfs: true

  config.vm.provider :virtualbox do |vb|

    vb.name = "barduino"

    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]

    # [GMB] from what I've seen anything less than 2GB and phantomjs won't
    # have a good time running alongside a test environment
    vb.memory = 3072

    # [AB] Give vagrant 2 cores
    vb.cpus = 2

    # [AB] I'm not sure we want to set the execution cap, commenting out for now
    #vb.customize ["modifyvm", :id, "--cpuexecutioncap", "50"]
  end

  config.vm.provider :vmware_fusion do |v, override|
    override.vm.box_url = "http://files.vagrantup.com/precise64_vmware.box"
    v.vmx["memsize"] = "3072"
    v.vmx["numvcpus"] = "2"
  end

  config.vm.provision :shell, inline: <<-SCRIPT
  apt-get update
  apt-get upgrade
  debconf-set-selections <<< 'mysql-server-5.5 mysql-server/root_password password abc123'
  debconf-set-selections <<< 'mysql-server-5.5 mysql-server/root_password_again password abc123'
  apt-get -y install mysql-server g++ libfontconfig1 memcached nodejs zip git libmysqlclient-dev libssl-dev make libreadline-dev python-software-properties curl openjdk-7-jre-headless

  # add the PPA for redis 2.6 so sidekiq will run
  add-apt-repository ppa:rwky/redis
  apt-get update
  apt-get install redis-server

  cd /usr/local/share
  wget -q https://phantomjs.googlecode.com/files/phantomjs-1.9.0-linux-x86_64.tar.bz2
  tar xjf phantomjs-1.9.0-linux-x86_64.tar.bz2
  rm /usr/local/share/phantomjs /usr/local/bin/phantomjs /usr/bin/phantomjs
  ln -s /usr/local/share/phantomjs-1.9.0-linux-x8664/bin/phantomjs /usr/local/share/phantomjs; sudo ln -s /usr/local/share/phantomjs-1.9.0-linux-x8664/bin/phantomjs /usr/local/bin/phantomjs; sudo ln -s /usr/local/share/phantomjs-1.9.0-linux-x86_64/bin/phantomjs /usr/bin/phantomjs
  SCRIPT

  config.vm.provision :shell, :path => "vagrant/postgres.sh"

  #config.vm.provision :shell, inline: <<-SCRIPT
  #wget -q https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.2.1.deb
  #dpkg -i elasticsearch-1.2.1.deb
  #update-rc.d elasticsearch defaults 95 10
  #/etc/init.d/elasticsearch start
  #SCRIPT

  config.vm.provision :shell, privileged: false, inline: <<-SCRIPT
  if [ -d "/home/vagrant/.rbenv" ]; then
    cd /home/vagrant/.rbenv
    git pull
    cd /home/vagrant/.rbenv/plugins/ruby-build
    git pull
  else
    git clone https://github.com/sstephenson/rbenv.git /home/vagrant/.rbenv
    git clone https://github.com/sstephenson/ruby-build.git /home/vagrant/.rbenv/plugins/ruby-build
  fi
  echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile
  # adding binstubs to path, which should be ok since this vagrant only has one rails project
  echo 'export PATH="/vagrant/bin:$PATH"' >> ~/.bash_profile
  echo '# tune ruby GC especially for rspec' >> ~/.bash_profile
  echo 'export RUBY_GC_MALLOC_LIMIT=100000000' >> ~/.bash_profile
  echo 'export RUBY_GC_HEAP_INIT_SLOTS=1000000' >> ~/.bash_profile
  echo 'export RUBY_HEAP_FREE_MIN=10000' >> ~/.bash_profile
  echo 'eval "$(rbenv init -)"' >> ~/.bash_profile
  echo 'cd /vagrant/' >> ~/.bash_profile
  SCRIPT

  config.vm.provision :shell, privileged: false, inline: <<-SCRIPT
  rbenv install 2.1.2
  rbenv global 2.1.2
  rbenv rehash
  cd /vagrant
  gem install bundler
  rbenv rehash
  bundle install --full-index
  rbenv rehash
  mkdir -p tmp
  rake db:create
  rake db:migrate

  # MR: 2014/07/01 disabling this step as part of the postgres migration
  #rake parallel:create
  #rake parallel:prepare
  #rake environment elasticsearch:import:all
  SCRIPT

end
