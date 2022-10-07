#!/bin/sh
set -e
set -o pipefail

# default flask port (5000) now used by AirPlay
PORT=${1:-5001}

if [ ${PORT::1} == '-' -o $# -gt 1 ] || ! echo ${PORT} | egrep -q '^[0-9]+$'; then
  echo "./test.sh [PORT]" >&2
  exit 1
fi

venv() {
  if [ ! -d .venv ]; then
    python3 -m venv .venv
    source .venv/bin/activate 
    pip3 install -r requirements
  else
    source .venv/bin/activate 
  fi
}

portOpen() {
  nc -z $1 $2 &>/dev/null
}
waitForPort() {
  host=$1
  port=$2
  while ! portOpen $host $port; do
    sleep 0.1
  done
}

pid=
serve() {
  echo "Starting server at http://localhost:$PORT"
  FLASK_APP=server.py \
  FLASK_RUN_PORT=$PORT \
  flask run &>/dev/null &
  pid=$!
  waitForPort localhost $PORT
}

onexit() {
  if [ ! -z "$pid" ]; then
    kill $pid;
    echo "Stopped server."
  fi
}
trap onexit EXIT

# ---
venv
if portOpen localhost $PORT; then
  echo "Port $PORT already in use." >&2
  exit 1
else
  serve
fi

# ---
curlHeadTest() {
  path=$1
  expect=$2
  curl --head --silent http://localhost:$PORT$path | grep -q "$expect"
}

GREEN_CHECK="\033[0;32m✓\033[0;m"
RED_CROSS="\033[0;31m✗\033[0;m"

cat << EOF |
,^HTTP.* 200, it should return index.html for an empty path
/,^HTTP.* 200, it should return index.html for /
/..,^HTTP.* 200, it should return index.html for /..
/index.html,^HTTP.* 200, it should return index.html for /index.html
/not-fond.html,^HTTP.* 404, it should return 404 for /not-found.html
/../LICENCE,^HTTP.* 404, it should return 404 for /../LICENCE
EOF
while IFS=, read path expect msg; do
  if curlHeadTest "$path" "$expect"; then
    echo $GREEN_CHECK $msg
  else
    echo $RED_CROSS $msg
    exit_code=1
  fi
done

if [ -z $exit_code ]; then
  echo "SUCCESS! 🥳"
else
  echo "FAILED! 🤬"
fi
exit $exit_code