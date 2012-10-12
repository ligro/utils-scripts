#!/bin/bash

if [ $# -lt 1 ] || [ $# -gt 2 ]; then
    echo "usage : $0 from_rev [to_rev]"
    echo "      give the diff revision by revision from from_rev to to_rev"
    echo "      if to_rev is not provided HEAD will be used"
    echo "      from_rev and to_rev can be any rev format see svn help log"
    exit
fi

FROM=$1
if [ $# -eq 2 ]; then
    TO=$2
else
    TO='HEAD'
fi

echo "svn log -qr$FROM:$TO | grep -Eo '^r([0-9])+ ' | tr 'r' ' '"
REVS=`svn log -qr$FROM:$TO | grep -Eo '^r([0-9])+ ' | tr 'r' ' '`

echo found ${#REVS}

for REV in ${REVS[@]}
do
    svn log -c $REV
    svndiff -c $REV
done | less -r
