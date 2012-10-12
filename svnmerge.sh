#!/bin/bash

# automatic merging

#set -x

usage()
{
    if [ $# -eq 1 ]
    then
        echo "Error: $1"
        echo ""
    fi
    echo "`basename $0` branch_directory trunk"
    echo "  Simple tool to automaticaly merge a unmerged modification of a branch"
    echo "   or a trunk in another."
    echo "  Do not use it to reintegrate a branch into the trunk !!"
    if [ $# -eq 1 ]
    then
        exit 1
    fi
}

error_exit()
{
    echo "Error: $1"
    shift
    debug $@
    exit 1
}

debug()
{
    IFS=$'\n'
    for LINE in $@
    do
        echo "> $LINE"
    done
}

[ $# -ne 2 ] && usage "parameters are missing"

BRANCH=$1
TRUNK=$2

[ ! -d "$BRANCH" ] && usage "$BRANCH is not a valid directory"

# move into the branch
cd $BRANCH
[ $? -ne 0 ] && error_exit "cd $BRANCH"

# TODO test svn st empty

# update local repository
debug "svn update $BRANCH"
svn update
[ $? -ne 0 ] && error_exit "svn merge $TRUNK"

# test if the merge is possible
IFS=$'\n'
MERGE_MSG=`svn merge --dry-run $TRUNK`
[ $? -ne 0 ] && error_exit "svn merge --dry-run $TRUNK"
debug "svn merge --dry-run $TRUNK" $'\n' "$MERGE_MSG"

if [ ! "$MERGE_MSG" ]
then
    echo "Nothing to merge !"
    exit 0
fi

# Is there some conflicts ?
CONFLICT=`echo "$MERGE_MSG" | grep "conflict" | wc -l`
debug "$CONFLICT conflicts founds"
[ "$CONFLICT" -ne 0 ] && error_exit "There is conflict, you must handle it manually:" $'\n' "$MERGE_MSG"

COMMIT_MSG=`echo $MERGE_MSG | grep -Eo "Merging[^\n]*r[0-9]+"`

# launch the merge
debug "svn merge $TRUNK"
svn merge $TRUNK
if [ $? -ne 0 ] 
then
    debug "svn revert . --depth infinity"
    svn revert . --depth infinity
    error_exit "svn merge $TRUNK"
fi

# commit the merge
debug "svn commit -m '$COMMIT_MSG'"
svn commit -m "$COMMIT_MSG"
[ $? -ne 0 ] && error_exit "svn commit -m '$COMMIT_MSG'"

cd $OLDPWD
