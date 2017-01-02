######################################
# 
######################################
# MIT License
#
# Copyright (c) 2016 Stefano Coretta
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
######################################
# This script reads from a TextGrid file and generates a new TextGrid with the
# search area for AAA. The search area is "-co ... le-".
######################################

form Select folder with TextGrid
    word directory /Volumes/humrss$/Common/data/pilot/ultrasound/SC01/audio
    word speaker SC
    word language it
endform

Read from file: "'directory$'/alignment/'speaker$'-palign.TextGrid"

intervals = Get number of intervals: 1

Insert interval tier: 4, "ultrasound"
Insert interval tier: 5, "kinematics"

if language$ == "it"
    label_lang$ = "k"
    label_2_lang$ = "dico"
elif language == "pl"
    label_lang$ = "j"
    label_2_lang$ = "móvię"
else
    exit "The language you selected is not valid"
endif

for interval to intervals
    label$ = Get label of interval: 1, interval
    if label$ == label_lang$
        start_ultrasound = Get starting point: 1, interval
        interval_2 = Get interval at time: 2, start_ultrasound
        label_2$ = Get label of interval: 2, interval_2
        if label_2$ == label_2_lang$
            end_ultrasound = Get end point: 1, interval + 7
            Insert boundary: 4, start_ultrasound
            Insert boundary: 4, end_ultrasound
            ultrasound = Get interval at time: 4, start_ultrasound
            Set interval text: 4, ultrasound, "ultrasound"

            start_kinematics_1 = Get start point: 1, interval + 3
            start_kinematics_2 = Get end point: 1, interval + 3
            start_kinematics = start_kinematics_1 + ((start_kinematics_2 - start_kinematics_1) / 2)
            end_kinematics_1 = Get start point: 1, interval + 5
            end_kinematics_2 = Get end point: 1, interval + 5
            end_kinematics = end_kinematics_1 + ((end_kinematics_2 - end_kinematics_1) / 2)
            Insert boundary: 5, start_kinematics
            Insert boundary: 5, end_kinematics
            kinematics = Get interval at time: 5, start_kinematics
            Set interval text: 5, kinematics, "kinematics"
        endif
    endif
endfor

Remove tier: 1
Remove tier: 1
Remove tier: 1

Save as text file: "'directory$'/alignment/search.TextGrid"

Remove

search = Read from file: "'directory$'/alignment/search.TextGrid"
filenames = Read from file: "'directory$'/alignment/'speaker$'_filenames.TextGrid"
filenames_tier = 3

select search
plus filenames

Merge

intervals = Get number of intervals: filenames_tier

for interval from 1 to intervals
    select TextGrid merged
    start = Get start point: filenames_tier, interval
    end  = Get end point: filenames_tier, interval
    filename$ = Get label of interval: filenames_tier, interval

    Extract part: start, end, "no"

    Genericize
    Remove tier: 3
    Write to text file: "'directory$'/'filename$'.TextGrid"
    Remove
endfor
