## DOPA Virtual Machine (Alpha Version)

http://www.dopa-project.eu

This is a portable DOPA testing and development environment. It consists
of a set of configuration scripts that automate the creation of a virtual
machine that runs Stratosphere.

The virtual machine makes it easy to learn about using, modify, and improving the
DOPA platform software Stratosphere.


## Prerequisites

You'll need to install recent versions of Vagrant and VirtualBox.

 * VirtualBox: https://www.virtualbox.org/wiki/Downloads
 * Vagrant: http://downloads.vagrantup.com/

Next, you'll need a copy of the vm that you can downlod from this git repository.


## Installation

Download the content of this repository and extract it to a directory of your choice.
Once you have done that, open up a terminal or a command-prompt, and change your
working directory to the location of the extracted (or git-cloned) files.
From there, run `vagrant up` to provision and boot the virtual machine.

You'll now have to wait a bit (15-20 min), as Vagrant needs to retrieve the base image from
Canonical, retrieve some additional packages, and installs and configures each of
them.

If it all worked, you should be able to browse to http://localhost:8090/ and
see the main page of your DOPA test instance.

You can close the vagrant session by the command 'vagrant halt'.


## Shell Usage

To access a command shell on your virtual environment, run `vagrant ssh` from
the root the directory you downlaoded the virtual machine to.

From Windows this might cause problems see:
http://stackoverflow.com/questions/9885108/ssh-to-vagrant-box-in-windows


## Developing the Stratosphere platform

If you want to change the Stratosphere Platform you need to enable
the developer role in dopa-vm\puppet\manifests\site.pp.

This is not required for developing PACT or Meteor programs.

## Getting started

There are two main entry for new users. If you are a expericenced JAVA developer,
are familar with the MapReduce concept and you want to model´l your data flow graphs
by your self you probably want to work on the PACT level.
Otherwise, it might be easier to start with a simple meteor program.

### PACT

To access the PACT web iterface navigate to

http://localhost:8081/launch.html

You should see a page titled Stratosphere Query Interface.
Now you can start with the 'hello world' anlagon for MapReduce 'WordCount'.
The wordcount example is preshipped with your Stratosphere installation. Upload

stratosphere\examples\pact\pact-examples-${Version}-WordCount.jar

from the your local download copy of the DOPA-VM to the web interface.

Check the checkbox in the right frame of the new word count example and spcify e.g.

4 file:///dopa-vm/data/opendata/wikienmath.xml file:///dopa-vm/data/output/wordcount1.csv

as arguments.
Click 'run job' and click run on the next page again.


## Bug Reporting

To track bugs in the project dopa-vm, you can use the bugtracking tool Bugzilla. 

* Bugzilla: http://dopa.dima.tu-berlin.de/bugzilla3/

Either you can use the webfrontend and manually manage bugs or either commit 
your changes via Git. To use the webfrontend, you need to create a user account 
and log in.
