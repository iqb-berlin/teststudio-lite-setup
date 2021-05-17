[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=flat-square)](https://opensource.org/licenses/MIT)

# Teststudio-Lite Setup
Following the instructions below, you will install the web-application "IQB-Teststudio-Lite" on your server. You will get handy commands to start and stop the services.

## Application structure
The source code and therefore the application is separated in two submodules:
* Frontend: Angular based components to be loaded into the browser as single page application. You find the source code repository [here](https://github.com/iqb-berlin/teststudio-lite-frontend).
* Backend php+database: Php based components to handle most of the requests from frontend; connects to the database; source code ist published [here](https://github.com/iqb-berlin/teststudio-lite-backend)

In order to install the whole application, one must install all components. Sure, this could be done the traditional way:
* clone the code repositories
* install the required software (npm install/compose)
* transpile/build
* setup database
* setup web server, set routes etc.

To ease this process and to avoid mess after updates/upgrades, every module consist of one folder "docker". There you find scripts for docker based installation. The repository of this document you're reading now binds all docker install procedures together. This way, you install everything you need in one step.

# Preconditions
Before you follow the instructions below, you need to install [docker](https://docs.docker.com/engine/install/ubuntu/#installation-methods),  [docker-compose](https://docs.docker.com/compose/install/) and `make`. We do not explain these applications, this is beyond the scope of this document.

Although all steps below could be done in another operating system environment, we go for a unix/linux.

# Installation for production only
"Production" here means that you just want to install and use the application, not more. You do not like to get a look behind the curtain or to run sophisticated performance analyses. This type of installation has fewer requirements in regard of software and space.

Technically, you download pre-built images from Docker Hub.

## 1. Download install script and config
The installation script requires bash to run. Go to a directory of your choice and get it:
```
 wget https://raw.githubusercontent.com/iqb-berlin/iqb-scripts/master/install.sh
```
Also download the project's specific configuration for the install script:
```
 wget https://raw.githubusercontent.com/iqb-berlin/teststudio-lite-setup/master/config/install_config
```
## 2. Run installation
```
 bash install.sh
```
Now, your system will get checked to ensure that you have `docker`, `docker-compose` and `make` ready to work. Then, you need to put in some parameters for your installation:
* target directory
* host name (can be changed later)
* database connection parameters (database name, root password etc.)
* tls or not - can be changed later, but not that easily

The script will download and unpack the latest release and set up your configuration file. 

## 3. Run server
After the script has finished with message "--- INSTALLATION SUCCESSFUL ---", you may edit the file _.env_ in the target directory and change any password or other settings. Then go to your target directory and type
```
make run
```
Docker will then start all containers: Frontend, Backend, and one traefik service to handle routing. To check, go to another computer and put in the host's name of the installation - and enjoy!

If you like to stop the server later, run
```
make stop
```
## 4. Login and change super user password
Right after installation, please log in! At start, you have one user prepared: `super` with password `user123`. Because everyone can read this here and in the scripts, you should get up your shields by changing at least the password (on start page, click on the gear wheel icon).

## 5. Upload Verona modules
In the admin section of the application (gear wheel icon), you find 'Editoren/Player' to upload code for editors and players. These modules enable editing and preview of pages/tasks.

## SSL
All communication to your server should be SSL/TLS based - most browsers will deny or at least hinder unit download. For a setup using SSL certificates (HTTPS connection), the certificates need to be placed under _config/certs_, and their name to be put in _config/cert_config.yml_. Please decide early upon ssl or not, because the installation process varies.

## Updating
Run the script _update.sh_ in the root directory. This will compare your local component versions with the latest release and can update and restart the software stack.

You may also edit manually the file `docker-compose.prod.yml`. Find the lines starting with **image** and edit the version tag at the end.

Check the [IQB Docker Hub Page](https://hub.docker.com/u/iqbberlin) for latest images.

## Run detached
Every startup command can be used in detached mode, which will free up the console or in blocking mode which uses the current console window
for all logging. Refer to the OS commands for sending processes to the background etc.

```
make run-detached
```
For attached console mode simply terminate the process (Ctrl+C under Linux).

When in detached mode you may use the following command to stop the applications.
```
make stop
```

# Development environment

Because git submodules are used for development environment, you need to clone them as well as the main repository. You can use the following command:

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

Stop the containers and pull the latest version from Git. Don't forget to
update the submodules as well to get the latest component releases.
```
make stop
git pull
make update-submodules
make run
```
