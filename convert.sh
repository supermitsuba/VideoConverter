#!/bin/bash
source="/mnt/source"
destination="/mnt/destination"
extension="*.ts"

echo "Processing this directory: $source "

# Get a list of all files to convert
find "${source}" -type f -name "${extension}" -not -path "*/.*/*" -not -path "*/Meet the Press*/*" -not -path "*/FlashPoint*/*" | while read sourceFile; do

  	echo "Starting with this file: $sourceFile"
	
	# Get the destination file
	destFile="${sourceFile%.ts}.mp4"
	echo "Converting file to: $destFile"

        # get the file name only
	sourceFileName=$(echo "${sourceFile}" | sed "s/.*\///")
	echo "The file name is: $sourceFileName"

	# Convert ts file to mp4
	ffmpeg -nostdin -i "${sourceFile}" -c:v libx264 -c:a aac "${destFile}"

	# Move ts file to temp folder
	mv "${sourceFile}" "$destination/$sourceFileName"
	
	echo ""
done

exit 0
