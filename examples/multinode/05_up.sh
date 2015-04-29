#!/bin/bash
# This is the script for bringing up the standard openstack nodes without
# Swift. This is probably the up script you want to run.

PROVIDER=${PROVIDER:-vmware_fusion}

#---  FUNCTION	----------------------------------------------------------------
#		   NAME:  provider
#	DESCRIPTION:  checks for binary name in PATH
#	 PARAMETERS:  -
#		RETURNS:  identifier for provider
#-------------------------------------------------------------------------------
provider ()
{
	if [[ -x `which vmware_fusion` ]]
	then
		echo "vmware_fusion"
	elif [[ -x `which VirtualBox` ]]
	then
		echo "virtualbox"
	else
		exit 1
	fi
}	# ----------  end of function provider	----------

vagrant up --provider $(provider) puppet control storage network compute
