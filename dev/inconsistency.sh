#!/bin/bash
TMPDIR=/tmp

DIR=$1
REF=../../

SED=sed

if [[ $DIR = "eng-fin" ]]; then
    # ] breaks tuff
    lt-expand "${REF}"/apertium-eng_feil/apertium-eng.eng.dix |\
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
        hfst-proc -g ../$1.autogen.hfst > $TMPDIR/$DIR.tmp_testvoc3.txt
    paste  $TMPDIR/$DIR.tmp_testvoc1.txt \
            $TMPDIR/$DIR.tmp_testvoc2.txt \
            $TMPDIR/$DIR.tmp_testvoc3.txt |\
        $SED 's/\^.<sent>\$//g' 
elif [[ $DIR = "fin-eng" ]] ; then
    hfst-fst2strings "${REF}"/apertium-fin/fin.automorf.hfst |\
        sort |\
        sed 's/:/%/g' |\
        cut -f1 -d'%' |\
        sed 's/^/^/g' |\
        sed 's/$/$ ^.<sent>$/g' |\
        tee $TMPDIR/tmp_testvoc1.txt |\
        apertium-pretransfer |\
        apertium-transfer ../apertium-${DIR}.${DIR}.t1x  ../${DIR}.t1x.bin  ../${DIR}.autobil.bin |\
        apertium-transfer -n ../apertium-${DIR}.${DIR}.t2x  ../${DIR}.t2x.bin | tee $TMPDIR/tmp_testvoc2.txt |\
        hfst-proc -d ../${DIR}.autogen.hfst > $TMPDIR/tmp_testvoc3.txt
    paste -d _ $TMPDIR/tmp_testvoc1.txt $TMPDIR/tmp_testvoc2.txt $TMPDIR/tmp_testvoc3.txt |\
        sed 's/\^.<sent>\$//g' |\
        sed 's/_/   --------->  /g'

else

    echo "bash inconsistency.sh <direction>";
fi
