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
echo "-p preserve realtive path"
echo "-k preserve absolute path"
echo "-d backup destination"
echo "-f files to include"
echo "-m modification date ('+' - greater than, '-' - less than, '' - exactly) "
echo "-s file size (in kilobytes)"
echo "-o owner"
}

preserve_struct=false
preserve_abs_struct=false

while getopts :hvpkcm:s:o:d:f: OPTION
do
	case $OPTION in
		h ) help; exit ;;
		c ) exit 1;;
		p ) preserve_struct=true ;;
		k ) preserve_abs_struct=true ;;
		d ) dest_folder="$OPTARG/backup" ;;
		f ) if [ -d $OPTARG ]; then
			    file="$(cd -- "$OPTARG" && pwd)"
		    else    
			    file="$(cd -- "$(dirname "$OPTARG")" && pwd)/$(basename "$OPTARG")"
		    fi 
		    files+=("$file") ;; 	# Get abolute path 
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

mkdir -p "$dest_folder" # creates folder if it doesn't exist
dest_folder=$(cd -- "$dest_folder" && pwd) # Makes it absolute path 

# A double dash (--) is used in commands to signify the end of
# command options, so files containing dashes or other special
# characters won't break the command.

if $preserve_abs_struct ; then
	for file in "${files[@]}"; do
		if [ -d $file ]; then
			find $file $last_modified $size $owner -exec cp 2> /dev/null --parents {} "$dest_folder"  \;
		else
			path="$(dirname $file)"
			mkdir -p "$dest_folder/$path"

			find $file $last_modified $size $owner -exec cp 2> /dev/null {} "$dest_folder/$path" \;
		fi
	done
elif $preserve_struct ; then
	for file in "${files[@]}"; do
		if [ -d $file ]; then		
			base_dir="$(basename $file)"
			mkdir -p "$dest_folder/$base_dir"

	        	cd -- $file && 
			find . $last_modified $size $owner -exec cp 2> /dev/null --parents {} "$dest_folder/$base_dir"  \;
		else 	
			find $file $last_modified $size $owner -exec cp 2> /dev/null {} "$dest_folder"  \;
		fi
	done
else
	for file in "${files[@]}"; do
		find $file $last_modified $size $owner -exec cp 2> /dev/null {} "$dest_folder" \;
	done
fi

	
