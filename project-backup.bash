#!/bin/bash

# Pull from share
rsync -anv --no-whole-file --exclude '*.DS_Store' /Volumes/Phonology/Common/ \
    ~/Documents/GitHub/phd-project/
rsync -avz --no-whole-file --exclude '*.DS_Store' /Volumes/Phonology/Common/ \
    ~/Documents/GitHub/phd-project/

# Push to share
rsync -anv --no-whole-file --exclude '*.DS_Store' ~/Documents/GitHub/phd-project/ \
    /Volumes/Phonology/Common/
rsync -avz --no-whole-file --exclude '*.DS_Store' ~/Documents/GitHub/phd-project/ \
    /Volumes/Phonology/Common/

# Copy to external hard disk
rsync -anv --no-whole-file --exclude '*.DS_Store' ~/Documents/GitHub/phd-project/ \
    /Volumes/Multimedia/phd-project/
rsync -avz --no-whole-file --exclude '*.DS_Store' ~/Documents/GitHub/phd-project/ \
    /Volumes/Multimedia/phd-project/

# Get data/ folder
rsync -anv --no-whole-file --exclude '*.DS_Store' /Volumes/Multimedia/phd-project/pilot/data/ \
    ~/Documents/GitHub/phd-project/pilot/data
rsync -avz --no-whole-file --exclude '*.DS_Store' /Volumes/Multimedia/phd-project/pilot/data/ \
    ~/Documents/GitHub/phd-project/pilot/data/
