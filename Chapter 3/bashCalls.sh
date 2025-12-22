#!/bin/bash

#Set up variables
IRfolder=collection
systemCommands=$IRfolder/bashCalls

#Creates output directory 
mkdir $IRfolder
mkdir $systemCommands

#Starts tracing TCP connections in background
scripts/soconnect_mac.d -o $IRfolder/sconnect.log & 
#Get PID - Avoid using pgrep in case of dtrace already running 
dtracePID=`ps aux | grep dtrace.*sconnect_mac.d | grep -v grep | awk '{print $2}'`
echo "Start tracing outbound TCP connections. Dtrace PID is $dtracePID"

#Collects volatile bash data 
echo "Running system commands..."

#Collects bash history 
history > $systemCommands/history.txt

#Basic system ifo 
systemInfo=$systemCommands/sysInfo.txt
 
#Create file 
touch $systemInfo

#Echo ---command name to be used---; use command; append a blank line
echo ---date--- >> $systemInfo;  date >> $systemInfo; echo >> $systemInfo
echo ---hostname--- >> $systemInfo; hostname >> $systemInfo; echo >> $systemInfo
echo ---uname -a--- >> $systemInfo; uname -a >> $systemInfo; echo >> $systemInfo
echo ---sw_vers--- >> $systemInfo; sw_vers >> $systemInfo; ehco >> $systemInfo
echo ---nvram--- >> $systemInfo; nvram >> $systemInfo; ehco >> $systemInfo
echo ---uptime--- >> $systemInfo; uptime >> $systemInfo; ehco >> $systemInfo
echo ---spctl --status--- >> $systemInfo; spctl --status >> $systemInfo; ehco >> $systemInfo
echo ---base --version--- >> $systemInfo; bash --version >> $systemInfo; ehco >> $systemInfo

#Collect who-based data 
ls -la /Users > $systemCommands/ls_la_users.txt
whoami > $systemCommands/whoami.txt
who > $systemCommands/who.txt
w > $systemCommands/w.txt
last > $systemCommands/last.txt

#Collect user info 
userInfo=$systemCommands/userInfo.txt
echo ---Users on this system--- >>$userInfo; dscl . -ls /Users >> $userInfo; echo >> $userInfo
#For each user 
dscl . -ls /Users | egrep -v ^_ | while read user 
do 
    echo *****$user***** >> $userInfo
    echo ---id \($user\)--- >> $userInfo; id $user >> $userInfo; echo >> $userInfo
echo ---groups \($user\)--- >> $userInfo; groups $user >> $userInfo; echo >> $userInfo
    echo ---finger \($user\) --- >> $userInfo; finger -m $user >> $userInfo; echo >> $userInfo
    echo >> $userInfo
    echo >> $userInfo
done

#Collect network-based info 
netstat > $systemCommands/netstat.txt
netstat -ru > $systemCommands/netstat_ru.txt
networksetup -listallhardwarereports > $systemCommands/networksetup_listallhardwarereports.txt
lsof -i > $systemCommands/lsof_i.txt
arp -a > $systemCommands/arp_a.txt
smbutil statshares -a > $systemCommands/smbutil_statshares.txt
security dump-trust-settings > $systemCommands/security_dump_trust_settings.txt
ifconfig > $systemCommands/ifconfig.txt

#Collect process-based info 
ps aux > $systemCommands/ps_aux.txt
ps axo user,pid,ppid,start,command > $systemCommands/ps_axo.txt

#Collect driver info 
kextstat > $systemCommands/kextstat.txt

#Collect hard drive info 
hardDriveInfo=$systemCommands/hardDriveInfo.txt
touch $hardDriveInfo
echo ---diskutil list--- >> $hardDriveInfo; diskutil list >> $hardDriveInfo; echo >> $hardDriveInfo
echo --df -h--- >> $hardDriveInfo; df -h >> $hardDriveInfo; echo >> $hardDriveInfo
echo ---du -h--- >> $hardDriveInfo; diskutil du -h >> $hardDriveInfo; echo >> $hardDriveInfo

#Stop tracing outbound TCP data
kill -9 $dtracePID

#Create a zip file of all data in the current directory 
echo "Archiving data"
cname=`scutil --get ComputerName | tr ' ' '_' | tr -d\'`
now=`date +"_%Y-%m-%d"`
ditto -k -zlibCompressionLevel 5 -c . $cname$now.zip