#!/bin/bash
TMPDIR=/tmp

DIR=$1

SED=sed

if [[ $DIR = "eng-fin" ]]; then
    # ] breaks tuff
    lt-expand ../apertium-fin-eng.eng.dix |\
        fgrep -v 'REGEX' |\
        fgrep -v ':<:' |\
        fgrep -v '<gen>' |\
        egrep -v '[]\\[]' |\
        $SED -e 's/:>:/	/g' -e 's/:/	/g' |\
        cut -f2 |\
        $SED -e 's/^/^/' -e 's/$/$ ^.<sent>$/g' |\
        apertium-pretransfer |\
        lt-proc -b ../$1.autobil.bin |\
        fgrep -v '/@' |\
        cut -f1 -d'/' |\
        $SED 's/$/$ ^.<sent>$/g' |\
        tee $TMPDIR/$DIR.tmp_testvoc1.txt |\
        apertium-pretransfer |\
        lt-proc -b ../$1.autobil.bin |\
        tee $TMPDIR/$DIR.tmp_testvoc2.txt |\
        apertium-transfer -b ../apertium-fin-eng.eng-fin.t1x ../eng-fin.t1x.bin |\
        apertium-interchunk ../apertium-fin-eng.eng-fin.t2x ../eng-fin.t2x.bin |\
        apertium-postchunk ../apertium-fin-eng.eng-fin.t3x ../eng-fin.t3x.bin |\
        hfst-proc -g ../$1.autogen.hfst > $TMPDIR/$DIR.tmp_testvoc4.txt
    paste  $TMPDIR/$DIR.tmp_testvoc1.txt \
            $TMPDIR/$DIR.tmp_testvoc2.txt \
            $TMPDIR/$DIR.tmp_testvoc3.txt \
            $TMPDIR/$DIR.tmp_testvoc4.txt |\
        $SED 's/\^.<sent>\$//g' 
elif [[ $DIR = "fin-eng" ]] ; then
    hfst-fst2strings 

else

    echo "bash inconsistency.sh <direction>";
fi
