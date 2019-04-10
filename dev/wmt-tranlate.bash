#!/bin/bash
if test $# != 2 ; then
    echo Usage: $0 DIR TEXT
    exit 1
fi
sed -e 's/$/§/g' < $2 | apertium -d . $1 | tr -s '#@*§' '    ' |\
    sed -e 's:/[^,.:? -]*::' |\
    sed -e 's/<[^>]*>//g'
