#!/bin/bash

# directory  = copy both directory and content
# directory/ = copy only content

# Backup

## Push data folder to external HD

### Test

subdirs=(coretta2018itapol/data-raw/data
coretta2019eng/data-raw/data
coretta2017egg/data-raw/data
coretta2018itaegg/data-raw/data
phd-project/italian-polish/analysis/cache
phd-project/tracegram-prepilot/data
phd-project/lombard/data
phd-project/perceptual-pilot/data
phd-project/english-pilot/data
phd-project/perceptual/data
phd-project/icelandic/data
phd-project/italian-sz/data
phd-project/english/analysis/cache
phd-project/english-ve-meta/data
phd-project/american-english/data)

for dirs in ${subdirs[*]}
do
  echo ==== $dirs
  rsync -anv --no-whole-file --delete --exclude '*.DS_Store' \
      ~/GitHub/$dirs/ \
      /Volumes/Seagate/language-data/phd-project/$dirs
  echo
done

### Run

subdirs=(coretta2018itapol/data-raw/data
coretta2019eng/data-raw/data
coretta2017egg/data-raw/data
coretta2018itaegg/data-raw/data
phd-project/italian-polish/analysis/cache
phd-project/tracegram-prepilot/data
phd-project/lombard/data
phd-project/perceptual-pilot/data
phd-project/english-pilot/data
phd-project/perceptual/data
phd-project/icelandic/data
phd-project/italian-sz/data
phd-project/english/analysis/cache
phd-project/english-ve-meta/data
phd-project/american-english/data)

for dirs in ${subdirs[*]}
do
  echo ==== $dirs
  rsync -avz --no-whole-file --delete --exclude '*.DS_Store' \
      ~/GitHub/$dirs/ \
      /Volumes/Seagate/language-data/phd-project/$dirs
  echo
done

## Pull data folder from external HD

### Test

subdirs=(coretta2018itapol/data-raw/data
coretta2019eng/data-raw/data
coretta2017egg/data-raw/data
coretta2018itaegg/data-raw/data
phd-project/italian-polish/analysis/cache
phd-project/tracegram-prepilot/data
phd-project/lombard/data
phd-project/perceptual-pilot/data
phd-project/english-pilot/data
phd-project/perceptual/data
phd-project/icelandic/data
phd-project/italian-sz/data
phd-project/english/analysis/cache
phd-project/english-ve-meta/data
phd-project/american-english/data)

for dirs in ${subdirs[*]}
do
  echo ==== $dirs
  rsync -anv --no-whole-file --delete --exclude '*.DS_Store' \
      /Volumes/Seagate/language-data/phd-project/$dirs/ \
      ~/GitHub/$dirs
  echo
done

### Run

subdirs=(coretta2018itapol/data-raw/data
coretta2019eng/data-raw/data
coretta2017egg/data-raw/data
coretta2018itaegg/data-raw/data
phd-project/italian-polish/analysis/cache
phd-project/tracegram-prepilot/data
phd-project/lombard/data
phd-project/perceptual-pilot/data
phd-project/english-pilot/data
phd-project/perceptual/data
phd-project/icelandic/data
phd-project/italian-sz/data
phd-project/english/analysis/cache
phd-project/english-ve-meta/data
phd-project/american-english/data)

for dirs in ${subdirs[*]}
do
  echo ==== $dirs
  rsync -avz --no-whole-file --delete --exclude '*.DS_Store' \
      /Volumes/Seagate/language-data/phd-project/$dirs/ \
      ~/GitHub/$dirs
  echo
done

# Share

## Push to share

subdirs='phd-project coretta2018itapol coretta2017egg coretta2018itaegg coretta2019eng'

for dirs in ${subdirs[*]}
do
  echo ==== $dirs
  rsync -anv --no-whole-file --delete --exclude '*.DS_Store' --exclude '.Rproj.user' \
    ~/GitHub/$dirs/ \
    /Volumes/Phonology/Common/stefano-phd/$dirs
done

subdirs='phd-project coretta2018itapol coretta2017egg coretta2018itaegg coretta2019eng'

for dirs in ${subdirs[*]}
do
  echo ==== $dirs
  rsync -avz --no-whole-file --delete --exclude '*.DS_Store' --exclude '.Rproj.user' \
    ~/GitHub/$dirs/ \
    /Volumes/Phonology/Common/stefano-phd/$dirs
done
