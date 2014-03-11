# graveio - where your code stays alive
[![Build Status](https://travis-ci.org/kmerz/graveio.png)](https://travis-ci.org/kmerz/graveio)

graveio provides an easy-to-use and install Pastebin-Solution
intended for inhouse Use.

![Screenshot](https://raw.github.com/kmerz/graveio/master/screenshot.png)

It was developed with *ruby 1.9.3p0* and *rails 3.2*.

Installing:
-  clone this repository
-  install 'ruby 1.9', 'nodejs' and a database of your choice (e.g. postgresql, sqlite3)
-  install Bundler: `gem install bundler`
-  adjust Gemfile to match your database (e.g. gem "pg" for postgresql)
-  call `bundle install` inside of repository
-  call `rake db:create && rake db:migrate`
-  call `rake test` to ensure that everything works

Launching:
-  `rails s`

This will run Rails in development mode on port 3000.

For easier posting of content to graveio, you can use bury, a Ruby command line
tool which also integrates with Vim. You can find it in `public/bin/bury.rb`.

At this state of development take a look for a help at Rails Guides site.

## Virtual Test and Development Environment

To give gravio a try we provide an automated process to set up a virtual
test/development machine with VirtualBox and Vagrant.

### Requirements

* [VirtualBox](https://www.virtualbox.org)
* [Vagrant](http://vagrantup.com)

### Bootstrapping the Virtual Development Machine

```
git clone https://github.com/kmerz/graveio.git
cd graveio
git submodule init
git submodule update
vagrant up
```

This sets up a virtual development machine host __graveio-dev__ based on
Ubuntu 12.04. providing ruby 1.9.3 via rvm(1), the latest nodejs stable
release and sqlite3 as database.
The IP address assigned to the host is 192.168.10.10 which can be changed
by adapting the parameter "config.vm.network" in
[Vagrantfile](https://github.com/kmerz/graveio/blob/master/Vagrantfile)
accordingly.
The setup takes a couple of minutes. After the installation has finished
you can login to the machine by running: `vagrant ssh`

### Running graveio in the Virtual Machine

Run the following steps to install graveio within the Virtual Development
Machine:

```
vagrant ssh
cd /vagrant
bundle install
rake db:create && rake db:migrate
rake test
rails s
```

Then, open your favorite browser and point it to http://192.168.10.10:3000

## Contributing to graveio

If you would like to contribute to graveio clone it from
[https://github.com/kmerz/graveio](https://github.com/kmerz/graveio.git).

Please add tests along with new code. If you want to contribute new
code please accept the maximum width of 80 characters per line in source files.

We are now running all of our tests on
[Travis-CI](https://travis-ci.org/kmerz/graveio).

Thanks to the contributors:
-  [flowm](https://github.com/flowm)
-  [dloss](https://github.com/dloss)
-  [vitorbal](https://github.com/vitorbal)
-  [darinkes](https://github.com/darinkes)
-  [h5b](https://github.com/h5b)
-  [basti1508](https://github.com/basti1508/)
-  [mafigit](https://github.com/mafigit)
