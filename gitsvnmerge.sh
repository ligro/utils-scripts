#!/bin/bash

usage () {
    echo "Usage: $0 rev [rev ...]"
    exit 2
}

die () {
    echo "Error: $1"
    exit 1
}

if [ $# -eq 0 ]; then
    usage
fi


for REV in $@
do
    svnid=$(echo "$REV" | tr -d r)
    gitid=$(git --no-pager log --all --format="%H" --grep "@$svnid" | tail -n 1)

    if [ -z "$gitid" ]
    then
        echo "Changeset $svnid not found in git repository"
        continue
    fi

    frombranch=$(git --no-pager log -1 --format="%b" "$gitid" | grep -Eo "[^/]+@" | tr -d '@')
    tobranch=$(git symbolic-ref HEAD | grep -Eo "[^/]+$")

    mergefile=`git rev-parse --git-dir`/MERGE_MSG
    if [ -e "$mergefile" ]
    then
        oldmessage=$(cat $mergefile)
        oldticket=$(grep -Eo '#[0-9]+' $mergefile | head -n 1)
    else
        oldmessage=""
        oldticket=""
    fi

    echo "Merging svn:$svnid - git:$gitid"
    echo "$frombranch -> $tobranch"
    git cherry-pick -n "$gitid"

    if ! [ -e "$mergefile" ]
    then
        echo "Nothing to do"
        continue
    fi

    newmessage=$(cat $mergefile)
    newticket=$(grep -Eo '#[0-9]+' $mergefile | head -n 1)

    if [ -n "$oldticket" ] && [ "$newticket" != "$oldticket" ]
    then
        echo "WARNING: not the same ticket!"
    fi

    if ! (echo "$oldmessage" | grep -q "merge_$tobranch")
    then
        newmessage="($newticket) merge_$tobranch"
    else
        newmessage=$oldmessage
    fi

    newmessage="$newmessage r$svnid"

    echo $newmessage >| $mergefile
    echo $newmessage
done
