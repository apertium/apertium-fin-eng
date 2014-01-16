#!/bin/bash

if test $# -lt 2 ; then
    echo "Usage: $0 FIWN-TRANSL.TSV APERTIUM-FIN-ENG.FIN-ENG.DIX"
    exit 1
fi

cut -f 4,2 < $1 |\
    gawk -F "\t" '{printf("    <e><p><l>%s<s n="n"/></l><r>%s<s n="n"/></r></p></e>\n", $1, $2);}' >> $2

