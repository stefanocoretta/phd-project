#!/bin/bash

# Pull from share
rsync -anv --no-whole-file --exclude '*.DS_Store' /Volumes/Phonology/Common/ \
    ~/Documents/GitHub/phd-project/
rsync -avz --no-whole-file --exclude '*.DS_Store' /Volumes/Phonology/Common/ \
    ~/Documents/GitHub/phd-project/

# Copy to external hard disk
rsync -anv --no-whole-file --exclude '*.DS_Store' ~/Documents/GitHub/phd-project/ \
    /Volumes/Backup/phd-project/
rsync -avz --no-whole-file --exclude '*.DS_Store' ~/Documents/GitHub/phd-project/ \
    /Volumes/Backup/phd-project/
