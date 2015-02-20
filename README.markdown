# Sample Application for Demonstrating Testing

This application goes alone with the Talk given at Chicago Erlang User Group on February 19th, 2015.

Talk Info: http://www.meetup.com/ErlangChicago/events/220276271/
Slides: http://slides.sigma-star.com

## Installation

```bash
git clone git://github.com/choptastic/nitrogen_test_example
cd nitrogen_test_example
make fix-slim-release && make
```

## Starting the Server

```bash
bin/nitrogen console
```

Then open your browser to http://127.0.0.1:8000

## To run the test page

Open up http://127.0.0.1:8000/index.test

## To run the full test suite

First edit the browser you wish to test in `etc/app.config`, then restart the VM:

```
> q().
$ nitrogen console
```

Then on the newly spawned Erlang console:

```erlang
wf_test:start_all(nitrogen).
```

# License

Copyright 2015 Jesse Gumm
MIT License
