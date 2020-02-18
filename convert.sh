#!/bin/bash
source="/mnt/source"
log="/mnt/log"
logFile="${log}/log.txt"
extension="*.ts"

echo "Processing this directory: $source "

# Get a list of all files to convert
DATE_WITH_TIME=`date "+%Y%m%d-%H%M%S"`
Files=$()
echo "${DATE_WITH_TIME}: Here are the files to loop" >> "${logFile}"
find "${source}" -type f -name "${extension}" -not -path "*/.*/*" -not -path "*/Meet the Press*/*" -not -path "*/FlashPoint*/*" >> "${logFile}"

find "${source}" -type f -name "${extension}" -not -path "*/.*/*" -not -path "*/Meet the Press*/*" -not -path "*/FlashPoint*/*" | while read sourceFile; do
    
    DATE_WITH_TIME=`date "+%Y%m%d-%H%M%S"`
  	echo "${DATE_WITH_TIME}: Starting with this file: $sourceFile" >> "${logFile}"
	
	# Get the destination file
	destFile="${sourceFile%.ts}.mp4"
	echo "Converting file to: $destFile" >> "${logFile}"

	# Convert ts file to mp4
	ffmpeg -nostdin -i "${sourceFile}" -c:v libx264 -c:a aac "${destFile}"

	# Move ts file to temp folder
	rm "${sourceFile}"

    DATE_WITH_TIME=`date "+%Y%m%d-%H%M%S"`
	echo "${DATE_WITH_TIME}: Deleted file ${sourceFile}"  >> "${logFile}"
	echo "${DATE_WITH_TIME}: Created file ${destFile}"  >> "${logFile}"
	
	echo ""
done

exit 0