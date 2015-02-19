# Sample Application for Demonstrating Testing

This application goes alone with the Talk given at Chicago Erlang User Group on February 19th, 2015.

Talk Info: http://www.meetup.com/ErlangChicago/events/220276271/
Slides: http://slides.sigma-star.com
Video: (not uploaded yet)

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

## Different Tags demonstrate progress along the way

* `no-tests` - there are no tests at this point, just a bare, but working application
* `skeleton` - Basic test skeleton in place with configuration
* `basic-tests` - first set of tests


# License

Copyright 2015 Jesse Gumm
MIT License
