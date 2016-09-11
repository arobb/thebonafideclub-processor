#!/bin/bash
#
# Transmit user message history to Watson for profiling
# Watson limits uploads to 20MB


# Script directory
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )


# Pull in credentials and configuration
. $DIR/env


#
# Make sure we received a corpus to send
#
if [ -z "$1" ];
then
  echo >&2 "Please provide a corpus to profile"
  exit 1
else
  corpus_path="$1"
  corpus_dir=$(dirname "$corpus_path")
  corpus_file=$(basename "$corpus_path")
  corpus_name="${corpus_file%.*}"

  profile_path="$corpus_dir/$corpus_name.profile"
fi


#
# Do some validations on the corpus
#


# Temp file for output headers
headers=$(mktemp -t "watson-headers-temp.XXXXXXXX")


#
# Transmit the corpus
#
curl -u "$WATSON_PI_USERNAME":"$WATSON_PI_PASSWORD" \
--silent \
--dump-header "$headers" \
--header "Content-Type: application/json" \
--header "Accept: application/json" \
--data-binary @"$corpus_path" \
"$WATSON_PI_URL/v2/profile" \
>"$profile_path"
result="$?"


#
# Did CURL do its job?
#
if [ "$result" -ne "0" ];
then
  echo >&2 "CURL transmission failed, returned exit code $result"
  # If you exit, don't forget to delete the temp header file
fi


#
# Pretty format the profile in case we need to read it
#
cat "$profile_path" | python -m json.tool > "$profile_path.pretty.json"


#
# Validate the return code
#
httpcode=$(head -1 "$headers" | sed -n 's/.* \([0-9]\{3\}\).*/\1/p')
httpcodeclass="${httpcode:0:1}"

if [ -z "$httpcode" ];
then
  echo 1>&2 "Something went wrong during transmission, didn't get a response"

elif [[ ! "$httpcodeclass" -eq "1" ]] && [[ ! "$httpcodeclass" -eq "2" ]];
then
  echo 1>&2 "Watson returned error code $httpcode"
fi


# Clean up
rm "$headers"
