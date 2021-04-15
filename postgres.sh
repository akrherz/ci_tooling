###
# Setup PostgreSQL 12
# As of 15 April 2021: GHA is running Ubuntu 20.04.2

# Ensure repo info is current
sudo rm /etc/apt/sources.list.d/pgdg.list || true
echo "deb http://apt.postgresql.org/pub/repos/apt/ focal-pgdg main" | sudo tee /etc/apt/sources.list.d/pgdg.list
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
sudo apt-get -qq update || true

sudo systemctl stop postgresql@10-main.service || true
sudo systemctl status postgresql@10-main.service || true
sudo apt-get -qq install -y --no-install-suggests --no-install-recommends postgresql-12-postgis-2.5-scripts postgresql-12 postgresql-client-12 postgresql-12-postgis-2.5
sudo systemctl status postgresql@12-main.service || true
sudo systemctl stop postgresql@12-main.service || true
# https://travis-ci.community/t/postgres-default-port-changed-from-5432-to-5433/7347/10
sudo sed -i "s/^data_directory.*/data_directory = \'\/var\/lib\/postgresql\/12\/main\/\'/" /etc/postgresql/12/main/postgresql.conf
sudo sed -i 's/^port.*/port = 5432/' /etc/postgresql/12/main/postgresql.conf
sudo grep port /etc/postgresql/12/main/postgresql.conf
sudo sed -i 's/md5/trust/' /etc/postgresql/12/main/pg_hba.conf
sudo sed -i 's/peer/trust/' /etc/postgresql/12/main/pg_hba.conf
sudo systemctl reload postgresql@12-main.service || true
sudo systemctl start postgresql@12-main.service
sudo systemctl status postgresql@12-main.service -l
sudo cat /var/log/postgresql/postgresql-12-main.log

export PATH="/usr/lib/postgresql/12/bin:$PATH"
psql -h 127.0.0.1 -c 'CREATE ROLE travis SUPERUSER LOGIN CREATEDB;' -U postgres || true
psql -h 127.0.0.1 -c 'CREATE ROLE runner SUPERUSER LOGIN CREATEDB;' -U postgres || true
