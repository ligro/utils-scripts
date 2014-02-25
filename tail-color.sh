#!/bin/bash

tail -f $@ | perl -pe 's/(\[error\]|error:)/\e[1;31m$&\e[0m/g' | sed 'N;N;s/\\n/\n/g'
