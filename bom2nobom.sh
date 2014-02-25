#!/bin/bash

# delete the BOM character a the begining file
# Not lunch on NoBOM file!!

dd if=$1 of=$1.noBOM ibs=3 skip=1
