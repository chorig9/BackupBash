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
echo "-d backup destination"
echo "-f files to include"
echo "-m modification date ('+' - greater than, '-' - less than, '' - exactly) "
echo "-s file size (in kilobytes)"
echo "-o owner"
}

while getopts :hvcm:s:o:d:f: OPTION
do
	case $OPTION in
		h ) help ;;
		c ) exit 1;;
		d ) DEST_FOLDER="$OPTARG/backup" ;;
		f ) FILES+=("$OPTARG") ;;
		m ) LAST_MODIFIED="-mtime $OPTARG";;
		s ) SIZE="-size $OPTARG"."k";;
		o ) OWNER="-user $OPTARG" ;;
		v ) echo -e "Backup script\nAuthor: Igor Chorazewicz\nVersion: 1.0" 
		    exit ;;
		\?) echo "Invalid option -$OPTARG" >&2
		    exit 1;;
		: ) echo "Missing option argument for -$OPTARG" >&2
	esac
done

if [ -z "$DEST_FOLDER" ]; then
	echo "Destination folder must be specified"
	exit 1
fi

mkdir -p "$DEST_FOLDER"	

for FILE in "${FILES[@]}"; do
	find "$FILE" $LAST_MODIFIED $SIZE $OWNER -exec cp {} "$DEST_FOLDER" \; #TODO : " "
	 #cp -r "$FILE" "$DEST_FOLDER"	
done
