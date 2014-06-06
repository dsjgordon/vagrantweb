Usage
=====
    $ git clone <repo>
    $ cd vagrantweb
    $ git submodule init
    $ git submodule update
    $ cp vagrant/example-config.json vagrant/config.json

Update config.json to suit your needs.th the 

    $ vagrantup

Abstract
========
This is a boilerplate project to provide some convenient idioms for describing a
project's dependencies with puppet, and allowing developers to run the project with 
the above process.

git submodules are used to ensure that puppet and dependencies required by the
puppet manifests are included before attempting to up the VM with vagrant.

Vagrant provides the VM using the infrastructure described by vagrant/config.json.
The defaults should be sane and should just work.

Vagrant then hands off to puppet to provide the provisioning.
puppet/manifests/dev.pp is the entry manifest and includes all of the required
features for a development VM (which is usually more than production) from the local
features module (modules/features).

This approach allows you to add more, simple manifests to your project for
deployment, build, test, staging, demo, etc, without having to re-implement any
puppet scripts or configuration management.  Simply use the same features described
in the features module, with different arguments where needed.

Note: The current features are aimed at a LAMP stack and are mostly incomplete.