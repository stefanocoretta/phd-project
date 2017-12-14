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

## Push data folder to external HD

### Test
rsync -anv --no-whole-file --delete --exclude '*.DS_Store' \
    ~/Documents/GitHub/phd-project/voicing-effect/data/ \
    /Volumes/Multimedia/phd-project/voicing-effect/data
rsync -anv --no-whole-file --delete --exclude '*.DS_Store' \
    ~/Documents/GitHub/phd-project/tracegram-prepilot/data/ \
    /Volumes/Multimedia/phd-project/tracegram-prepilot/data
rsync -anv --no-whole-file --delete --exclude '*.DS_Store' \
    ~/Documents/GitHub/phd-project/tracegram-pilot/data/ \
    /Volumes/Multimedia/phd-project/tracegram-pilot/data
rsync -anv --no-whole-file --delete --exclude '*.DS_Store' \
    ~/Documents/GitHub/phd-project/lombard/data/ \
    /Volumes/Multimedia/phd-project/lombard/data

### Run
rsync -avz --no-whole-file --delete --exclude '*.DS_Store' \
    ~/Documents/GitHub/phd-project/voicing-effect/data/ \
    /Volumes/Multimedia/phd-project/voicing-effect/data/
rsync -avz --no-whole-file --delete --exclude '*.DS_Store' \
    ~/Documents/GitHub/phd-project/tracegram-prepilot/data/ \
    /Volumes/Multimedia/phd-project/tracegram-prepilot/data/
rsync -avz --no-whole-file --delete --exclude '*.DS_Store' \
    ~/Documents/GitHub/phd-project/tracegram-pilot/data/ \
    /Volumes/Multimedia/phd-project/tracegram-pilot/data/
rsync -avz --no-whole-file --delete --exclude '*.DS_Store' \
    ~/Documents/GitHub/phd-project/lombard/data/ \
    /Volumes/Multimedia/phd-project/lombard/data/

## Pull data folder from external HD

rsync -anv --no-whole-file --delete --exclude '*.DS_Store' \
    /Volumes/Multimedia/phd-project/voicing-effect/data/ \
    ~/Documents/GitHub/phd-project/voicing-effect/data
rsync -anv --no-whole-file --delete --exclude '*.DS_Store' \
    /Volumes/Multimedia/phd-project/tracegram-prepilot/data/ \
    ~/Documents/GitHub/phd-project/tracegram-prepilot/data
rsync -anv --no-whole-file --delete --exclude '*.DS_Store' \
    /Volumes/Multimedia/phd-project/tracegram-pilot/data/ \
    ~/Documents/GitHub/phd-project/tracegram-pilot/data
rsync -anv --no-whole-file --delete --exclude '*.DS_Store' \
    /Volumes/Multimedia/phd-project/lombard/data/ \
    ~/Documents/GitHub/phd-project/lombard/data

rsync -avz --no-whole-file --delete --exclude '*.DS_Store' \
    /Volumes/Multimedia/phd-project/voicing-effect/data/ \
    ~/Documents/GitHub/phd-project/voicing-effect/data/
rsync -avz --no-whole-file --delete --exclude '*.DS_Store' \
    /Volumes/Multimedia/phd-project/tracegram-prepilot/data/ \
    ~/Documents/GitHub/phd-project/tracegram-prepilot/data/
rsync -avz --no-whole-file --delete --exclude '*.DS_Store' \
    /Volumes/Multimedia/phd-project/tracegram-pilot/data/ \
    ~/Documents/GitHub/phd-project/tracegram-pilot/data/
rsync -avz --no-whole-file --delete --exclude '*.DS_Store' \
    /Volumes/Multimedia/phd-project/lombard/data/ \
    ~/Documents/GitHub/phd-project/lombard/data/

# DANGER

## Pull from share
rsync -anv --no-whole-file --delete --exclude '*.DS_Store' \
    /Volumes/Phonology/Common/ \
    ~/Documents/GitHub/phd-project/
rsync -avz --no-whole-file --delete --exclude '*.DS_Store' \
    /Volumes/Phonology/Common/ \
    ~/Documents/GitHub/phd-project/

## Push to external HD
rsync -anv --no-whole-file --delete --exclude '*.DS_Store' \
    --exclude '.Rproj.user' --exclude '.git' \
    ~/Documents/GitHub/phd-project/ \
    /Volumes/Multimedia/phd-project/
rsync -avz --no-whole-file --delete --exclude '*.DS_Store' \
    --exclude '.Rproj.user' --exclude '.git' \
    ~/Documents/GitHub/phd-project/ \
    /Volumes/Multimedia/phd-project/
