Vagrant.configure("2") do |config|
	# Set up the box as an Ubuntu Precise server:
	config.vm.box       = "precise64"
	config.vm.box_url   = "http://cloud-images.ubuntu.com/vagrant/precise/current/precise-server-cloudimg-amd64-vagrant-disk1.box"

	# Basic setup:
	config.vm.hostname  = "php-ci.net"

	# Set up networking:
	config.vm.network :private_network, ip: "10.0.8.10"

	# Set up a synced directory:
	#config.vm.synced_folder	"./", "/phpci"

	# VirtualBox config:
	config.vm.provider :virtualbox do |vb|
	    # Set VM name:
	    vb.name = "PHPCI"

		# Make it headless:
		vb.gui = false

		# Set memory level:
		vb.customize ["modifyvm", :id, "--memory", "2048"]
	end

	# Provisioning script:
	config.vm.provision :shell, :path => "conf/vagrant/host-provision.sh"
end
