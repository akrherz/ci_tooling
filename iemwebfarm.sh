# Setup iemwebfarm common stuff

sudo mkdir /opt/iemwebfarm
sudo git clone https://github.com/akrherz/iemwebfarm.git /opt/iemwebfarm

sudo cp /opt/iemwebfarm/config/iemwebfarm.conf /etc/apache2/sites-enabled/
