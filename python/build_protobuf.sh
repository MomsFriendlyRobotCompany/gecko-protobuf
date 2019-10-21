#!/bin/bash

mkdir -p ./proto
protoc -I=../proto --python_out=./proto ../proto/*.proto
touch ./proto/__init__.py
