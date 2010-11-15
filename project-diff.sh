#!/bin/bash

if [ "$DIFF_EDITOR" == "" ]; then
    DIFF_EDITOR="vi -d"
fi

usage () {
    echo "Usage: $0 (directory|project) file"
    exit 2
}

dir () {
    echo "Error: $1"
    exit 1
}

if [ $# -ne 2 ]; then
    usage
fi

if [ -d "$1" ]; then
    DIR=$1
elif [ -d "../$1" ]; then
    DIR="../$1"
else
    die "$1 (or ../$1) is not a directory"
fi

diff $2 $DIR/$2 > /dev/null

if [ $? -eq 0 ]
then
    echo 'No diff'
else
    echo "$EDITOR $2 $DIR/$2"
    $DIFF_EDITOR $2 $DIR/$2
fi
