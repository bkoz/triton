#/bin/bash

curl -X POST -H "Content-Type: application/json" -d @request-simple.json ${HOST}:8000/v2/models/simple/infer

