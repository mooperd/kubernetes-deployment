import os
import math
from flask import Flask
from flask import jsonify
app = Flask(__name__)

@app.route("/")
def hello():
    if 'THIS_SERVICE' in os.environ:
        return_dict = {}
        return_dict["service"] = os.environ['THIS_SERVICE']
        return_dict["git branch"] = os.environ['BRANCH']
        math_dict = {}
        for i in range(2):
            math_dict[i] = math.sqrt(i)
        return_dict["math"] = math_dict
    else:
        return_dict = {"message": "Hello World"}
    return jsonify(return_dict)

@app.route("/healthz")
def healthz():
    return "OK"

if __name__ == '__main__':
    app.debug=True
    app.run(host='0.0.0.0', port='8080')
