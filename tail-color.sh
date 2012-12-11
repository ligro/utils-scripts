#!/bin/bash

tail -f $@  | perl -pe 's/(\[Error\]|error:)/\e[1;31m$&\e[0m/g'
