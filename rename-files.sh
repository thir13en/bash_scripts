#!/usr/bin/env bash

strToReplace=""
replaceWith=""

for i in PREMIERE* 
do
    mv "$i" "`echo $i | sed 's/PREMIERE //'`"
done
