Vagrant.configure('2') do |config|
  config.vm.guest = :windows
  config.vm.communicator = 'winrm'

  config.vm.network :forwarded_port, guest: 3389, host: 33389, id: 'rdp', auto_correct: true
  config.vm.network :forwarded_port, guest: 2375, host: 22375, id: 'docker', auto_correct: true

  config.vm.provider 'virtualbox' do |v|
    v.memory = 2048
  end

  config.vm.post_up_message = <<-MSG
To connect your docker client to the server, run the following:
  PowerShell: $env:DOCKER_HOST = "127.0.0.1:22375"
  Bash: export DOCKER_HOST=127.0.0.1:22375
  MSG
end
