# cap-qlds
Capistrano deployment for quake live dedicated server (qlds)

## Overview
In order to use this code you will first need to have ruby (at least 2.0) installed. Once you have installed ruby you will need to clone this repository and run `bundle install` in the directory to pull the dependencies.

This application uses [capistrano](https://github.com/capistrano/capistrano) to handle code deployments and follows the standard conventions for the directory structure of the deployment.

[Supervisor](http://supervisord.org/) is configured to manage the qlds instances and will auto restart any instances that crashes. The application also configures an upstart configuration for starting supervisor on server boot. This means that your qlds instances should start anytime the server is rebooted.

This application has only been tested on Ubuntu and relies on upstart for starting the supervisor service.

By default the application is deployed to: `/home/steam/qlds`.

## Server Setup
On a new server login as root and run the following:
```
apt-get update
apt-get install -y curl
bash -c "$(curl -sSL https://raw.githubusercontent.com/vtchill/cap-qlds/master/config/setup/qlds_root.sh)"
```

This will create a new user `steam` and will ask you to set a password for this user.

Next login as the `steam` user and run the following:
```
bash -c "$(curl -sSL https://raw.githubusercontent.com/vtchill/cap-qlds/master/config/setup/qlds_steam.sh)"
```

Add your ssh key to the authorized_keys for the `steam` user (optional, but recommended)
```
mkdir -p ~/.ssh
touch ~/.ssh/authorized_keys
```

append your ssh key to the end of the file `~/.ssh/authorized_keys`

## Configuration files
This repository contains examples of the main configuration files that are used during deployment. These files are named: `.env.example` and `config/qlds.example.yml`. The easiest way to get started is to simply copy the contents of these files into a new file with the naming conventions `env.<deployment_environment>` and `config/qlds.<deployment_environment>.yml`. The instructions below assume you are using `production` as your deployment environment but this is not a requirement. You just need to make sure your files are named correctly.

## Deployment
To manage your server list you will need to create a file in `config/deploy` that matches your deployment environment (e.g. `config/deploy/production.rb`).
By default `production.rb` and `staging.rb` are provided and contain code examples.

To follow with the example above we will use `production` as our deployment environment. Add your server information to this file (one line per server) following the server samples in the file.

The command to deploy code is:
```
cap <deployment_environment> deploy
```

Continuing with the above example you would use the following command:
```
cap production deploy
```
