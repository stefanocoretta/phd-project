#!/bin/bash

# Share

## Push to share
rsync -anv --no-whole-file --delete --exclude '*.DS_Store' \
    ~/GitHub/phd-project/ \
    /Volumes/Phonology/Common/
rsync -avz --no-whole-file --delete --exclude '*.DS_Store' \
    ~/GitHub/phd-project/ \
    /Volumes/Phonology/Common/

# Backup

## Push data folder to external HD

### Test
rsync -anv --no-whole-file --delete --exclude '*.DS_Store' \
    ~/GitHub/phd-project/voicing-effect/data/ \
    /Volumes/Multimedia/ling-data-backup/phd-project/voicing-effect/data
rsync -anv --no-whole-file --delete --exclude '*.DS_Store' \
    ~/GitHub/phd-project/tracegram-prepilot/data/ \
    /Volumes/Multimedia/ling-data-backup/phd-project/tracegram-prepilot/data
rsync -anv --no-whole-file --delete --exclude '*.DS_Store' \
    ~/GitHub/phd-project/tracegram-pilot/data/ \
    /Volumes/Multimedia/ling-data-backup/phd-project/tracegram-pilot/data
rsync -anv --no-whole-file --delete --exclude '*.DS_Store' \
    ~/GitHub/phd-project/lombard/data/ \
    /Volumes/Multimedia/ling-data-backup/phd-project/lombard/data
rsync -anv --no-whole-file --delete --exclude '*.DS_Store' \
    ~/GitHub/phd-project/perceptual-pilot/data/ \
    /Volumes/Multimedia/ling-data-backup/phd-project/perceptual-pilot/data
rsync -anv --no-whole-file --delete --exclude '*.DS_Store' \
    ~/GitHub/phd-project/english/data/ \
    /Volumes/Multimedia/ling-data-backup/phd-project/english/data

### Run
rsync -avz --no-whole-file --delete --exclude '*.DS_Store' \
    ~/GitHub/phd-project/voicing-effect/data/ \
    /Volumes/Multimedia/ling-data-backup/phd-project/voicing-effect/data/
rsync -avz --no-whole-file --delete --exclude '*.DS_Store' \
    ~/GitHub/phd-project/tracegram-prepilot/data/ \
    /Volumes/Multimedia/ling-data-backup/phd-project/tracegram-prepilot/data/
rsync -avz --no-whole-file --delete --exclude '*.DS_Store' \
    ~/GitHub/phd-project/tracegram-pilot/data/ \
    /Volumes/Multimedia/ling-data-backup/phd-project/tracegram-pilot/data/
rsync -avz --no-whole-file --delete --exclude '*.DS_Store' \
    ~/GitHub/phd-project/lombard/data/ \
    /Volumes/Multimedia/ling-data-backup/phd-project/lombard/data/
rsync -avz --no-whole-file --delete --exclude '*.DS_Store' \
    ~/GitHub/phd-project/perceptual-pilot/data/ \
    /Volumes/Multimedia/ling-data-backup/phd-project/perceptual-pilot/data
rsync -avz --no-whole-file --delete --exclude '*.DS_Store' \
    ~/GitHub/phd-project/english/data/ \
    /Volumes/Multimedia/ling-data-backup/phd-project/english/data

## Pull data folder from external HD

rsync -anv --no-whole-file --delete --exclude '*.DS_Store' \
    /Volumes/Multimedia/ling-data-backup/phd-project/voicing-effect/data/ \
    ~/GitHub/phd-project/voicing-effect/data
rsync -anv --no-whole-file --delete --exclude '*.DS_Store' \
    /Volumes/Multimedia/ling-data-backup/phd-project/tracegram-prepilot/data/ \
    ~/GitHub/phd-project/tracegram-prepilot/data
rsync -anv --no-whole-file --delete --exclude '*.DS_Store' \
    /Volumes/Multimedia/ling-data-backup/phd-project/tracegram-pilot/data/ \
    ~/GitHub/phd-project/tracegram-pilot/data
rsync -anv --no-whole-file --delete --exclude '*.DS_Store' \
    /Volumes/Multimedia/ling-data-backup/phd-project/lombard/data/ \
    ~/GitHub/phd-project/lombard/data
rsync -anv --no-whole-file --delete --exclude '*.DS_Store' \
    /Volumes/Multimedia/ling-data-backup/phd-project/perceptual-pilot/data/ \
    ~/GitHub/phd-project/perceptual-pilot/data
rsync -anv --no-whole-file --delete --exclude '*.DS_Store' \
    /Volumes/Multimedia/ling-data-backup/phd-project/english/data/ \
    ~/GitHub/phd-project/english/data

rsync -avz --no-whole-file --delete --exclude '*.DS_Store' \
    /Volumes/Multimedia/ling-data-backup/phd-project/voicing-effect/data/ \
    ~/GitHub/phd-project/voicing-effect/data/
rsync -avz --no-whole-file --delete --exclude '*.DS_Store' \
    /Volumes/Multimedia/ling-data-backup/phd-project/tracegram-prepilot/data/ \
    ~/GitHub/phd-project/tracegram-prepilot/data/
rsync -avz --no-whole-file --delete --exclude '*.DS_Store' \
    /Volumes/Multimedia/ling-data-backup/phd-project/tracegram-pilot/data/ \
    ~/GitHub/phd-project/tracegram-pilot/data/
rsync -avz --no-whole-file --delete --exclude '*.DS_Store' \
    /Volumes/Multimedia/ling-data-backup/phd-project/lombard/data/ \
    ~/GitHub/phd-project/lombard/data/
rsync -avz --no-whole-file --delete --exclude '*.DS_Store' \
    /Volumes/Multimedia/ling-data-backup/phd-project/perceptual-pilot/data/ \
    ~/GitHub/phd-project/perceptual-pilot/data
rsync -avz --no-whole-file --delete --exclude '*.DS_Store' \
    /Volumes/Multimedia/ling-data-backup/phd-project/english/data/ \
    ~/GitHub/phd-project/english/data/

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
