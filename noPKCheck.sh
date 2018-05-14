#!/usr/bin/bash
. ./checkCase.sh $1
while [ "$insertedType" != "${dataArr[$i]}" ]
   do
       if [ $insertedType != "null" ]
       then
         echo "Invalid Data Type Please Enter $ba data that has type ${dataArr[$i]}"
         read insertedRow[$i]
         . ./checkCase.sh ${insertedRow[$i]}
       else 
         insertedRow[$i]="null"
         break
       fi
   done
