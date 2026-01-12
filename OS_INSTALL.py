from redfish import RedfishClient  #pip install python-ilorest-library


import subprocess
import time 

###############################     HPV2    #############################################################################
# Replace with your iLO details

ILO_HOST = "https://hpv2-ilo"
ILO_USER = "Administrator"
ILO_PASSWORD = "12345678"

# Create a client connection
client = RedfishClient(base_url=ILO_HOST, username=ILO_USER, password=ILO_PASSWORD)

# Login to iLO
client.login()

boot_payload = {
    "Boot": {
        "BootSourceOverrideEnabled": "Once",
        "BootSourceOverrideTarget": "UefiTarget",
        "UefiTargetBootSourceOverride": "PciRoot(0x0)/Pci(0x6,0x0)/Pci(0x0,0x0)/MAC(6CB3118852EC,0x1)/IPv4(0.0.0.0)"
    }
}

# Apply to the default system path
client.patch("/redfish/v1/Systems/1/", body=boot_payload)

###############################     HPV3    #############################################################################

ILO_HOST = "https://hpv3-ilo"
ILO_USER = "Administrator"
ILO_PASSWORD = "12345678"

# Create a client connection
client = RedfishClient(base_url=ILO_HOST, username=ILO_USER, password=ILO_PASSWORD)

# Login to iLO
client.login()

boot_payload = {
    "Boot": {
        "BootSourceOverrideEnabled": "Once",
        "BootSourceOverrideTarget": "UefiTarget",
        "UefiTargetBootSourceOverride": "PciRoot(0x0)/Pci(0x1,0x0)/Pci(0x0,0x0)/MAC(6CB311885932,0x1)/IPv4(0.0.0.0)"
    }
}

# Apply to the default system path
client.patch("/redfish/v1/Systems/1/", body=boot_payload)



#################################   HPV4        ###############################################################################


ILO_HOST = "https://hpv4-ilo"
ILO_USER = "Administrator"
ILO_PASSWORD = "12345678"

# Create a client connection
client = RedfishClient(base_url=ILO_HOST, username=ILO_USER, password=ILO_PASSWORD)

# Login to iLO
client.login()

boot_payload = {
    "Boot": {
        "BootSourceOverrideEnabled": "Once",
        "BootSourceOverrideTarget": "UefiTarget",
        "UefiTargetBootSourceOverride": "PciRoot(0x0)/Pci(0x1,0x0)/Pci(0x0,0x0)/MAC(6CB31188592E,0x1)/IPv4(0.0.0.0)"
    }
}

# Apply to the default system path
client.patch("/redfish/v1/Systems/1/", body=boot_payload)

subprocess.run([">~/.ssh/known_hosts"], check=True)
subprocess.run(["/home/seeker/stash/git_projects/scripts/bash_linux_admin/power_off_on_servers/shutdown_servers.sh"], check=True)
time.sleep(20)
subprocess.run(["/home/seeker/stash/git_projects/scripts/bash_linux_admin/power_off_on_servers/ilo_poweup_all.sh"], check=True)
