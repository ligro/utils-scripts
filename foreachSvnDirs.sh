#!/bin/bash

usage()
{
    echo "$0 [DIR] command"
    exit 1
}

DIR=.
if [ -d "$1" ]; then 
    DIR=$1
    shift;
fi

if [ ! -d $DIR ]; then
    echo "error: $DIR is not a valid directory"
    exit 1
fi

CMD=$@

main()
{
    for D in $(ls --color=none -1 $1);
    do
        if [ -d "$1/$D/.svn" ];
        then
           if [ "$CMD" ]; then 
                echo "## $1/$D";
                cd $1/$D
                $CMD;
                cd $OLDPWD
            else
                echo "$1/$D"
            fi
        elif [ -d "$1/$D" ];
        then
            main $1/$D
        fi
    done
}

main $DIR
