#!/bin/sh -ex

REPO=ocaml/opam-repository
PR=$1

if [ "$PR" = "" ]; then
  echo Usage: $0 pr-number packages
  exit 1
fi

shift
PACKAGES=$*

if [ "$PACKAGES" = "" ]; then
  echo Usage: $0 pr-number packages
  exit 1
fi

HEADREF=`curl -s https://api.github.com/repos/$REPO/pulls/$PR | jq -r .head.ref`
REMOTEREPO=`curl -s https://api.github.com/repos/$REPO/pulls/$PR | jq -r .head.repo.full_name`
git branch -D $PR || true
git checkout -B $PR
dockerfile-gen -o build -b origin,master -b https://github.com/${REMOTEREPO}.git,$HEADREF -c 4.02.3 $PACKAGES
echo "# OPAM PR [$PR](https://github.com/ocaml/opam-repository/pull/$PR)\n\n" > build/header.md
(git add build && git commit -m 'sync' -a) || true
git checkout master
