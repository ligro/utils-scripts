#!/bin/bash

usage () {
    echo "Usage: $0 [directory|project] [-d]"
    exit 2
}

die () {
    echo "Error: $1"
    exit 1
}

if [ $# -gt 2 ] && [ $# -lt 0 ]; then
    usage
fi

USE_DIFF=0
DIR="$DEFAULT_PROJECT"
for PARAM in $@
do
    if [ "$PARAM" == "-d" ]
    then
        USE_DIFF=1
    else
        if [ -d "$PARAM" ]; then
            DIR=$PARAM
        elif [ -d "../$PARAM" ]; then
            DIR="../$PARAM"
        else
            die "$PARAM (or ../$PARAM) is not a directory"
        fi
    fi
done

if [ "$DIR" == "" ]; then
    die "DEFAULT_PROJECT not defined, project dir must be provided";
fi
DIFF=project-diff.sh

# modified file
for FILE in $(svn st | grep "^M"| cut -d ' ' -f 8)
do
    diff -b $FILE $DIR/$FILE > /dev/null
    RES=$?
    if [ $RES -ne 0 ]; then
        if [ $USE_DIFF -eq 1 ]; then
            $DIFF $DIR $FILE
        else
            echo "M $FILE"
        fi
    fi
done

# added file
for FILE in $(svn st | grep "^A"| cut -d ' ' -f 7)
do
    diff -b $FILE $DIR/$FILE > /dev/null
    RES=$?
    if [ $RES -ne 0 ]; then
        echo "A $FILE"
    fi
done

for FILE in $(svn st | grep "^R"| cut -d ' ' -f 7)
do
    diff -b $FILE $DIR/$FILE > /dev/null
    RES=$?
    if [ $RES -ne 0 ]; then
        echo "R $FILE"
    fi
done


# deleted file
for FILE in $(svn st | grep "^D"| cut -d ' ' -f 8)
do
    if [ -f $FILE ]; then
        echo "D $FILE"
    fi
done


