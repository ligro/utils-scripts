#!/bin/bash

# delete from svn already removed file

svn st | grep ^! | cut -d ' ' -f 7 | xargs svn del
