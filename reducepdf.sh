#!/bin/bash

if [ $# -ne 1 ] && [ $# -ne 2 ]; then
	echo "usage: $0 file.pdf [file-reduced.pdf]"
	exit 1
fi

FILENAME=${1/.pdf/}

if [ $# -eq 2 ]; then
	OUTPUT=${2/.pdf/}
else 
	OUTPUT=$FILENAME-reduced
fi

pdf2ps ${FILENAME}.pdf ${FILENAME}.ps
ps2pdf ${FILENAME}.ps ${OUTPUT}.pdf
rm  ${FILENAME}.ps 
