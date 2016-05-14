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
}

while getopts :hvcd:f: OPTION
do
	case $OPTION in
		h ) help ;;
		c ) exit 1;;
		d ) DEST_FOLDER="$OPTARG/backup" ;;
		f ) FILES+=("$OPTARG");;
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
	cp -r "$FILE" "$DEST_FOLDER"	
done
