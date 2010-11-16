#!/bin/bash

DIR="$HOME/Projects/trunk"

usage () {
    echo "Usage: $0 (directory|project)"
    exit 2
}

die () {
    echo "Error: $1"
    exit 1
}

if [ $# -ne 1 ]; then
    usage
fi

if [ -d "$1" ]; then
    DIR=$1
elif [ -d "../$1" ]; then
    DIR="../$1"
else
    die "$1 (or ../$1) is not a directory"
fi

# modified file
for FILE in $(svn st | grep "^M"| cut -d ' ' -f 8)
do
    diff $FILE $DIR/$FILE > /dev/null
    RES=$?
    if [ $RES -ne 0 ]; then
        echo "M $FILE"
    fi
done

# added file
for FILE in $(svn st | grep "^A"| cut -d ' ' -f 7)
do
    diff $FILE $DIR/$FILE > /dev/null
    RES=$?
    if [ $RES -ne 0 ]; then
        echo "A $FILE"
    fi
done

# deleted file
for FILE in $(svn st | grep "^D"| cut -d ' ' -f 8)
do
    if [ -f $FILE ]; then
        echo "D $FILE"
    fi
done


