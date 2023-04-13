#!/bin/bash

SITE_ROOT=$(dirname $(realpath $0))

export TOKEN_FILE=$SITE_ROOT/tokens.txt
list="$SITE_ROOT/server.py"
python3 $list
