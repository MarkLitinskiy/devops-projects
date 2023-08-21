#! /bin/bash

str=$(find $1 -type d 2>/dev/null | wc -l)
echo "Total number of folders (including all nested ones) = $str"