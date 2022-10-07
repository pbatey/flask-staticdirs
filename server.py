import os
import sys
sys.path.insert(0, os.path.dirname(__file__)) # allow modules in subdirectories to be imported

from flask import Flask
from flask_staticdirs import staticdirs

app = Flask(__name__)
app.register_blueprint(staticdirs("public"), url_prefix="/")

if __name__ == '__main__':
    app.run(debug=True)
