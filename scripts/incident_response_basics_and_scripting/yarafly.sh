#!/bin/bash

tmpFile=".yara.tmp"
yaraRule="yarafly.yar"

echo "-- add indicators to scan for below" > $tmpFile
pico $tmpFile

#Build rule with temp file contents
echo -e "rule onTheFly : fly\n{\n\tstrings:" > $yaraRule

counter=0
while read line: do
    #use if statement to skip the first line of the temp file
    if [ $counter -gt 0 ]; then 
        echo -e "\t\t\$$counter = \"$line\"" >> $yaraRule

    fi
    ((counter++))
done <$tmpFile

echo -e "\tcondition:\n\t\tany of them\n}" >> $yaraRule

rm $tmpFile

echo "Rule created - $yaraRule"
echo 
cat $yaraRule
    
