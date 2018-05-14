#!/usr/bin/bash
# Some var
typeset -i i=0
typeset -i extNum
##################################

# To create saeedDB container
saeedDBCheck=`ls $HOME | grep saeedDB`
if [ -z $saeedDBCheck  ] 
then
mkdir $HOME/saeedDB
fi
####################################

# To Join Array using : as a delimiter
function joinBy {
   local d=":" ;echo -n "$1" ; shift ; printf "%s" "${@/#/$d}";
}
####################################

# To Deal With Tables
function showTables() { ls $HOME/saeedDB/$db; }
####################################

# To get all tables in the DB
function tableArray() { 
   i=0
   for ttbl in `ls $HOME/saeedDB/$db`
   do
      TBLarr[i]=$ttbl
      i=$i+1
   done
   extNum=${#TBLarr[*]}+1
}
####################################

# To displayRow
function displayRow() {
    echo "Enter the word you want to search: "
    read search
    tail -n +2 $HOME/saeedDB/$db/$selectedTbl |head -1 | tr ':' '\t'
    sed -n "/$search/p" $HOME/saeedDB/$db/$selectedTbl | tr ':' '\t'
}
####################################

# To deleteRow
function deleteRow() {
    myTbl=$HOME/saeedDB/$db/$selectedTbl
    echo "Enter the PK you want to delete: "
    read delete
    if cut -f1 -d: $myTbl | grep $delete 
    then
        sed -i "/^$delete/d" $myTbl
    else echo "Not found"
    fi
}

####################################

# To creat table with base raw and data type
function creatTable() { 
   echo "Enter Table Name";read tbl;
   echo 
   TBLcheck=`ls $HOME/saeedDB/$db | grep ^$tbl$`
   if [ -z $TBLcheck ]
     then 
     choice="y"
     i=0
     while [ $choice = "y" ]
     do
        if [ $i -eq 0 ]
        then 
           echo "Enter the colmn that will be the primary key"
        else
           echo "Enter the colmn-name"
        fi
        read rowArr[i]
        echo "choose the colmn data-type. Type 's' for string or 'n' for number" 
        read dataArr[i]
        while [ ${dataArr[i]} != "s" ]
        do 
           if [ ${dataArr[i]} != "n" ]
           then
              echo "please enter a valid choice. Type 's' for string or 'n' for number"
              read dataArr[i]
           else
              break
           fi
        done
        i=$i+1
        echo "Do you want to add another colmn? (y/n)"
        read choice
     done
     echo ${dataArr[*]} | tr ' ' ':' > $HOME/saeedDB/$db/$tbl
     echo ${rowArr[*]} | tr ' ' ':' >> $HOME/saeedDB/$db/$tbl
     echo "Table $tbl has been created"
   else 
     echo "This table is already there !!"
   fi
}
####################################
# To Do things inside table :D
function insideTable() { 
   PS3="$db: $selectedTbl-> "
   select ch in "Display All" "Display Row" "Insert Row" "Update" "Delete Row" "exit" 
   do
   case $REPLY in
   1) . ./display.awk $HOME/saeedDB/$db/$selectedTbl;;
   2)displayRow;;
   3). ./insertRow.sh;;
   4). ./update.sh;;
   5)deleteRow;;
   6)PS3="$db-> "
     break;;
   *)echo "Invalid Choice";;
   esac
   done
}
####################################

function tableMenu(){
   select choice in "Show Tables" "Create Table" "Select Table" "Delete Table" "Exit Database"
   do
   case $REPLY in
   1) showTables;;
   2) creatTable;;
   3) tableArray
      select tblName in ${TBLarr[*]} "exit"
      do
        if [ $REPLY -eq $extNum ]
        then  break
        elif [ $REPLY -le 0 ]
        then echo cant use negative numbers or zero!!
        elif [ $REPLY -le ${#TBLarr[*]} ]
        then 
          selectedTbl=$tblName
          insideTable
        else
          echo not found!
        fi 
      done
      ;;
   4) tableArray
      select tblName in ${TBLarr[*]} "exit"
      do
        if [ $REPLY -eq $extNum ]
           then  break
        elif [ $REPLY -le 0 ]
           then echo cant use negative numbers or zero!!
        elif [ $REPLY -le ${#TBLarr[*]} ]
        then 
           rm $HOME/saeedDB/$db/$tblName
           TBLarr=("${TBLarr[@]:$REPLY}") #to remove it from te array
           break
        else
           echo not found!
        fi 
      done
      ;;
   5) PS3="saeedDB-> " 
      break ;;
   *) echo "Invalid Choice";;
   esac
   done
}
####################################

# 
####################################
PS3="saeedDB-> "
echo "What do you want to do?"
select choice in "Create Database" "Show Databases" "Use Database" "Drop Database" "Exit"
do
case $REPLY in
1) echo "Enter DB name";read db;
   DBcheck=`ls $HOME/saeedDB | grep ^$db$`
   if [ -z $DBcheck ]
     then 
     mkdir $HOME/saeedDB/$db;
     echo "Datebase $db has been created"
   else 
     echo "This database is already there !!"
   fi
   ;;
2) for dir in `ls $HOME/saeedDB`
   do
     echo $dir
   done
   ;;
3) echo "Enter Database Name: "
   read db
   DBcheck=`ls $HOME/saeedDB | grep ^$db$`
   if [ -z $DBcheck ]
   then
     echo "Database Not Found!!"
   else
     PS3="$db-> "
     currentDB=$db
     #cd $HOME/saeedDB/$db
     tableMenu
   fi
   ;;
4) echo "Enter Database Name: "
   read db
   DBcheck=`ls $HOME/saeedDB | grep ^db$`
   if [ -d $DBcheck ]
   then
     rm -r $HOME/saeedDB/$db
     echo "Database hase been removed"
   else
     echo "Database Not Found!!"
   fi
   ;;
5) exit;;
*) echo invalid choice ;;
esac
done
