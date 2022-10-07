# Developers Guide

***Note:*** I do my develpment on MacOS.

## Install dependencies

I recommend using virtual environments for installing dependencies.

    python3 -m venv .venv
    source .venv/bin/activate
    pip3 install -r requirements

## During development

You can start a _Hello World_ flask server with

    make serve

Then navigate to https://localhost:5001

The source is in _server.py_

***Note:*** The default flask port, 5000, is now used by AirPlay.

Change the port with `make PORT=5002 serve`

## Run the tests

    make test

The source is in _test.sh_

This runs the basic tests:

```
./test.sh
Starting server at http://localhost:5001
✓ it should return index.html for an empty path
✓ it should return index.html for /
✓ it should return index.html for /..
✓ it should return index.html for /index.html
✓ it should return 404 for /not-found.html
✓ it should return 404 for /../LICENCE
SUCCESS! 🥳
Stopped server.
```

## Make your code changes and commit them to git

For you to do... 😜

## Bump the version

To bump the minor version:

    make bump

You can bump the other levels too (major, minor, patch)

    make BUMP=major bump

***Note:*** This will change _flask\_staticdirs/\_init\_.py_ so you'll need to commit it.

## Build and verify the package

    make build

## Publish the package

    make deploy

Or, upload to the PiPy test instance to verify all works as expected.

    twine upload --repository-url https://test.pypi.org/legacy/ dist/*