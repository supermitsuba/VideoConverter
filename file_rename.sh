#!/bin/bash
# (S[0-9])\w+
# (S[0-9])\w+(E[0-9])\w+
# (S\d\d)+(E\d\d)+
source="/mnt/source"
log="/mnt/log"
logFile="${log}/log.txt"

DATE_WITH_TIME=`date "+%Y%m%d-%H%M%S"`

# echo "${DATE_WITH_TIME}: Here are the files to loop" >> "${logFile}"
cd "${source}"
getDirectories="ls -ldx */"
shopt -s nocasematch

eval $getDirectories | while read sourceFolder; do

  name="${sourceFolder}"
  cd "${name}"
  count=`ls | wc -l`
  fullPath="${source}${name}"

  if [ $count -eq 1 ] ; then
    ls | while read sourceFiles; do
        if [[ $name =~ .*(S[0-9]{2})+(E[0-9]{2})+ ]]; then
        short_name="${BASH_REMATCH}"
        if [[ $short_name =~ (S[0-9]{2})+(E[0-9]{2})+ ]] ; then
          season="${BASH_REMATCH}"
        fi
        short_name="${short_name//[.]/ }"
        short_name="${short_name/"$season"/- "$season"}"
        echo "match: '${short_name}' for '${sourceFiles}' changing to '${short_name}.${sourceFiles##*.}'" >> "${logFile}"
        mv "${sourceFiles}" ../"${short_name}.${sourceFiles##*.}"
      else
        echo "${DATE_WITH_TIME}: Could not find the season values for ${fullPath}" >> "${logFile}"
      fi
    done
  else
      echo "${DATE_WITH_TIME}: Multiple files for ${fullPath}" >> "${logFile}"
  fi 
  cd - > /dev/null

done

shopt -u nocasematch
