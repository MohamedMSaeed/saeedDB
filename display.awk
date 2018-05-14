awk -F: '{line="";i=1;while(i<=NF){line=line$i"\t";i++}; print line}' $1

