awk -F: '{line="";i=1;while(i<=NF){line=line"\t"$i;i++}; print line}' $HOME/saeedDB/$db/$selectedTbl

