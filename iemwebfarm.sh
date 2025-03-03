#  Get a IEM Webfarm node ready for action
#  Requires: micromamba to have been run
#
sudo mkdir /opt/iemwebfarm
sudo git clone https://github.com/akrherz/iemwebfarm.git /opt/iemwebfarm

sudo apt-get update
sudo apt-get install apache2 apache2-dev php-fpm php-mapscript-ng

python -m pip install mod_wsgi
sudo cp /opt/iemwebfarm/apache_conf.d/mod_wsgi.conf /etc/apache2/sites-enabled/
# This may be a requirement for mod-wsgi to properly find python tooling?
echo "export PATH=/home/runner/micromamba/envs/prod/bin:$PATH" | sudo tee -a /etc/apache2/envvars > /dev/null
# Newer PROJ needs this
echo "export PROJ_LIB=/home/runner/micromamba/envs/prod/share/proj" | sudo tee -a /etc/apache2/envvars > /dev/null
MOD_WSGI_SO=$(find $HOME/micromamba/envs/prod -type f -name 'mod_wsgi*.so')
echo $MOD_WSGI_SO
echo "LoadModule wsgi_module $MOD_WSGI_SO" | sudo tee -a /etc/apache2/mods-enabled/wsgi.load > /dev/null;
echo "WSGIApplicationGroup %{GLOBAL}" | sudo tee -a /etc/apache2/mods-enabled/wsgi.load > /dev/null;

sudo cp /opt/iemwebfarm/apache_conf.d/iemwebfarm.conf /etc/apache2/sites-enabled/
sudo mkdir /etc/systemd/system/apache2.service.d
sudo cp systemd/apache2_override.conf /etc/systemd/system/apache2.service.d/override.conf
sudo systemctl daemon-reload

# Setup the log directory
sudo mkdir -p /mesonet/www/logs

# Ensure the home directory can be seen by apache
chmod 755 $HOME

# Configure apache
sudo a2enmod headers rewrite proxy proxy_http proxy_balancer ssl lbmethod_byrequests cgi expires authz_groupfile

# allow vhosts
sudo a2dissite 000-default.conf

# Create tmp folder for matplotlib
sudo mkdir -p /var/cache/matplotlib
sudo chown www-data /var/cache/matplotlib

sudo systemctl restart apache2

# Write a simple PHP script into the web root and ensure that we can access it
echo "<?php phpinfo(); ?>" | sudo tee /var/www/html/info.php > /dev/null
curl -f http://localhost/info.php
