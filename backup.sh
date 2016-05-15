#!/bin/bash
# Author           : Igor Chorazewicz
# Created On       : 12.05.2016
# Last Modified By : Igor Chorazewicz
# Last Modified On : TODO 
# Version          : 1.0
#
# Description      :
# TODO
#
# Licensed under GPL (see /usr/share/common-licenses/GPL for more details
# or contact # the Free Software Foundation for a copy)

help(){
echo "Options:"
echo "-h help"
echo "-c compress backup"
echo "-p preserve folders structure"
echo "-d backup destination"
echo "-f files to include"
echo "-m modification date ('+' - greater than, '-' - less than, '' - exactly) "
echo "-s file size (in kilobytes)"
echo "-o owner"
}

preserve_struct=false

while getopts :hvpcm:s:o:d:f: OPTION
do
	case $OPTION in
		h ) help ;;
		c ) exit 1;;
		p ) preserve_struct=true ;;
		d ) dest_folder="$OPTARG/backup" ;;
		f ) files+=("$OPTARG") ;;
		m ) last_modified="-mtime $OPTARG";;
		s ) size="-size $OPTARG"."k";;
		o ) owner="-user $OPTARG" ;;
		v ) echo -e "Backup script\nAuthor: Igor Chorazewicz\nVersion: 1.0" 
		    exit ;;
		\?) echo "Invalid option -$OPTARG" >&2	# >&2 redirects stdout to stderr
		    exit 1;;
		: ) echo "Missing option argument for -$OPTARG" >&2
	esac
done

if [ -z "$dest_folder" ]; then
	echo "Destination folder must be specified"
	exit 1
fi

# creates folder if it doesn't exist
mkdir -p "$dest_folder"	

if $preserve_struct ; then
	copy_opt="--parents"
	dest_folder=$(cd -- "$dest_folder" && pwd) # Makes it absolute path 

# A double dash (--) is used in commands to signify the end of
# command options, so files containing dashes or other special
# characters won't break the command.
fi

for file in "${files[@]}"; do
	cd -- "$file" &&
	find . $last_modified $size $owner -exec cp 2> /dev/null $copy_opt {} "$dest_folder"  \;	
done
