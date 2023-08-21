#! /bin/bash

numb_conf=$(finf ${1} -type f -name "*.conf" 2>/dev/null | wc -l)
numb_text=$(find ${1} -type f -name "*.txt" 2>/dev/null | wc -l)
numb_executable=$(find ${1} -type f -executable 2>/dev/null | wc -l)
numb_log=$(find ${1} -type f -name "*.log" 2>/dev/null | wc -l)
numb_archive=$(find ${1} -type f -name "*.tar" -name "*.zip" -name "*.rar" 2>/dev/null | wc -l)
numb_links=$(find ${1} -type l 2>/dev/null | wc -l)

echo "Number of:"
echo "Configuration files (with the .conf extension) = $numb_conf"
echo "Text files = $numb_text"
echo "Executable files = $numb_executable"
echo "Log files (with the extension .log) = $numb_log"
echo "Archive files = $numb_archive"
echo "Symbolic links = $numb_links"



