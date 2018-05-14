#!/usr/bin/bash
shopt -s extglob
case $1 in
+([0-9]) ) insertedType="n" ;;
+([[:upper:]]) ) insertedType="s" ;;
+([a-z]) ) insertedType="s" ;;
+([a-zA-Z0-9]) ) insertedType="s" ;;
*) insertedType="null" ;;
esac


