#!/bin/bash
if test $# -lt 1 ; then
   echo "Usage: $0 INPUT"
   exit 1
fi
if test ! -r $1 ; then
    echo Cannot test -r $1
    exit 1
fi
apertium -d . fin-eng-debug < $1 | egrep -o '@[^ .:,]*'  | sed -e 's/><.*/>/' -e 's/<\([^>]*\)>/<s n="\1"\/>/g' -e 's/@/    <e><p><l>/' -e 's:$:</l><r>XXX<s n="Y"/></r></p></e>:' | sort | uniq >> apertium-fin-eng.fin-eng.dix
apertium -d . fin-eng-debug < $1 | egrep -o '#[^ .:,]*' | fgrep '<n>' | sed -e 's/#//' -e 's/<.*//' | sort | uniq | sed -e 's/^.*$/\0%<n%>:\0 N ;/' >> apertium-fin-eng.eng.lexc
apertium -d . fin-eng-debug < $1 | egrep -o '#[^ .:,]*' | fgrep '<vblex>' | sed -e 's/#//' -e 's/<.*//' | sort | uniq | sed -e 's/^.*$/\0%<n%>:\0 V ;/' >> apertium-fin-eng.eng.lexc
