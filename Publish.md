# Instructions for publishing updates to PyPi:

These instructions are derived from [this](https://realpython.com/pypi-publish-python-package/) article.

## Install Tools

    pip install twine bumpversion

## Bump the version

    bumpversion --current-version $(python version.py) minor setup.py flask_staticdirs/__init__.py

## Build and verify the package

    rm -rf build dist
    python setup.py sdist bdist_wheel
    tar tzf dist/realpython-reader-*.tar.gz
    twine check dist/*

## Upload the package

First, upload to the test instance to verify all works as expected.

    twine upload --repository-url https://test.pypi.org/legacy/ dist/*

then, finally, updload to PyPi

    twine upload dist/*
