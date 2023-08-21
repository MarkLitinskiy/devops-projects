#! /bin/bash

numb=$(find ${1} -type f 2>/dev/null | wc -l)

echo "Total number of files: $numb"