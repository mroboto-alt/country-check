#!/bin/bash

ARG=$1

clear

echo
printf "Running traceroute will expose your IP.\nDo you want to run traceroute [y/n]? "
read PROMPT

clear

cd ../webchk

FILE=$ARG-tmpfile

touch $FILE

if [ $PROMPT = 'y' ];
    then
        echo 
        echo "Running traceroute..."
        echo 

        echo "TRACEROUTE to $ARG" >> $FILE

        traceroute $ARG >> $FILE 

        echo
        cat $FILE
        echo
    fi

echo "Press ENTER to continue"
read ENTER

echo
echo "Running whois..."
echo        

echo ' ' >> $FILE
whois $ARG | grep -E 'Registrant Name|Registrant Country|Registrant City|Registrant State|Admin Country|Admin City|Admin State|Tech Country|Tech City|Tech State|Name Server' >> $FILE

STATES="VU VUT TV TUV PM SPM"
for state in $STATES
    do 
        if grep -q $state $FILE; 
            then
                echo "WARNING: site could be based in $state"
            else
                echo "Nothing known to be accessed from $state"
        fi
    done

echo
echo 'NAME SERVER: '
NS=$(grep 'Name Server:' $FILE | cut -c 14- | tail -2)
echo $NS
echo

printf 'Do you want to execute dig [y/n]? '
read DIG_PROMPT

if [ $DIG_PROMPT = 'y' ];
    then
        RESULT=$(dig $NS MX)
        echo ' ' >> $FILE
        echo $RESULT >> $FILE
        dig $NS MX
    fi

echo
echo "Do you want to save the traceroute/whois/dig output [y/n]?"
read SAVE

case $SAVE in

    'y')
        echo
        echo "OK, output is saved"
        sleep 1.25
        clear
        ;;
    'n')
        rm $FILE
        echo
        echo "OK, data is deleted"
        sleep 1.25
        clear
        ;;
    *)
        echo
        echo "ERROR: invalid entry/default saved"
        sleep 1.25
        clear
        ;;

esac

cd -

    





