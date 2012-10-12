#!/bin/bash

tail -f $@  | perl -pe 's/(error|warning|notice)/\e[1;31m$&\e[0m/gi'
