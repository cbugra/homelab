#!/bin/sh

# Script for adding SSH Banner programmatically.
# Designed for use within homelab vm-templates, at bootup
# Should work in ubuntu20.04, POSIX-compliance is NOT TESTED.
# package required: figlet
# sample bellow, '#' and explanation at the end not included

#============================================================ \
#                           CBKlab                            }-->Header
#Pool: Linux                                                  |
#Type: VM_Template                                            /
#                                                             \
#node01.prj.cbk.lab -- 192.168.1.91                           |
#                 _       ___  _              _               |
# _ __   ___   __| | ___ / _ \/ |  _ __  _ __(_)              }-->Func.
#| '_ \ / _ \ / _` |/ _ \ | | | | | '_ \| '__| |              |   Output
#| | | | (_) | (_| |  __/ |_| | |_| |_) | |  | |              |
#|_| |_|\___/ \__,_|\___|\___/|_(_) .__/|_| _/ |              |
#                                 |_|      |__/               /
#============================================================ --->Footer

# Provide banner path in '/etc/ssh/sshd_config' (bellow is the default)
#Banner /opt/ssh-banner/ssh-banner.txt


# <FQDN> -- <IPv4 addr>
# Figlet of FQDN as top 2 levels substracted (e.g. ".cbk.lab")
generate_hostname_banner()
{
printf  "\n$( hostname -f ) -- $( hostname -I )\n$( figlet "$(  hostname -f | awk -F".$( hostname -f | awk -F'.' '{print $(NF-1) "." $(NF)}' )" '{print $1}'  )")\n" 
}

# For archiving purposes, is restrictive after adding parameters
## Check for root or sudo
#if [ $(id -u) -ne 0 ]; then
# 	echo "Root priviledge required!" >&2
#	exit 1
#fi

# Imported projects defaults (initially must be ' INSTALL_DIR="/opt/ssh-banner" ' for installer)
INSTALL_DIR="/opt/ssh-banner"


#Defaults
header_path="$INSTALL_DIR/ssh-banner-header.txt"
banner_path="$INSTALL_DIR/ssh-banner.txt"
footer_path="$INSTALL_DIR/ssh-banner-footer.txt"

#Options
OPT_STRING=":b:f:h:"
while getopts $OPT_STRING OPTION; do
	case $OPTION in
		:)
			echo "Must supply an argument to -$OPTARG." >&2
			exit 2	;;
		\?)
			echo "Invalid option -$OPTARG." >&2  # '>' for owerwrite as usual
			exit 3	;;                           # '&2' for stderr
		b)
			banner_path=$OPTARG	;;
		h)
			header_path=$OPTARG	;;
		f)
			footer_path=$OPTARG	;;
	esac
done

# overwrite ssh banner file with predefined header and banneri
# '>>' for append for those wondering
cp $header_path $banner_path && generate_hostname_banner >> $banner_path && cat $footer_path >> $banner_path


