#!/bin/bash

if [ "$DIFF_EDITOR" == "" ]; then
    DIFF_EDITOR="vi -d"
    echo "DIFF_EDITOR is not defined, use the default value: $DIFF_EDITOR"
fi

usage () {
    echo "Usage: $0 [directory|project] file"
    exit 2
}

die () {
    echo "Error: $1"
    exit 1
}

if [ $# -gt 2 ] || [ $# -lt 1 ]; then
    usage
fi

if [ $# -eq 1 ]; then
    if [ "$DEFAULT_PROJECT" == "" ]; then
        die "DEFAULT_PROJECT not defined, project dir must be provided";
    fi
    DIR="$DEFAULT_PROJECT"
elif [ -d "$1" ]; then
    DIR=$1
elif [ -d "../$1" ]; then
    DIR="../$1"
else
    die "$1 (or ../$1) is not a directory"
fi

if [ $# -eq 1 ]; then
    FILE=$1
else
    FILE=$2
fi
diff $FILE $DIR/$FILE > /dev/null

if [ $? -eq 0 ]
then
    echo 'No diff'
else
    echo "$DIFF_EDITOR $FILE $DIR/$FILE"
    $DIFF_EDITOR $FILE $DIR/$FILE
fi
