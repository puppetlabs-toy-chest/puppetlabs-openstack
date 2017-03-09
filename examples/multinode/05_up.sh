#!/bin/bash
# This is the script for bringing up the standard openstack nodes without
# Swift. This is probably the up script you want to run.

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

[[ $PROVIDER = "" ]] && PROVIDER="`provider`"
vagrant up --provider $PROVIDER puppet control storage network compute
