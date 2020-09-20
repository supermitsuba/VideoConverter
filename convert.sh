#!/bin/bash

if [ -z "$VIDEO_EXT" ]
then
	echo "Enter an extension to convert videos, like 'ts' or 'mkv'!"
	exit 0
fi

source="/mnt/source"
log="/mnt/log"
logFile="${log}/log.txt"
extension="*.${VIDEO_EXT}"
numberOfFiles="${NUM_FILES}"
useh265="${USEH265}"

echo "Processing extension: $extension "
echo "Processing this directory: $source "
echo "Using h265: ${useh265}"

# Get a list of all files to convert
DATE_WITH_TIME=`date "+%Y%m%d-%H%M%S"`
Files=$()
echo "${DATE_WITH_TIME}: Here are the files to loop" >> "${logFile}"
find "${source}" -type f -name "${extension}" -not -path "*/.*/*" -not -path "*/Meet the Press*/*" -not -path "*/FlashPoint*/*" | head -n $numberOfFiles >> "${logFile}"

find "${source}" -type f -name "${extension}" -not -path "*/.*/*" -not -path "*/Meet the Press*/*" -not -path "*/FlashPoint*/*" | head -n $numberOfFiles | while read sourceFile; do
    
    DATE_WITH_TIME=`date "+%Y%m%d-%H%M%S"`
	
	# Get the destination file
	destFile="${sourceFile%.*}.mp4"
	tempFile="${sourceFile%.*}.temp.mp4"

	# Convert ts file to mp4
	if [ "$useh265" = "true" ]; then
  		echo "${DATE_WITH_TIME}: Starting with this file as h265: $sourceFile to $destFile" >> "${logFile}"
		ffmpeg -nostdin -i "${sourceFile}" -c:v libx265 -c:a aac -map 0:a -map 0:v "${tempFile}" 
	else
  		echo "${DATE_WITH_TIME}: Starting with this file as h264: $sourceFile to $destFile" >> "${logFile}"
		ffmpeg -nostdin -i "${sourceFile}" -c:v libx264 -c:a aac -map 0:a -map 0:v "${tempFile}" 
	fi

	# Move ts file to temp folder
	rm "${sourceFile}"
	mv "${tempFile}" "$destFile"

    DATE_WITH_TIME=`date "+%Y%m%d-%H%M%S"`
	echo "${DATE_WITH_TIME}: Deleted file ${sourceFile}"  >> "${logFile}"
	echo "${DATE_WITH_TIME}: Created file ${destFile}"  >> "${logFile}"
	
	echo ""
done

exit 0