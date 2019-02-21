#!/bin/bash

# Backup

## Push data folder to external HD

### Test

subdirs='voicing-effect tracegram-prepilot tracegram-pilot lombard perceptual-pilot english-pilot perceptual italian-egg icelandic italian-sz english english-ve-meta american-english'

for dirs in ${subdirs[*]}
do
  echo ==== $dirs
  rsync -anv --no-whole-file --delete --exclude '*.DS_Store' \
      ~/GitHub/phd-project/$dirs/data/ \
      /Volumes/Seagate/language-data/phd-project/$dirs/data
  echo
done

### Run

subdirs='voicing-effect tracegram-prepilot tracegram-pilot lombard perceptual-pilot english-pilot perceptual italian-egg icelandic italian-sz english english-ve-meta american-english'

for dirs in ${subdirs[*]}
do
  echo ==== $dirs
  rsync -avz --no-whole-file --delete --exclude '*.DS_Store' \
      ~/GitHub/phd-project/$dirs/data/ \
      /Volumes/Seagate/language-data/phd-project/$dirs/data
  echo
done

## Pull data folder from external HD

### Test

subdirs='voicing-effect tracegram-prepilot tracegram-pilot lombard perceptual-pilot english-pilot perceptual italian-egg icelandic italian-sz english english-ve-meta american-english'

for dirs in ${subdirs[*]}
do
  echo ==== $dirs
  rsync -anv --no-whole-file --delete --exclude '*.DS_Store' \
      /Volumes/Seagate/language-data/phd-project/$dirs/data/ \
      ~/GitHub/phd-project/$dirs/data
  echo
done

### Run

subdirs='voicing-effect tracegram-prepilot tracegram-pilot lombard perceptual-pilot english-pilot perceptual italian-egg icelandic italian-sz english english-ve-meta american-english'

for dirs in ${subdirs[*]}
do
  echo ==== $dirs
  rsync -avz --no-whole-file --delete --exclude '*.DS_Store' \
      /Volumes/Seagate/language-data/phd-project/$dirs/data/ \
      ~/GitHub/phd-project/$dirs/data
  echo
done

# Share

## Push to share
rsync -anv --no-whole-file --delete --exclude '*.DS_Store' \
    ~/GitHub/phd-project/ \
    /Volumes/Phonology/Common/stefano-phd
rsync -avz --no-whole-file --delete --exclude '*.DS_Store' \
    ~/GitHub/phd-project/ \
    /Volumes/Phonology/Common/stefano-phd

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
