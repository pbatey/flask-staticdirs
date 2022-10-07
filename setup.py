import pathlib
from setuptools import setup
from flask_staticdirs import __version__

# The directory containing this file
HERE = pathlib.Path(__file__).parent

# The text of the README file
README = (HERE / "README.md").read_text()

# This call to setup() does all the work
setup(
    name="flask-staticdirs",
    version=__version__,
    description="Creates a Flask blueprint to serve files and directories (with support for index files) from at static folder.",
    long_description=README,
    long_description_content_type="text/markdown",
    url="https://github.com/pbatey/flask-staticdirs",
    author="Phil Batey",
    author_email="pbatey+pypi@gmail.com",
    license="MIT",
    classifiers=[
        "License :: OSI Approved :: MIT License",
        "Programming Language :: Python :: 3",
        "Programming Language :: Python :: 3.9",
    ],
    packages=["flask_staticdirs"],
    include_package_data=True,
    install_requires=["flask>=2.1.0"],
    #entry_points={},
)
