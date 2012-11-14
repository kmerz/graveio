# graveio - where your code stays alive

graveio is a attempt to provide a simple, easy to use and install paste bin
solution for inhouse use.

It was developed with *ruby 1.9.3p0* and *rails 3.2*.

For install:
-  clone this repository
-  install 'ruby 1.9', 'nodejs' and a database of your choice (e.g. postgresql, sqlite3)
-  install Bundler: `gem install bundler`
-  adjust Gemfile for your database (e.g. gem "pg" for postgresql)
-  call `bundle install` inside of repository
-  call `rake db:create && rake db:migrate`
-  to ensure that everything works, you can call: `rake test`

Launch:
-  `rails s`

This will run rails in development mode on port 3000.

For easier posting of content to graveio, you can use bury, a ruby command line
tool which also integrates to vim. You can find it in `public/bin/bury.rb`.

At this state of developement take a look for a help at rails guides site.

Thanks to the contributors:
-  [flowm](https://github.com/flowm)
-  [dloss](https://github.com/dloss)
-  [vitorbal](https://github.com/vitorbal)
