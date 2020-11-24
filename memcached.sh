###
# Setup Memcached

sudo apt-get -qq install -y --no-install-suggests --no-install-recommends memcached
sudo systemctl start memcached
sudo systemctl status memcached -l
