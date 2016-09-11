#!/bin/bash
#
# Execute The Bona Fide Club score processing pipeline
#

# Script directory
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

# Import settings
. $DIR/env


#
# Clear old run data
#
rm "$CORPUS_PROFILE_DIR/*.bonafide"
rm "$CORPUS_PROFILE_DIR/*.corpus"
rm "$CORPUS_PROFILE_DIR/*.profile*"


#
# Pull down current corpus sets
#
$DIR/bin/get-corpus.sh
result="$?"

if [ "$result" -ne "0" ];
then
  echo 1>&2 "Failed to download corpus data"
  exit 1
fi


#
# Process the corpus data through Watson
#
for p in "$CORPUS_PROFILE_DIR/*.corpus";
do
  $DIR/bin/process-corpus.sh "$p"
done


#
# Extract the Bona Fide score
#
for p in "$CORPUS_PROFILE_DIR/*.profile";
do
  $DIR/bin/extract-profile-values.py -p "${p%.*}"
done


#
# Load the scores back to Bona Fide
#
$DIR/bin/load-profile.sh
