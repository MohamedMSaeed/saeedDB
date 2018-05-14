#!/usr/bin/bash
found="ture"
while [ $found="true" ]
do
    found="false"
   if [ -z ${insertedRow[0]} ]
   then 
   echo "NULL!! "
   found="null"
   else 
    if cut -f1 -d: $myTbl | grep ${insertedRow[0]}
    then 
        echo "It is found!! You cant duplicate PK! "
        found="true"
    else break
    fi
   fi
    
    if [ $found="true" ]
    then 
        echo "Please Enter ${baseArr[0]} data that has type ${dataArr[0]}"
        read insertedRow[0]
    elif [ $found="null" ]
    then 
        echo "Please Enter ${baseArr[0]} data that has type ${dataArr[0]}"
        read insertedRow[0]
        found="true"
    else break
    fi
done

. ./checkCase.sh $1
while [ "$insertedType" != "${dataArr[0]}" ]
   do
     echo "Invalid Data Type Please Enter ${baseArr[0]} data that has type ${dataArr[0]}"
     read insertedRow[0]
     . ./checkCase.sh ${insertedRow[0]}
   done

