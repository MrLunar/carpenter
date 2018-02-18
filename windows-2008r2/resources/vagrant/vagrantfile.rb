Vagrant.configure('2') do |config|
  config.vm.guest = :windows
  config.vm.communicator = 'winrm'

  config.vm.network :forwarded_port, guest: 3389, host: 33389, id: 'rdp', auto_correct: true

  config.vm.provider 'virtualbox' do |v|
    v.memory = 1024
  end
end
