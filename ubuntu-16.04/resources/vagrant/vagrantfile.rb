Vagrant.configure('2') do |config|
  config.vm.provider 'virtualbox' do |v|
    v.memory = 512
    v.cpus = 1
  end
end
