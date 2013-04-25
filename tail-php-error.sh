#!/bin/bash

tail -f $@  | perl -pe 's/( PHP|Error|Warning|Notice)/\e[1;31m$&\e[0m/gi'
