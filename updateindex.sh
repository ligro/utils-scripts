#!/bin/bash

DIRS=.
if [ $# -gt 1 ]
then
    DIRS=$@
fi

for DIR in $DIRS
do
    cd $DIR 
    find -L . -regextype posix-extended -regex ".*\.(php|js)" | cscope -i- -b

    #ctags -R 2>/dev/null
    #if [ $? -ne 0 ]
    #then
    #	echo 'An error occured while processing ctags';
    #fi

    cd $OLDPWD

done
