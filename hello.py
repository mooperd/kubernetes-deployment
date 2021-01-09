import os
from flask import Flask
app = Flask(__name__)

@app.route("/")
def hello():
    if 'THIS_SERVICE' in os.environ:
        return_string = "Hello World. This is service <b>{0}</b> built from branch <b>{1}</b>"\
        .format(os.environ['THIS_SERVICE'], os.environ['BRANCH'])
    else:
        return_string = "Hello World" 
    return return_string 

@app.route("/healthz")
def healthz():
    return "OK"

if __name__ == '__main__':
    app.debug=True
    app.run(host='0.0.0.0', port='8080')
