VAGRANTFILE_API_VERSION = "2"

$script = <<SCRIPT

# Install stuff in noninteractive mode, so MySQL doesn't prompt for a root password
export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y sudo apache2 php5 mysql-server php5-mysql
export DEBIAN_FRONTEND=

# Whip up a random password
export RANDPASS="$(< /dev/urandom tr -dc A-Z-a-z-0-9 | head -c${1:-16})"
echo $RANDPASS > /etc/phpci_root_password

# And set it as the MySQL root
mysqladmin -u root password "$RANDPASS"
mysqladmin -u root -h localhost password "$RANDPASS"
service mysql restart

# Configure apache to serve /vagrant/public/ as a default site
# Also enable mod_rewrite, since almost everything uses it nowadays
a2dissite default

cat >/etc/apache2/sites-available/vagrant <<EOL
<VirtualHost *:80>
	ServerAdmin webmaster@localhost
	DocumentRoot /vagrant/public/
    
	<Directory /vagrant/public/>
		Options Indexes FollowSymLinks MultiViews
		AllowOverride All
		Order allow,deny
		allow from all
        
        RewriteEngine on
        RewriteCond \$1 !^(index\\.php|assets)
        RewriteRule ^(.*)$ /vagrant/public/index.php/$1 [L]
        
	</Directory>
	
    ErrorLog /var/log/apache2/vagrant-error.log
	LogLevel warn
	CustomLog /var/log/apache2/vagrant-access.log combined
</VirtualHost>
EOL

a2ensite vagrant
a2enmod rewrite
service apache2 restart

# Install Composer
(su vagrant; cd /vagrant; php -r "eval('?>'.file_get_contents('https://getcomposer.org/installer'));")

# And use composer to install everything else
(su vagrant; cd /vagrant/; php composer.phar update)

# Make config.yml, and make it writeable
touch /vagrant/PHPCI/config.yml
chmod 0777 /vagrant/PHPCI/config.yml

SCRIPT

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "base"
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"
  config.vm.provision "shell", inline: $script
  config.vm.network "forwarded_port", guest: 80, host: 8080
end