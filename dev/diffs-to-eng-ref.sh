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

echo -e 'Multichar_Symbols\n\n%<n%>\n\n\nLEXICON Root\n\nNUMS ; \n' > /tmp/tagdict.lexc
cat $1/*.handtagged* | grep -v -e 'WRONG' -e 'ERROR' -e '##' | sed  's/\//\t/1'  | sed 's/\^//g' | cut -f1 -d'$' |\
    sed 's/ /% /g' | sed 's/</%</g' | sed 's/>/%>/g' | awk -F'\t' '{print $2":"$1}' |\
    sed 's/$/ # ;/g' | sort -u | grep -v '\*' | grep -v '"' |\
    grep -P '[a-zA-Z].*:[a-zA-Z].*' | sort -u >> /tmp/tagdict.lexc
echo -e 'LEXICON NUMS\n\n<[%0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9]+>  DIGITLEX ;\n\nLEXICON DIGITLEX\n\n%<num%>%<sg%>: # ; ' >> /tmp/tagdict.lexc 


hfst-lexc -v -d /tmp/tagdict.lexc |\
    hfst-invert |\
    hfst-fst2fst -f olw -o /tmp/tagdict.hfst
cat $1/*.handtagged* | cut -f2 -d'^' | cut -f1 -d'/' |\
    sort -f | uniq -c | sort -gr  | apertium-destxt |\
    hfst-proc -w /tmp/tagdict.hfst  | apertium-retxt  > /tmp/list.handtagged
cat $1/*.handtagged* | cut -f2 -d'^' | cut -f1 -d'/' |\
                   sort -f | uniq -c | sort -gr  | apertium-destxt |\
                   lt-proc -w eng-fin.automorf.bin |\
                   apertium-retxt  > /tmp/list.fineng
diff -Naur /tmp/list.handtagged /tmp/list.fineng > listdiffs
echo some better diffs in listdiffs
diffstat listdiffs
