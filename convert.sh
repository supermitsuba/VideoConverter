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
excludePath="${EXCLUDEPATH}"
videoOptions="${VIDEO_OPTIONS}"

echo "Processing extension: $extension "
echo "Processing this directory: $source "
echo "Using h265: ${useh265}"
echo "Using excludePath: ${excludePath}"
echo "Using Video Options: ${VIDEO_OPTIONS}"

# Get a list of all files to convert
DATE_WITH_TIME=`date "+%Y%m%d-%H%M%S"`
Files=$()
echo "${DATE_WITH_TIME}: Here are the files to loop" >> "${logFile}"

findPath="find \"${source}\" -type f -name \"${extension}\" ${excludePath} | head -n $numberOfFiles"

eval $findPath >> "${logFile}"
eval $findPath | while read sourceFile; do
    
    DATE_WITH_TIME=`date "+%Y%m%d-%H%M%S"`
	
	# Get the destination file
	destFile="${sourceFile%.*}.mp4"
	tempFile="${sourceFile%.*}.temp.mp4"

	rm -r "$tempFile"

	# Convert ts file to mp4
	if [ "$useh265" = "true" ]; then
  		echo "${DATE_WITH_TIME}: Starting with this file as h265: $sourceFile to $destFile" >> "${logFile}"
		ffmpeg -nostdin -i "${sourceFile}" -c:v libx265 -c:a aac -map 0:v $videoOptions "${tempFile}" 
	else
  		echo "${DATE_WITH_TIME}: Starting with this file as h264: $sourceFile to $destFile" >> "${logFile}"
		ffmpeg -nostdin -i "${sourceFile}" -c:v libx264 -c:a aac -map 0:v $videoOptions "${tempFile}" 
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