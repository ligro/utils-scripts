#!/bin/bash

# concat 2 files (line by line)

exec 10<$1
exec 11<$2

while read LINE1 <&10
do
	read LINE2 <&11
	echo $LINE1$LINE2
done

exec 10>&-
exec 11>&-

