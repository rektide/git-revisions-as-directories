#!/bin/sh


echo "output directory $1"
echo $1
mkdir -p "$1/.uppers"

git branch

# list every revision in format
# UNIXTIMESTAMP-SHA1HASHOFCOMMIT
for l in `git log --pretty=format:"%at-%H"`; do
    stamp=`echo $l | sed -n 's/\-\([^\-]*\)$//p'`
    sha=`echo $l | sed -n 's/^\([^\-]*\)\-//p'`
    mkdir -p "$1/$stamp" "$1/.uppers/$stamp"
    mount -t overlayfs -o lowerdir=$(pwd) upperdir="$1/.uppers/$stamp" overlayfs "$1/$stamp"
    cd "$1/$stamp"
    git checkout $sha
done
