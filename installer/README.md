# Installer

* TODO: Needs to be moved to the Wiki, keeping it in codebase until development completes

## Generating the Installer

* Install Vagrant
* Run "vagrant up linux-dev"
* It will create the entire installer inside "artifacts" folder

## Distributing and Using the Installer

* Zip up the "artifacts" folder, that's what you need
* Copy this to a Linux NetBook
* Extract and run "install.sh" inside it

## Production

* Whenever we make a release, we'll run this script to generate the installer once
* Zip-up the "artifacts" folder and upload it to DropBox
* Finally we download this zip file and take it wherever we want to do field deployments
