#!/bin/bash

# Share

## Push to share
rsync -anv --no-whole-file --delete --exclude '*.DS_Store' \
    ~/GitHub/phd-project/ \
    /Volumes/Phonology/Common/stefano-phd
rsync -avz --no-whole-file --delete --exclude '*.DS_Store' \
    ~/GitHub/phd-project/ \
    /Volumes/Phonology/Common/stefano-phd

# Backup

## Push data folder to external HD

### Test
rsync -anv --no-whole-file --delete --exclude '*.DS_Store' \
    ~/GitHub/phd-project/voicing-effect/data/ \
    /Volumes/Seagate/language-data/phd-project/voicing-effect/data
rsync -anv --no-whole-file --delete --exclude '*.DS_Store' \
    ~/GitHub/phd-project/tracegram-prepilot/data/ \
    /Volumes/Seagate/language-data/phd-project/tracegram-prepilot/data
rsync -anv --no-whole-file --delete --exclude '*.DS_Store' \
    ~/GitHub/phd-project/tracegram-pilot/data/ \
    /Volumes/Seagate/language-data/phd-project/tracegram-pilot/data
rsync -anv --no-whole-file --delete --exclude '*.DS_Store' \
    ~/GitHub/phd-project/lombard/data/ \
    /Volumes/Seagate/language-data/phd-project/lombard/data
rsync -anv --no-whole-file --delete --exclude '*.DS_Store' \
    ~/GitHub/phd-project/perceptual-pilot/data/ \
    /Volumes/Seagate/language-data/phd-project/perceptual-pilot/data
rsync -anv --no-whole-file --delete --exclude '*.DS_Store' \
    ~/GitHub/phd-project/english-pilot/data/ \
    /Volumes/Seagate/language-data/phd-project/english-pilot/data
rsync -anv --no-whole-file --delete --exclude '*.DS_Store' \
    ~/GitHub/phd-project/perceptual/data/ \
    /Volumes/Seagate/language-data/phd-project/perceptual/data
rsync -anv --no-whole-file --delete --exclude '*.DS_Store' \
    ~/GitHub/phd-project/italian-egg/data/ \
    /Volumes/Seagate/language-data/phd-project/italian-egg/data
rsync -anv --no-whole-file --delete --exclude '*.DS_Store' \
    ~/GitHub/phd-project/icelandic/data/ \
    /Volumes/Seagate/language-data/phd-project/icelandic/data
rsync -anv --no-whole-file --delete --exclude '*.DS_Store' \
    ~/GitHub/phd-project/italian-sz/data/ \
    /Volumes/Seagate/language-data/phd-project/italian-sz/data

### Run
rsync -avz --no-whole-file --delete --exclude '*.DS_Store' \
    ~/GitHub/phd-project/voicing-effect/data/ \
    /Volumes/Seagate/language-data/phd-project/voicing-effect/data/
rsync -avz --no-whole-file --delete --exclude '*.DS_Store' \
    ~/GitHub/phd-project/tracegram-prepilot/data/ \
    /Volumes/Seagate/language-data/phd-project/tracegram-prepilot/data/
rsync -avz --no-whole-file --delete --exclude '*.DS_Store' \
    ~/GitHub/phd-project/tracegram-pilot/data/ \
    /Volumes/Seagate/language-data/phd-project/tracegram-pilot/data/
rsync -avz --no-whole-file --delete --exclude '*.DS_Store' \
    ~/GitHub/phd-project/lombard/data/ \
    /Volumes/Seagate/language-data/phd-project/lombard/data/
rsync -avz --no-whole-file --delete --exclude '*.DS_Store' \
    ~/GitHub/phd-project/perceptual-pilot/data/ \
    /Volumes/Seagate/language-data/phd-project/perceptual-pilot/data
rsync -avz --no-whole-file --delete --exclude '*.DS_Store' \
    ~/GitHub/phd-project/english-pilot/data/ \
    /Volumes/Seagate/language-data/phd-project/english-pilot/data
rsync -avz --no-whole-file --delete --exclude '*.DS_Store' \
    ~/GitHub/phd-project/perceptual/data/ \
    /Volumes/Seagate/language-data/phd-project/perceptual/data
rsync -avz --no-whole-file --delete --exclude '*.DS_Store' \
    ~/GitHub/phd-project/italian-egg/data/ \
    /Volumes/Seagate/language-data/phd-project/italian-egg/data
rsync -avz --no-whole-file --delete --exclude '*.DS_Store' \
    ~/GitHub/phd-project/icelandic/data/ \
    /Volumes/Seagate/language-data/phd-project/icelandic/data
rsync -avz --no-whole-file --delete --exclude '*.DS_Store' \
    ~/GitHub/phd-project/italian-sz/data/ \
    /Volumes/Seagate/language-data/phd-project/italian-sz/data

## Pull data folder from external HD

rsync -anv --no-whole-file --delete --exclude '*.DS_Store' \
    /Volumes/Seagate/language-data/phd-project/voicing-effect/data/ \
    ~/GitHub/phd-project/voicing-effect/data
rsync -anv --no-whole-file --delete --exclude '*.DS_Store' \
    /Volumes/Seagate/language-data/phd-project/tracegram-prepilot/data/ \
    ~/GitHub/phd-project/tracegram-prepilot/data
rsync -anv --no-whole-file --delete --exclude '*.DS_Store' \
    /Volumes/Seagate/language-data/phd-project/tracegram-pilot/data/ \
    ~/GitHub/phd-project/tracegram-pilot/data
rsync -anv --no-whole-file --delete --exclude '*.DS_Store' \
    /Volumes/Seagate/language-data/phd-project/lombard/data/ \
    ~/GitHub/phd-project/lombard/data
rsync -anv --no-whole-file --delete --exclude '*.DS_Store' \
    /Volumes/Seagate/language-data/phd-project/perceptual-pilot/data/ \
    ~/GitHub/phd-project/perceptual-pilot/data
rsync -anv --no-whole-file --delete --exclude '*.DS_Store' \
    /Volumes/Seagate/language-data/phd-project/english-pilot/data/ \
    ~/GitHub/phd-project/english-pilot/data
rsync -anv --no-whole-file --delete --exclude '*.DS_Store' \
    /Volumes/Seagate/language-data/phd-project/perceptual/data/ \
    ~/GitHub/phd-project/perceptual/data
rsync -anv --no-whole-file --delete --exclude '*.DS_Store' \
    /Volumes/Seagate/language-data/phd-project/italian-egg/data/ \
    ~/GitHub/phd-project/italian-egg/data
rsync -anv --no-whole-file --delete --exclude '*.DS_Store' \
    /Volumes/Seagate/language-data/phd-project/icelandic/data/ \
    ~/GitHub/phd-project/icelandic/data

rsync -avz --no-whole-file --delete --exclude '*.DS_Store' \
    /Volumes/Seagate/language-data/phd-project/voicing-effect/data/ \
    ~/GitHub/phd-project/voicing-effect/data/
rsync -avz --no-whole-file --delete --exclude '*.DS_Store' \
    /Volumes/Seagate/language-data/phd-project/tracegram-prepilot/data/ \
    ~/GitHub/phd-project/tracegram-prepilot/data/
rsync -avz --no-whole-file --delete --exclude '*.DS_Store' \
    /Volumes/Seagate/language-data/phd-project/tracegram-pilot/data/ \
    ~/GitHub/phd-project/tracegram-pilot/data/
rsync -avz --no-whole-file --delete --exclude '*.DS_Store' \
    /Volumes/Seagate/language-data/phd-project/lombard/data/ \
    ~/GitHub/phd-project/lombard/data/
rsync -avz --no-whole-file --delete --exclude '*.DS_Store' \
    /Volumes/Seagate/language-data/phd-project/perceptual-pilot/data/ \
    ~/GitHub/phd-project/perceptual-pilot/data
rsync -avz --no-whole-file --delete --exclude '*.DS_Store' \
    /Volumes/Seagate/language-data/phd-project/english-pilot/data/ \
    ~/GitHub/phd-project/english-pilot/data/
rsync -avz --no-whole-file --delete --exclude '*.DS_Store' \
    /Volumes/Seagate/language-data/phd-project/perceptual/data/ \
    ~/GitHub/phd-project/perceptual/data/
rsync -avz --no-whole-file --delete --exclude '*.DS_Store' \
    /Volumes/Seagate/language-data/phd-project/italian-egg/data/ \
    ~/GitHub/phd-project/italian-egg/data/
rsync -avz --no-whole-file --delete --exclude '*.DS_Store' \
    /Volumes/Seagate/language-data/phd-project/icelandic/data/ \
    ~/GitHub/phd-project/icelandic/data/

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
