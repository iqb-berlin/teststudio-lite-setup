[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=flat-square)](https://opensource.org/licenses/MIT)

# Teststudio-Lite

Docker-Setup for the Teststudio-Lite (formally known as itemdb).

This repository aims to integrate the components of the IQB
Teststudio application and create a setup to be used in test and
production environments.\
For development/testing purposes it uses git subrepositories to pull in
the source code (including instructions on creating docker containers) of
the components from which a containers are created and orchestrated.\
For production environments pre-built containers are used.

## Running Teststudio-Lite

The most needed commands for installation and usage are kept in a
Makefile in the root directory. You can run `make <command>` on the command
line.

#### Software Prerequisites
- [docker](https://docs.docker.com/engine/install/ubuntu/#installation-methods)
- [docker-compose](https://docs.docker.com/compose/install/)
- (recommended) make

### Development environment

Because git submodules are used you need to clone them as well as the main
repository. You can use the following command.

`git clone --recurse-submodules https://github.com/iqb-berlin/teststudio-lite-setup`

#### Running
Every startup command can be used in detached mode, which will free up the console or in blocking mode which uses the current console window
for all logging. Refer to the OS commands for sending processes to the background etc.
```
make run
```
or
```
make run-detached
```
For attached console mode simply terminate the process (Ctrl+C under Linux).

When in detached mode you may use the following command to stop the applications.
```
make stop
```

#### Updating

Stop the containers and pull the latest version from git. Don't forget to
update the submodules as well to get the latest component releases.
```
make stop
git pull
make update-submodules
make run
```

### Application access

Open http://localhost in your browser. You see now the teststudio application with testdata.

You can log in with: `super` and password `user123`\
You can reach the backend with `api` path suffix.

### Production environment

- Install required software (docker, docker-compose, make)

The installation script requires bash to run. Go to a directory of your choice and get it:
```
 wget https://raw.githubusercontent.com/iqb-berlin/iqb-scripts/master/install.sh
```
Also download the project specific configuration for the install script:
```
 wget https://raw.githubusercontent.com/iqb-berlin/testcenter-setup/master/config/install_config
```

The script will check required software packages, download and unpack the latest release and set up your configuration file.
- After the script has run, you may edit the file _.env_ in the target directory and change any password or other settings.

##### SSL

For a setup using SSL certificates (HTTPS connection), the certificates need to be placed under _config/certs_ and
their name be put in _config/cert_config.yml_.

#### Updating

Run the script _update.sh_ in the root directory. This will compare your local
component versions with the latest release and can update and restart the software
stack.

You also manually edit the file `docker-compose.prod.yml`. Find the lines
starting with **image** and edit the version tag at the end.

Check the [IQB Docker Hub Page](https://hub.docker.com/u/iqbberlin) for latest images.

#### Running
Every startup command can be used in detached mode, which will free up the console or in blocking mode which uses the current console window
for all logging. Refer to the OS commands for sending processes to the background etc.
```
make run
```
or
```
make run-detached
```
For attached console mode simply terminate the process (Ctrl+C under Linux).

When in detached mode you may use the following command to stop the applications.
```
make stop
```
