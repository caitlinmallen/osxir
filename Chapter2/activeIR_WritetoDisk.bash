#!/bin/bash
serverIP=192.168.1.111
ruleFile=/etc/activeIR.conf
echo "block in all" > $ruleFile
block out all >> $ruleFile
pass in proto tcp form $serverIP to any port 22 >> $ruleFile

#load rule
pfctl -ef $ruleFile
echo "Enabling custom firewall rules"
pfctl -e