###
# As of 18 Aug 2023: GHA is running Ubuntu 22.04

# Ensure repo info is current
sudo rm /etc/apt/sources.list.d/pgdg.list || true
echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" | sudo tee /etc/apt/sources.list.d/pgdg.list
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
sudo apt-get -qq update || true

sudo apt-get -qq install -y --no-install-suggests --no-install-recommends postgresql-17-postgis-3-scripts postgresql-17 postgresql-client-17 postgresql-17-postgis-3
sudo systemctl status postgresql@17-main.service || true
sudo systemctl stop postgresql@17-main.service || true
# https://travis-ci.community/t/postgres-default-port-changed-from-5432-to-5433/7347/10
sudo sed -i "s/^data_directory.*/data_directory = \'\/var\/lib\/postgresql\/17\/main\/\'/" /etc/postgresql/17/main/postgresql.conf
sudo sed -i 's/^port.*/port = 5432/' /etc/postgresql/17/main/postgresql.conf
sudo sed -i 's/scram-sha-256/trust/' /etc/postgresql/17/main/pg_hba.conf
sudo sed -i 's/peer/trust/' /etc/postgresql/17/main/pg_hba.conf
sudo systemctl reload postgresql@17-main.service || true
sudo systemctl start postgresql@17-main.service
sudo systemctl status postgresql@17-main.service -l
sudo cat /var/log/postgresql/postgresql-17-main.log

export PATH="/usr/lib/postgresql/17/bin:$PATH"
psql -h 127.0.0.1 -c 'CREATE ROLE runner SUPERUSER LOGIN CREATEDB;' -U postgres || true
