#!/bin/bash
if test $# -lt 1 ; then
    echo "Usage: $0 [PATH_TO_APERTIUM_ENG_TEXTS]"
    exit 1
fi

date --iso=s > analdiffs
for f in  $1/*.raw.txt ; do
    echo Processing $f
    tr ' ' '\n' < $f | apertium -d . eng-fin-morph > ${f%.raw.txt}.mine
    diff -u ${f%.raw.txt}.tagged.txt ${f%.raw.txt}.mine >> analdiffs
done
echo Original results are in analdiffs
diffstat analdiffs
