from flask import Flask, request

app = Flask(__name__)


mylogin = {"username": '1', "password": '1'}


@app.route('/login', methods=['POST'])
def login():
    print(request.json)
    if request.json["username"] == mylogin["username"] and request.json["password"] == mylogin["password"]:
        return {"status": "ok"}
    return {"status": "wrong"}


@app.route('/')
def hello_world():
    return {"hi": 1}


if __name__ == '__main__':
    app.run(debug=True)