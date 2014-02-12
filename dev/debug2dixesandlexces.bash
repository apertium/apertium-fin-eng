#!/bin/bash

if test $# -lt 1 ; then
   echo "Usage: $0 INPUT"
   exit 1
fi
if test ! -r $1 ; then
    echo Cannot test -r $1
    exit 1
fi

# fin.lexc is already at languages/apertium-fin
#apertium -d . fin-eng-debug < $1 | egrep -o '\*[^ .:,]*' | sort | uniq | sed -e 's/^.*$/\0%<XXX%>:\0 # ;/' >> apertium-fin-eng.fin.lexc


echo '<!-- additions -->' >> apertium-fin-eng.fin-eng.dix
apertium -d . fin-eng-debug < $1 | egrep -o '@[^ .:,]*'  | sed -e 's/><.*/>/' -e 's/<\([^>]*\)>/<s n="\1"\/>/g' -e 's/@/    <e><p><l>/' -e 's:$:</l><r>XXX<s n="Y"/></r></p></e>:' | sort | uniq >> apertium-fin-eng.fin-eng.dix
echo '<!-- vim: set ft=xml: -->' >> apertium-fin-eng.fin-eng.dix

apertium -d . fin-eng-debug < $1 | egrep -o '#[^<]*<[^>]*>' > eng-misses.ape
echo '! Nouns' >> apertium-fin-eng.lexc
fgrep '<n>' < eng-misses.ape | sed -e 's/#//' -e 's/<.*//' | sort | uniq | sed -e 's/^.*$/\0%<n%>:\0 N ;/' >> apertium-fin-eng.eng.lexc
echo '! Verbs' >> apertium-fin-eng.lexc
fgrep '<vblex>' < eng-misses.ape | sed -e 's/#//' -e 's/<.*//' | sort | uniq | sed -e 's/^.*$/\0%<vblex%>:\0 V ;/' >> apertium-fin-eng.eng.lexc
echo '! Adjectives' >> apertium-fin-eng.lexc
fgrep '<adj>' < eng-misses.ape | sed -e 's/#//' -e 's/<.*//' | sort | uniq | sed -e 's/^.*$/\0%<adj%>:\0 A ;/' >> apertium-fin-eng.eng.lexc
echo '! Adverbs' >> apertium-fin-eng.lexc
fgrep '<adv>' < eng-misses.ape | sed -e 's/#//' -e 's/<.*//' | sort | uniq | sed -e 's/^.*$/\0%<adv%>:\0 # ;/' >> apertium-fin-eng.eng.lexc
echo '! Adps' >> apertium-fin-eng.lexc
egrep '<(pr|post)>' < eng-misses.ape | sed -e 's/#//' -e 's/<.*//' | sort | uniq | sed -e 's/^.*$/\0%<pr%>:\0 # ;/' >> apertium-fin-eng.eng.lexc
echo '! Prons' >> apertium-fin-eng.lexc
fgrep '<prn>' < eng-misses.ape | sed -e 's/#//' -e 's/<.*//' | sort | uniq | sed -e 's/^.*$/\0%<prn%>:\0 PRON ;/' >> apertium-fin-eng.eng.lexc
echo -n '! vi' >> apertium-fin-eng.lexc
echo 'm: set ft=xfst-lexc:' >> apertium-fin-eng.lexc

