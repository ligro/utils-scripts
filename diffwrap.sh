#!/bin/sh

# alias svndiff='svn di --diff-cmd=diffwrap.sh'

# Subversion provides the paths we need as the sixth and seventh
# parameters.
LEFT=${6}
RIGHT=${7}

# Call the diff command (change the following line to make sense for
# your merge program).
if [ "$DIFF" ]
then
    $DIFF $LEFT $RIGHT
else
    mvim -df +'set syntax=php' $LEFT $RIGHT
fi

# Return an errorcode of 0 if no differences were detected, 1 if some were.
# Any other errorcode will be treated as fatal.
