# Setup iemwebfarm common stuff

sudo mkdir /opt/iemwebfarm
sudo git clone https://github.com/akrherz/iemwebfarm.git /opt/iemwebfarm

sudo cp /opt/iemwebfarm/apache_conf.d/iemwebfarm.conf /etc/apache2/sites-enabled/

sudo mkdir /etc/systemd/system/apache2.service.d
sudo cp systemd/apache2_override.conf /etc/systemd/system/apache2.service.d/override.conf
sudo systemctl daemon-reload
