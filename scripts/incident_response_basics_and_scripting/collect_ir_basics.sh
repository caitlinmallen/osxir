#!/bin/bash

#Create folder where all collected data will go# 
IRfolder=collection

#Ensure script is being executed as root#
if [[ $EUID -ne 0 ]]; then 
    echo "Incident Response Script needs to be executed as root!"
    exit 1 

fi

sudo -k

#Save which user executed the analysis script as we may need it later#
originalUser=`sh -c 'echo $SUDO_USER'`
echo "Collecting data as root escalated from the $originalUser account"

#insert company message here explaining the situation#
cat << EOF
-----------------------------------------------------------------------------
COLLECTING CRITICAL SYSTEM DATA. PLEASE DO NOT TURN OFF YOUR SYSTEM...
-----------------------------------------------------------------------------
EOF

echo "Start time-> `date`"

#Start tracing connections with dtrace# 

#Memory collection#

#Volatile data collection using the shell# 

#Create a pf rule to block all network access to file server over ssh#
quarentineRule=/etc/activeir.conf
echo "Writing quarantine rule to $quarentineRule"
serverIP=192.168.1.11 #IP of the server the system needs to stay in contact with# 
cat > $quarentineRule << EOF
block in all
block out all 
pass in proto tcp from $serverIP to any port 22
EOF

#load the pfcconf rule and inform user there is no internet access#
pfctl -f $quarentineRule 2>/dev/null
pfctl -e 2>/dev/null
if [ $? -eq 0]; then 
    echo "Quarentine Enabled. Internet access unavailable."
fi 

#Collect file listing#

#Collect file artifacts#

#Collect system startup artifacts and ASEPS#

#Collect browser artifacts#

#Create zip file with all data in current directory#
echo "Archiving Data"
cname=`scutil --get ComputerName | tr ' ' '_' | tr -d \'`
now=`date +"_%Y-%m-%d"`
ditto -k --zlibComressionLevel 5 -c $IRfolder $cname$now.zip
