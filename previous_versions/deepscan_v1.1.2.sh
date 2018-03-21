#!/bin/bash

#**************************************Deepscan Network Scanner***********************************************
#*v1.1                                                                                                       *
#*Added selection menu for automated scan or manually setting target network.                                *
#*Added the README.md file, accesible through option 3 of the menu.                                          *
#*v.1.0                                                                                                      *
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

#Check if Nmap is installed

echo "Checking to see if Nmap is installed."
if [ -a nmap ]; then
        echo "Nmap installed. Good to go."
else
        echo "Nmap not installed. Please install Nmap and rerun this program."
        echo "Quitting..."
        exit 1
fi


#Selection menu

echo ' '
echo ******************Deepscan v1.1.2**********************
echo ' '
echo Please select the type of scan:
echo ' '
echo [1] Automatic [scans all locally connected networks].
echo [2] Manually enter target network.
echo [3] Display README file.
echo ' '
echo [q] Quit.
echo Please enter your selection and press ENTER:
read option

#Automatic Scan

if [ $option = 1 ]; then
#Target name for folder creation
	echo 'Enter the name of the target:'
	read targetname
#Start time to calculate runtime.
	start=`date +%s`
#Gather local networks via the ROUTE command and start scanning for hosts in found networks.
	route | grep "*" | for networks in $(cut -d " " -f 1); 
		do echo $networks >> deepscan_tmplist && echo "***Found $networks/24 network segment. Creating folder $HOME/deepscan/$targetname/$networks for storing results and scanning for live hosts.***" &&  mkdir -p $HOME/deepscan/$targetname/$networks && echo 'Folder created.'  && echo 'Running scan, please wait...' && nmap -sn $networks/24 | grep 'Nmap scan report' | cut -f 5 -d " " > $HOME/deepscan/$targetname/$networks/hostlist && echo 'Found hosts:' && cat $HOME/deepscan/$targetname/$networks/hostlist;
		done
#Port scan of found hosts
	echo '***Scanning individual hosts for open ports, please wait...***';
	for networks in $(cat deepscan_tmplist);
		do for host in $(cat $HOME/deepscan/$targetname/$networks/hostlist);
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
	exit 0
fi

#Manual scan

if [ $option = 2 ]; then
        echo 'Enter the name of the target:'
        read targetname
#Enter network range to be scanned
	echo 'Enter the network address to be scanned [i.e. 192.168.0.0]'
	read network
	echo 'Enter the netmask to be used [i.e. 24]'
	read netmask
#Start time to calculate runtime.
        start=`date +%s`
	for networks in $network; 
                do echo $networks >> deepscan_tmplist && echo "***Using $networks/$netmask network segment. Creating folder $HOME/deepscan/$targetname/$networks for storing results and scanning for live hosts.***" &&  mkdir -p $HOME/deepscan/$targetname/$networks && echo 'Folder created.'  && echo 'Running scan, please wait...' && nmap -sn $networks/$netmask | grep 'Nmap scan report' | cut -f 5 -d " " > $HOME/deepscan/$targetname/$networks/hostlist && echo 'Found hosts:' && cat $HOME/deepscan/$targetname/$networks/hostlist;
                done
#Port scan of found hosts
        echo '***Scanning individual hosts for open ports, please wait...***';
        for networks in $(cat deepscan_tmplist);
                do for host in $(cat $HOME/deepscan/$targetname/$networks/hostlist);
                        do nmap -sV -sS -Pn $host | grep 'open' > $HOME/deepscan/$targetname/$networks/openports_$host && echo "Open ports for $host:" && cat $HOME/deepscan/$targetname/$networks/openports_$host; 
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
	exit 0
fi

#Show the README.md file
if [ $option = 3 ]; then
	less $HOME/bash/deepscan/README.md
	$HOME/bash/deepscan/deepscan.sh #testing return to main menu
	#exit 0
fi

#Quit the program
if [ $option = q ]; then
	echo "Bye!"
	exit 0
fi

#Wrong option selected. Broken, needs some work.
#if [ $option != [1,2,3] ]; then
#	echo "Wrong selection. Exiting..."
#	exit 1
#fi
