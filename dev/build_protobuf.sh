#!/bin/bash

# mkdir -p ./proto
# protoc -I=../proto --python_out=./proto ../proto/*.proto
protoc --proto_path=. --python_out=python proto/*.proto
protoc --proto_path=. --cpp_out=build proto/*.proto
# touch ./proto/__init__.py
