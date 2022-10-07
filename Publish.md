# Instructions for publishing updates to PyPi:

These instructions are derived from [this](https://realpython.com/pypi-publish-python-package/) article.

This is for reference only. Most of this is captured in the _Makefile_. See [Development.md]() for details.

## Setup virtual env

    python -m venv .venv
    source .venv/bin/activate

## Install Tools

    pip install twine bumpversion wheel

## Bump the version

    bumpversion --allow-dirty \
      --current-version $(python version.py) \
      minor flask_staticdirs/__init__.py

## Build and verify the package

    rm -rf build dist
    python setup.py sdist bdist_wheel
    tar tzf dist/flask-staticdirs-*.tar.gz
    twine check dist/*

## Upload the package

First, upload to the test instance to verify all works as expected.

    twine upload --repository-url https://test.pypi.org/legacy/ dist/*

then, finally, updload to PyPi

    twine upload dist/*
