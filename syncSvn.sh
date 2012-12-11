#!/bin/bash

# synchronise my svn

REV=`svn info | grep Revision | cut -d ' ' -f 2`
REPO_ROOT=`svn info | grep 'Repository Root' | cut -d ' ' -f 3`
BASE_DIR=`svn info | grep URL | cut -d ' ' -f 2 | sed "s@${REPO_ROOT}@@g"`

TMP_FILE=`tempfile`

# retrieve commited files not already updated
svn log -vr$REV:HEAD | grep ${BASE_DIR} | sed "s@${BASE_DIR}/@@g" | cut -d ' ' -f 5 > ${TMP_FILE}

# retrieve commited files not already updated
for FILE in $(svn st | cut -d ' ' -f 7)
do
	grep ${FILE} ${TMP_FILE}
done

