#!/usr/bin/bash

# To Insert Row
#function insertRow() {
   shopt -s extglob
   tblDataType=""
   insertedType=""
   myTbl=$HOME/saeedDB/$db/$selectedTbl
   unset dataArr
   unset baseArr
   i=0
   for dt in `head -1 $myTbl | tr ':' ' '`
   do
      dataArr[i]=$dt
      i=$i+1
   done
   i=0
   for dt in `tail -n +2 $myTbl | head -1 | tr ':' ' '`
   do
      baseArr[i]=$dt
      i=$i+1
   done

   # To insert PK
   echo "Please Enter ${baseArr[0]} data that has type ${dataArr[0]}"
   read insertedRow[0]
   . ./pkCheck.sh ${insertedRow[0]}
   
   # To insert not PK fields
   i=1
   for ba in ${baseArr[@]:1}
   do
       echo "Please Enter ${baseArr[$i]} data that has type ${dataArr[$i]}"
       read insertedRow[$i]
       . ./noPKCheck.sh ${insertedRow[$i]}
       i=$i+1
   done
   echo ${insertedRow[*]} | tr ' ' ':' >> $myTbl
   
#}
