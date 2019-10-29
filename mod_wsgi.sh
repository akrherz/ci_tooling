
sudo apt-get install apache2 apache2-dev
sudo a2enmod headers rewrite proxy cgi expires authz_groupfile
pip install --upgrade mod-wsgi

MOD_WSGI_SO=$(find $HOME/miniconda/envs/prod -type f -name 'mod_wsgi*.so')
echo $MOD_WSGI_SO
echo "LoadModule wsgi_module $MOD_WSGI_SO" | sudo tee -a /etc/apache2/mods-enabled/wsgi.load > /dev/null
echo "WSGIApplicationGroup %{GLOBAL}" | sudo tee -a /etc/apache2/mods-enabled/wsgi.load > /dev/null
sudo service apache2 restart
sudo systemctl status apache2.service -l
