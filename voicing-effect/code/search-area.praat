######################################
# This is a script from the project 'Vowel duration and consonant voicing: An
# articulatory study', Stefano Coretta
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

form Select folder with TextGrid
    word speaker it01
    comment Supported languages: it, pl
    word language it
endform

if language$ == "it"
    label_lang$ = "k"
    label_2_lang$ = "dico"
elif language$ == "pl"
    label_lang$ = "j"
    label_2_lang$ = "mowie"
else
    exit "The language you selected is not valid"
endif

directory_audio$ = "../data/ultrasound/derived/'speaker$'/recordings"
directory_alignment$ = "../data/ultrasound/derived/
    ...'speaker$'/concatenated"
directory_palign$ = "../data/ultrasound/raw/corrected-palign"

palign_original = Read from file: "'directory_palign$'/'speaker$'-palign.TextGrid"
palign = Read from file: "'directory_palign$'/'speaker$'-palign.TextGrid"
selectObject: palign

intervals = Get number of intervals: 1

Insert interval tier: 4, "ultrasound"
Insert interval tier: 5, "kinematics"
Insert interval tier: 6, "vowel"

for interval to intervals
    label$ = Get label of interval: 1, interval
    if label$ == label_lang$
        start_ultrasound = Get start time of interval: 1, interval
        interval_2 = Get interval at time: 2, start_ultrasound
        label_2$ = Get label of interval: 2, interval_2
        if label_2$ == label_2_lang$
            end_ultrasound = Get end time of interval: 1, interval + 7
            Insert boundary: 4, start_ultrasound
            Insert boundary: 4, end_ultrasound
            ultrasound = Get interval at time: 4, start_ultrasound
            Set interval text: 4, ultrasound, "ultrasound"

            start_kinematics = Get start time of interval: 1, interval + 3
            end_kinematics = Get end time of interval: 1, interval + 5
            start_vowel = Get start time of interval: 1, interval + 3
            end_vowel = Get end time of interval: 1, interval + 3

            if label_2$ == "dico"
                start_kinematics = ((end_vowel - start_kinematics) / 2) +
                    ...start_kinematics
                start_vowel_2 = Get start time of interval: 1, interval + 5
                end_kinematics = ((end_kinematics - start_vowel_2) / 2) +
                    ...start_vowel_2
            endif

            Insert boundary: 5, start_kinematics
            Insert boundary: 5, end_kinematics
            kinematics = Get interval at time: 5, start_kinematics
            Set interval text: 5, kinematics, "kinematics"

            vowel$ = Get label of interval: 1, interval + 3
            Insert boundary: 6, start_vowel
            Insert boundary: 6, end_vowel
            vowel_interval = Get interval at time: 6, start_vowel
            Set interval text: 6, vowel_interval, vowel$
        endif
    endif
endfor

Remove tier: 1
Remove tier: 1
Remove tier: 1

Save as text file: "'directory_alignment$'/'speaker$'-search.TextGrid"

filenames = Read from file: "'directory_alignment$'/'speaker$'-filenames.TextGrid"

selectObject: palign
plusObject: filenames

Merge

filenames_tier = 4

intervals = Get number of intervals: filenames_tier

for interval from 1 to intervals
    selectObject: "TextGrid merged"
    start = Get start point: filenames_tier, interval
    end  = Get end point: filenames_tier, interval
    filename$ = Get label of interval: filenames_tier, interval

    Extract part: start, end, "no"

    Remove tier: filenames_tier
    Write to text file: "'directory_audio$'/'filename$'.TextGrid"
    Remove

    selectObject: palign_original
    Extract part: start, end, "no"
    Write to text file: "'directory_audio$'/'filename$'-palign.TextGrid"
    Remove
endfor
