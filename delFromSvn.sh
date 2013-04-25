#!/bin/bash

# delete from svn already removed file

svn st | grep ^! | cut -d ' ' -f 8 | xargs svn del
