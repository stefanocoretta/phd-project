#!/bin/bash

# Share

## Push to share
rsync -anv --no-whole-file --delete --exclude '*.DS_Store' \
    ~/Documents/GitHub/phd-project/ \
    /Volumes/Phonology/Common/
rsync -avz --no-whole-file --delete --exclude '*.DS_Store' \
    ~/Documents/GitHub/phd-project/ \
    /Volumes/Phonology/Common/

# Backup

## Push to external HD
rsync -anv --no-whole-file --delete --exclude '*.DS_Store' \
    ~/Documents/GitHub/phd-project/ \
    /Volumes/Multimedia/phd-project/
rsync -avz --no-whole-file --delete --exclude '*.DS_Store' \
    ~/Documents/GitHub/phd-project/ \
    /Volumes/Multimedia/phd-project/

## Pull data folder from external HD

rsync -anv --no-whole-file --delete --exclude '*.DS_Store' \
    /Volumes/Multimedia/phd-project/pilot/data/ \
    ~/Documents/GitHub/phd-project/pilot/data
rsync -anv --no-whole-file --delete --exclude '*.DS_Store' \
    /Volumes/Multimedia/phd-project/tracegram-prepilot/data/ \
    ~/Documents/GitHub/phd-project/tracegram-prepilot/data
rsync -anv --no-whole-file --delete --exclude '*.DS_Store' \
    /Volumes/Multimedia/phd-project/tracegram-pilot/data/ \
    ~/Documents/GitHub/phd-project/tracegram-pilot/data

rsync -avz --no-whole-file --delete --exclude '*.DS_Store' \
    /Volumes/Multimedia/phd-project/pilot/data/ \
    ~/Documents/GitHub/phd-project/pilot/data/
rsync -avz --no-whole-file --delete --exclude '*.DS_Store' \
    /Volumes/Multimedia/phd-project/tracegram-prepilot/data/ \
    ~/Documents/GitHub/phd-project/tracegram-prepilot/data/
rsync -avz --no-whole-file --delete --exclude '*.DS_Store' \
    /Volumes/Multimedia/phd-project/tracegram-pilot/data/ \
    ~/Documents/GitHub/phd-project/tracegram-pilot/data/

# DANGER

## Pull from share
rsync -anv --no-whole-file --delete --exclude '*.DS_Store' \
    /Volumes/Phonology/Common/ \
    ~/Documents/GitHub/phd-project/
rsync -avz --no-whole-file --delete --exclude '*.DS_Store' \
    /Volumes/Phonology/Common/ \
    ~/Documents/GitHub/phd-project/
