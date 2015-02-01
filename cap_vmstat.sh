#!/bin/bash 


# Capture the output of vmstat to a file.  This parses out only the fields in 
# in which we are interested.
# The order and number of the fields can vary between operating systems.  This format
# works for Ubunut 14.4 and CentOS 6.x.
#

HEADER="date, sample_secs, server, run_queue, io_queue, free_memory, pages_in, pages_out, user_cpu, sys_cpu, idle_cpu"
SERVER_NAME=`uname -a|awk '{print $2}'`
SAMPLE_SECS=5
OUT_FILE=~/vmstat.$(date +'%Y%m%d_%H:%M:%S')

echo $HEADER > $OUT_FILE

while true
do
    vmstat ${SAMPLE_SECS} 2 > /tmp/msg$$

# run vmstat and direct the output to a file
cat /tmp/msg$$|sed 1,3d | awk  '{ printf("%s %s %s %s %s %s %s %s\n", $1, $2, $4, $7, $8, $13, $14, $15) }' | while read RUNQUE IOQUE FREEMEM PAGE_IN PAGE_OUT USER_CPU SYSTEM_CPU IDLE_CPU
    do
        echo  "$(date +'%Y-%m-%d %H:%M:%S'), $SAMPLE_SECS, '$SERVER_NAME', $RUNQUE, $IOQUE, $FREEMEM, $PAGE_IN, $PAGE_OUT, $USER_CPU, $SYSTEM_CPU, $IDLE_CPU" >> $OUT_FILE
                                                     
    done
done

rm /tmp/msg$$
