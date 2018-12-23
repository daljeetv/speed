#!/bin/bash

usage ()
{
    echo 'Please provide exactly one argument, either:'
    echo '  -c to create a new database from scratch'
    echo '  -p to clone the production database'
    echo '  -s to clone the staging database'
    echo 'Exiting now'
    exit 1
}

update_profile ()
{
    echo "# begin added by post_vagrant.sh" >> ${HOME}/.profile
    echo "export PGUSER=postgres"           >> ${HOME}/.profile
    echo "export PGPASSWORD=postgres"       >> ${HOME}/.profile
    echo "export PGHOST=localhost"          >> ${HOME}/.profile
    echo "# end added by post_vagrant.sh"   >> ${HOME}/.profile
}

# check arguments
if [[ 1 != $# ]]
then
    usage
fi
if ! [[ '-c' == $1 || '-p' == $1 || '-s' == $1 ]]
then
    usage
fi

# make sure there's no .env file so it doesn't quit later
#if [[ -e '/vagrant/.env' ]]
#then
#    echo 'Please rename or remove file: /vagrant/.env'
#    exit 1
#fi

# check heroku login status
export HEROKU_ORGANIZATION=a16z
if ! [[ $(heroku auth:whoami) =~ @a16z\.com$ ]]
then
    heroku login --sso
fi

# configure heroku APP_NAME
APP_NAME=a16z-speed

if [[ '-p' == $1 ]]
then
    echo 'production'
fi
if [[ '-s' == $1 ]]
then
    echo 'staging'
    APP_NAME=speed-staging
fi

# prepare the environment
update_profile
. ${HOME}/.profile
#/vagrant/server/scripts/make_dotenv_file.py -a ${APP_NAME} -e /vagrant/.env

# prepare the database
sudo su - postgres -c psql <<PSQL
  ALTER USER postgres WITH PASSWORD 'postgres';
PSQL

if [[ '-c' == $1 ]]
then
    # create the database from scratch
    echo 'create'
    createdb speed_development
else
    # create the database from production or staging based on APP_NAME
    heroku pg:pull DATABASE_URL speed_development -a $APP_NAME
fi
