#!/bin/sh -ex

PR=$1

if [ "$PR" = "" ]; then
  echo Usage: $0 pr-number
  exit 1
fi

git checkout $PR
cd build
make clean
make -j 24 
cd ..
mv build/README.md .
(git add build README.md && git commit -m 'sync' -a && git push origin $PR --force) || true
git checkout master
