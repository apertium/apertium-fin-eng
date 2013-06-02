BEGIN {FS="\t";}
NF > 2 {
    printf("    <e><p><l>%s<s n=\"n\"></l><r>%s<s n=\"n\"></r></p></e>\n",
           $1, gensub(/[]#[]/, "", "g", $2));
}
