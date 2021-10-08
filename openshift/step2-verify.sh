#!/usr/bin/env bash

curl -s 127.0.0.1:7071/metrics >/dev/null || exit 1

echo '"done"'
