###
# Setup PostgreSQL 11 or 12 on Travis-CI(ubuntu xenial, bionic)

# https://travis-ci.community/t/install-postgresql-11/3894/5

# Setup ubuntugis repo
#wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
#echo "deb http://apt.postgresql.org/pub/repos/apt/ bionic-pgdg main" | sudo tee -a /etc/apt/sources.list.d/postgresql.list

# Ensure repo info is current
sudo apt-get -qq update

# https://travis-ci.community/t/bionic-postgresql-10-no-longer-starts-up/6002/13
sudo systemctl stop postgresql@9.3-main.service
sudo systemctl stop postgresql@10-main.service
sudo systemctl status postgresql@10-main.service
sudo apt-get -qq install -y --no-install-suggests --no-install-recommends postgresql-11-postgis-2.5-scripts postgresql-11 postgresql-client-11 postgresql-11-postgis-2.5
sudo systemctl status postgresql@11-main.service
sudo systemctl stop postgresql@11-main.service
# https://travis-ci.community/t/postgres-default-port-changed-from-5432-to-5433/7347/10
sudo sed -i "s/^data_directory.*/data_directory = \'\/var\/lib\/postgresql\/11\/main\/\'/" /etc/postgresql/11/main/postgresql.conf
sudo sed -i 's/^port.*/port = 5432/' /etc/postgresql/11/main/postgresql.conf
sudo grep port /etc/postgresql/11/main/postgresql.conf
sudo cp /etc/postgresql/10/main/pg_hba.conf /etc/postgresql/11/main/pg_hba.conf
sudo systemctl reload postgresql@11-main.service
sudo systemctl start postgresql@11-main.service
sudo systemctl status postgresql@11-main.service -l
sudo cat /var/log/postgresql/postgresql-11-main.log

export PATH="/usr/lib/postgresql/11/bin:$PATH"
psql -h 127.0.0.1 -c 'CREATE ROLE travis SUPERUSER LOGIN CREATEDB;' -U postgres || true
