pictoscrawl !
==================

A pretty basic HTML5 demo using websockets to add real time chat and a shared drawing space to a webpage. The client
is developed predominantly in [CoffeeScript](https://github.com/jashkenas/coffee-script/) and uses [RequireJS](https://github.com/jrburke/requirejs/) to provide the modular support.

A [HuzuRelay](http://www.huzutech.com/products/huzurelay) instance is setup locally to support server connections.

Installation
------------

This application requires Python (to run the messaging server) and Ruby (for the Rakefile goodness). The majority of 
the installation will be handled by rake, however to run the messaging server you need a few python eggs available 
on the system - specifically Twisted, PyYAML and [txWS](https://github.com/MostAwesomeDude/txWS/).

Once these are available, the `rake run` task should deal with anything else and serve the application on
http://localhost:8000


