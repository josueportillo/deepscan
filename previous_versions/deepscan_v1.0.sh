#!/bin/bash

#*******************************************Deepscan v1.0.****************************************************
#*Scans the local host for directly connected networks and looks for hosts with open ports in those networks.*
#*Automatically defines a folder tree for easy use of the results afterwards.                                * 
#*Requires nmap to be installed. Soon I'll be adding auto-install capabilities for the dependencies.         *
#*Author: Josue Portillo. 2018.                                                                              *
#*************************************************************************************************************

#Check if the file is being run as root (or with sudo)
if [ "$(id -u)" != "0" ]; then
	echo "Must be run as root. Exiting..."
	exit 1
fi
#Target name for folder creation
echo 'Enter the name of the target:'
read targetname
#Start time to calculate runtime.
start=`date +%s`
#Gather local networks via the ROUTE command and start scanning for hosts in found networks.
route | grep "*" | for networks in $(cut -d " " -f 1); 
	do echo $networks >> deepscan_tmplist && echo "***Found $networks/24 network segment. Creating folder deepscan/$targetname/$networks for storing results and scanning for live hosts.***" &&  mkdir -p deepscan/$targetname/$networks && echo 'Folder created.'  && echo 'Running scan, please wait...' && nmap -sn $networks/24 | grep 'Nmap scan report' | cut -f 5 -d " " > deepscan/$targetname/$networks/hostlist && echo 'Found hosts:' && cat deepscan/$targetname/$networks/hostlist;
	done
#Port scan of found hosts
echo '***Scanning individual hosts for open ports, please wait...***';
for networks in $(cat deepscan_tmplist);
	do for host in $(cat deepscan/$targetname/$networks/hostlist);
		do nmap -sV -sS -Pn $host | grep 'open' > deepscan/$targetname/$networks/openports_$host && echo "Open ports for $host:" && cat deepscan/$targetname/$networks/openports_$host; 
		done;
	done
#Delete temporary files created during the scan
echo 'Removing temp files...'
rm deepscan_tmplist
#Finish time to calculate runtime
end=`date +%s`
#Calculate script runtime and display it in a user friendly way.
runtime=$((end-start))
echo Done in $runtime seconds.
