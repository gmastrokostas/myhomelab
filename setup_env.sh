#!/bin/bash
source venv/bin/activate
clear

sep="----------------------------------"

echo $sep
echo "Please enter Setup Type"
echo $sep
echo ""
if [ "$#" -eq 0 ]; then
    echo "Valid choices are:" 
    echo "AA - For an OS install and Active Active Setup"
    echo "AP - For an OS install and Active Passive Setup" 
    echo "OS - For an OS Only install"
elif [ $1 == "AA" ]; then
    echo "You selected an ACTIVE ACTIVE Setup"
    echo ""
    echo "CRITICAL: I will now destroy the environment and recreate it as an ACTIVE ACTIVE Setup"
    echo ""
    echo "--Type YES or NO"
    read confirm
    if [ $confirm == "YES" ];  then 
        echo "ANSIBLE ONE"
    elif [ $confirm == "NO" ]; then 
        echo "ANSIBLE TWO"
    else
        echo "WRONG INPUT"
    fi;

elif [ $1 == "AP" ]; then
    echo "You selected an ACTIVE PASSIVE Setup"
    echo ""
    echo "CRITICAL: I will now destroy the environment and recreate it as an ACTIVE PASSIVE Setup"
    echo ""
    echo "--Type YES or NO"
    read confirm
    if [ $confirm == "YES" ];  then 
        echo "Setting up PXE Boot Order on all servers"
        echo "Rebooting All HP devices"
        echo "python3 set_up_boot_device.py"
        sleep 2
        echo "Install of Environment Started"
    elif [ $confirm == "NO" ]; then 
        echo "Quiting"
    else
        echo "WRONG INPUT"
    fi;

elif [ $1 == "OS" ]; then
    echo "You selected to do an OS only install"
    echo ""
    echo "CRITICAL: I will now destroy the environment and do an OS install with iscsi setup but no HA Clustering"
    echo ""
    echo "--Type YES or NO"
    read confirm
    if [ $confirm == "YES" ];  then 
        >~/.ssh/known_hosts
        python3 OS_INSTALL.py
    elif [ $confirm == "NO" ]; then 
        echo "ANSIBLE TWO"
    else
        echo "WRONG INPUT"
    fi;

else
    echo "Invalid Selection. Please choose either AA or AP OR OS."
fi
