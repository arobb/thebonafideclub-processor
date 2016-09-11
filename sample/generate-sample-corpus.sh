#!/bin/bash
#
# Generate a sample corpus based on a speech
#

# Script directory
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

# Pull in credentials and configuration
. $DIR/../env

# Escape incoming text
text=$(cat "$DIR/speech.txt" | python -c 'import json,sys; print json.dumps(sys.stdin.read())')

# Write a sample corpus
cat << EOF > "$DIR/../$CORPUS_PROFILE_DIR/sample.corpus"
{ "contentItems": [
  {
      "id": "55874dba-0ed2-47d9-8e7a-b9e310dbf692"
    , "userid": "dd37b243-d9b9-4b5f-8adc-bc3bd28a162d"
    , "contenttype": "text/plain"
    , "content": $text
  }
]}
EOF
