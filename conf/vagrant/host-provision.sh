export DEBIAN_FRONTEND=noninteractive

# Add the nginx repository:
wget -q http://nginx.org/keys/nginx_signing.key
apt-key add nginx_signing.key
echo "deb http://nginx.org/packages/ubuntu/ precise nginx" > /etc/apt/sources.list.d/nginx.list
rm -f nginx_signing.key

# Add the Docker repository:
sudo sh -c "curl https://get.docker.io/gpg | apt-key add -"
sudo sh -c "echo deb http://get.docker.io/ubuntu docker main > /etc/apt/sources.list.d/docker.list"

# Remove apparmor if installed:
apt-get -fy remove apparmor

# Update Apt:
apt-get update

# Install MySQL and:
apt-get -qy install mysql-server
sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mysql/my.cnf
mysql -e "GRANT ALL PRIVILEGES ON *.* to root@'%';"

# Set up nginx:
apt-get install -y nginx
rm -f /etc/nginx/conf.d/default.conf
rm -f /etc/nginx/conf.d/example_ssl.conf
rm -f /etc/nginx/conf.d/vagrant.conf
ln -s /vagrant/conf/vagrant/host-nginx.conf /etc/nginx/conf.d/vagrant.conf

# Install Docker
apt-get -qy install lxc-docker

# Build Docker image for PHPCI and run it:
cd /vagrant && docker build -t="phpci" .
docker run -p 5000:5000 -v /vagrant:/www/phpci -d -i -t phpci

# Restart nginx:
service nginx restart