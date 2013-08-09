#!/bin/bash

git st | grep modified | cut -d : -f2 | xargs -n 1 php -l
