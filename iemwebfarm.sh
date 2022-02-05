# Setup iemwebfarm common stuff

sudo mkdir /opt/iemwebfarm
sudo git clone https://github.com/akrherz/iemwebfarm.git /opt/iemwebfarm

sudo cp /opt/iemwebfarm/apache_conf.d/iemwebfarm.conf /etc/apache2/sites-enabled/
