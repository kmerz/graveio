[![Build Status](https://travis-ci.org/kmerz/graveio.png)](https://travis-ci.org/kmerz/graveio)

# graveio - where your code stays alive

graveio provides an easy-to-use and install Pastebin-Solution
intended for inhouse Use.

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

## Contributing to graveio

If you would like to contribute to graveio clone it from
[https://github.com/kmerz/graveio](https://github.com/kmerz/graveio.git).

Please add tests along with new code. If you want to contribute new
code please accept the maximum width of 80 characters per line in source files.

Thanks to the contributors:
-  [flowm](https://github.com/flowm)
-  [dloss](https://github.com/dloss)
-  [vitorbal](https://github.com/vitorbal)
-  [darinkes](https://github.com/darinkes)
