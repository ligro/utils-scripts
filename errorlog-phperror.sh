#!/bin/bash

tail -f $@ /opt/local/var/log/lighttpd/error.log | grep -i --color 'error'
