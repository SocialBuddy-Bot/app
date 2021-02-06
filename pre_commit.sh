#!/bin/sh
set -e
set -x

flutter analyze lib
flutter format --line-length 80 --set-exit-if-changed .

git diff --exit-code lib/
