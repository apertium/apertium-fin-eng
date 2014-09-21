if [[ $1 = "eng-fin" ]]; then
    date --iso=seconds
    bash inconsistency.sh $1 > /tmp/$1.testvoc
    bash inconsistency-summary.sh /tmp/$1.testvoc $1
    echo ""
else
    echo "Usage: $0 eng-fin"
fi

