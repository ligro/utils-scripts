#!/bin/bash

# grep a workspace

if [ $# -lt 2 ]
then
		echo "usage: $0 regex project [file types]"
		echo "	project must be an existing directory"
		echo "	file types is valid file extension by default it take php"
		exit 1
fi

if [ ! -d $2 ]
then
		echo "$2: no such directory"
fi

#EXTS[0]="php"
CPT=0;

if [ $# -gt 2 ]
then
	for EXT in $@
	do
		if [ $CPT -gt 1 ]
		then
			EXTS[$CPT]=$EXT
		fi
		(( CPT=$CPT + 1 ))
	done
fi

if [ $CPT -eq 0 ]
then
	EXTS[0]="php"
fi

for EXT in ${EXTS[@]}
do
		echo "==== $EXT ===="
		echo 'find '$2' -name "*.'$EXT'" -exec grep -n '$1' {} + | grep -v svn'
		find $2 -name "*.$EXT" -exec grep --color -n "${1}" {} + | grep -v svn
done

