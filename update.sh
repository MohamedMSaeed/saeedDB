!/usr/bin/bash

myTbl=$HOME/saeedDB/$db/$selectedTbl
echo "Enter the PK you want to update: "
read update
if cut -f1 -d: $myTbl | grep $update
then
   sed -i "/^$update/d" $myTbl
   shopt -s extglob
   tblDataType=""
   insertedType=""
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
   insertedRow[0]=$update
   
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
else echo "Not found"
fi


