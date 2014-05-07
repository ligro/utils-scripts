#!/bin/bash

ST=`git st -s --untracked-files=no`
if [ "$ST" != "" ]; then
    echo "ERROR you have uncommited modifications"
    exit 1
fi

CUR_BRANCH=$(git symbolic-ref -q HEAD)
CUR_BRANCH=${CUR_BRANCH##refs/heads/}
CUR_BRANCH=${CUR_BRANCH:-HEAD}

# remove * from the list
BRANCHES=`git branch --no-color --list | tr '*' ' '`

for BRANCH in $BRANCHES
do
    echo "# $BRANCH"
    if [ "$BRANCH" != "*" ]; then
        git co $BRANCH
        if [ $# -gt 0 ]; then
            git $@
            if [ $? -ne 0 ]; then
                exit
            fi
        fi
    fi
done

git co $CUR_BRANCH
