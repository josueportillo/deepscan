**************************************Deepscan Network Scanner*********************************************

Scans the selected network(s) for alive hosts and scans them for open ports. Creates separated text files
with relevant info and results in a conviniently organized folder tree.

* Release notes:

* v1.1.3
	- Code improvements
	- WHILE loop for menu until a correct option is selected.
	- Improved menu, no ENTER needed, just press the option key.

* v1.1.2
	- Load the $HOME variable as part of the route for folder creation.
	- Added [q] Quit option, which generates an exit code 0.
	- Added Nmap installation checker. 
	- Added exit code 0 at the end of options [1] and [2] to avoid leaving orphan processes.

* v1.1                                                          
	- Added selection menu for automated scan or manually setting target network.                                
	- Added this README file and made it accesible through menu option [3].

* v.1.0                                                                                                      
	- Scans the local host for directly connected networks and looks for hosts with open ports in those networks.
	- Automatically defines a folder tree for easy use of the results afterwards.                                 
	- Requires nmap to be installed. Soon I'll be adding auto-install capabilities for the dependencies.         

Author: Josue Portillo. 2018.                                                                              

************************************************************************************************************
