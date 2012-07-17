pictoscrawl !
==================

A pretty basic HTML5 demo using websockets to add real time chat and a shared drawing space to a webpage

Installation
------------

The majority of the installation will be handled by rake, however to run the messaging server you need a 
few python eggs available on the system - specifically Twisted, PyYAML and txWS.

Once these are available, the `rake run` task should deal with anything else and serve the application on
http://localhost:8000


