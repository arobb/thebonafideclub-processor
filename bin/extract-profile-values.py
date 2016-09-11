#!/usr/bin/env python
#
# Extract values from the Watson profile
#

import json, argparse
import os, subprocess


#
# Handle arguments
#
parser = argparse.ArgumentParser(description='Extract important profile info from Watson results.')
parser.add_argument('-p', '--profile-name', type=str, nargs='?', required=True,
                    dest='name', help='name of the profile to process')

args = parser.parse_args()


#
# Import environment settings
#
command = ['bash', '-c', 'source ./env && env']

proc = subprocess.Popen(command, stdout = subprocess.PIPE)

for line in proc.stdout:
  (key, _, value) = line.partition("=")
  os.environ[key] = value.strip()

proc.communicate()


#
# Open the profile
#
with open(os.environ["CORPUS_PROFILE_DIR"] + '/' + args.name + ".profile") as f:
    profile = json.loads(f.read())


#
# Extract useful values
#
for child in profile["tree"]["children"]:
    if child["id"] == "personality":
        personality = child["children"][0]["children"]
        break;

for child in personality:
    if child["id"] == "Conscientiousness":
        category = child["children"]
        break;

for child in category:
    if child["id"] == "Dutifulness":
        pct = child["percentage"]

output = { "bonafide": pct }


#
# Write out the score
#
with open(os.environ["CORPUS_PROFILE_DIR"] + '/' + args.name + ".bonafide", 'w') as f:
    json.dump(output, f)
