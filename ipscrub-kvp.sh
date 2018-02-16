#!/bin/bash

#another IP Sanitizer by Roberto Seldner

#Syntax: ipscrub-kvp.sh /path/sourcefile
#Output will be in the sourcefile's directory

#The purpose of this script is to replace IPv4 addresses (and subnets) in a file, such as a syslog, with a random, unique, identifier.  This sanitizes a log while preserving some meaning/context.
#A recipient of such a file can then differentiate between endpoints in a log file, without disclosing their actual addresses.
#The script will create a randomized key-value pair from the IP addresses, then replace each IP with its corresponding key.  
#The order is randomized using sort -R; where the output order is determined by each line's hash value, derived from a randomly chosen hash function (where the seed = /dev/random) each time sort is invoked.  This method works for our purpose since each line is unique.
#To use perl's shuffle instead, uncomment the cat ... perl line, and comment the sort -R
#This description is longer than the script itself :]

###### check syntax ######
if [ "$1" = "" ]; then
echo -e "\e[33mYou MUST specify the target filename"
echo -e "\e[33mExample1: $\e[36m./script.sh file.name"
echo -e "\e[33mExample2: \e[0m"
exit
fi
############

###### check input ######
if [ ! -e "$1" ];then
echo -e "\e[33mInvalid source file.  Check the path/filename"
exit
fi
######

###### set variables and working directory ######
TEMPDIR=~/temp
INPUT=$(basename $1)
IPLIST1=$TEMPDIR/iptmp
IPLIST2=$TEMPDIR/ipnodupe
IPLIST3=$TEMPDIR/ipshuf
KVP=$TEMPDIR/ipkvp
OUTPUT=$1-scrubbed

if [ ! -e $TEMPDIR ];then
mkdir $TEMPDIR
fi
############


###### enumerate IPs ######
grep -E -o '(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)' $1 > $IPLIST1
############

###### remove duplicates ######
awk '!seen[$0]++' $IPLIST1 > $IPLIST2
rm $IPLIST1
############

###### random shuffle ######
#alternative: 
#cat $IPLIST2 |perl -MList::Util=shuffle -e 'print shuffle(<STDIN>);' >IPLIST3
sort -R $IPLIST2 >$IPLIST3
rm $IPLIST2
############

###### append identifier ######
nl -s'-IPv4,' $IPLIST3 > $KVP
rm $IPLIST3
############

###### match and replace ######
awk -F "," 'FNR==NR{A[$2]=$1;next}{for(i in A)if($0~i"[^0-9]|$")sub(i,A[i],$0)}1' $KVP $1 > $OUTPUT
############

###### sample output ######
Echo -e "\e[33mSample Output of $OUTPUT"
grep -- -IPv4 $OUTPUT | tail
############
