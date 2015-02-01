#!/bin/bash

SERVER_NAME=`uname -a|awk '{print $2}'`

# sample every five minutes (300 seconds) . . . .
SAMPLE_TIME=5
OUT_FILE=/var/tmp/vmstat.out


while true
do
    vmstat ${SAMPLE_TIME} 2 > /tmp/msg$$

# run vmstat and direct the output to a file
cat /tmp/msg$$|sed 1,3d | awk  '{ printf("%s %s %s %s %s %s %s %s\n", $1, $2, $4, $8, $9, $13, $14, $15) }' | while read RUNQUE IOQUE FREEMEM PAGE_IN PAGE_OUT USER_CPU SYSTEM_CPU IDLE_CPU
    do
        echo  "$(date), $SAMPLE_TIME, '$SERVER_NAME', $RUNQUE, $IOQUE, $FREEMEM, $PAGE_IN, $PAGE_OUT, $USER_CPU, $SYSTEM_CPU, $IDLE_CPU"
                                                     
    done
done

rm /tmp/msg$$
