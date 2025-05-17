#!/bin/sh -

# Check for use of /bin/root-ssh-cmd as a forced command.
if test "$#" -eq 2 && test "$1" = "-c" && test "$2" = "/bin/root-ssh-cmd"; then
	shift 2
	if test -n "$SSH_ORIGINAL_COMMAND"; then
		set -- -c "$SSH_ORIGINAL_COMMAND"
	fi
fi

SysShell=/bin/sh
CliShell=/bin/clish

# Check to see if the command line arguments are passed to the shell?
# If there are arguments, then if they could be for the clish or some 
# process like scp. So check the parameters and invoke appropriate shell.

LaunchShell=$CliShell
#if [ "$1" = "-c" ]; then
#	Prog=`echo "$2" | awk '{print$1}'`
	# Situation like "-c 'scp -f xxxxxx'"
#	if [ "$Prog" = "scp" -o \
#	    "$Prog" = "/usr/libexec/sftp-server" -o \
#	    "$Prog" = "/usr/libexec/openssh/sftp-server" ] ; then
#		LaunchShell=$SysShell
#	fi
#fi

# Invoke .profile only if the login shell is clish, scp process does not
# need any environment variable. But the .profile could cause problems if
# it has 'stty' kind of commands.
if [ "$LaunchShell" = "$CliShell" ]; then
	if [ -f $HOME/.profile ]; then
		. $HOME/.profile
	fi
fi

# Set the PS1 variable for prompt
PS1='\u@\H:\w\$ '
export PS1

is_mbs=`/bin/is_mbs.sh`

if [ ! -f /etc/.wizard_accepted ]; then
	if [ "$is_mbs" == 'mbs' ]; then
		/bin/sysconfig
	else
		if [ "$LOGNAME" != "cadmin" ]; then
        	/bin/ftw 1>&2
	fi
fi
fi
export BASH_LOGGER="ON"

# Now launch the shell with all its aruments.
exec $LaunchShell "$@"

# Not reached
exit 0
