######################################
# This is a script from the project 'Vowel duration and consonant voicing: An
# articulatory study', Stefano Coretta
######################################
# MIT License
#
# Copyright (c) 2016-2018 Stefano Coretta
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

form Ultrasound search intervals
    word speaker en01
endform

directory_recordings$ = "../data/ultrasound/derived/'speaker$'/recordings"
directory_concatenated$ = "../data/ultrasound/derived/
    ...'speaker$'/concatenated"
directory_corrected$ = "../data/ultrasound/raw/corrected-textgrids"

palign = Read from file: "'directory_corrected$'/'speaker$'-palign.TextGrid"
# Activity tier: 3
intervals = Get number of intervals: 3

Insert interval tier: 4, "ultrasound"
ultrasound_tier = 4
Insert interval tier: 5, "consonants"
consonants_tier = 5

for interval from 1 to intervals
  activity$ = Get label of interval: 3, interval

  if activity$ == "speech"
    speech_start = Get start time of interval: 3, interval
    phone_index = Get interval at time: 1, speech_start
    # "ultrasound" interval starts at the start of "@U" (3rd phone)
    ultrasound_start = Get start time of interval: 1, phone_index + 2
    # "ultrasound" interval end at the end of "@" (11th phone)
    ultrasound_end = Get end time of interval: 1, phone_index + 11

    # Ultrasound tier
    Insert boundary: ultrasound_tier, ultrasound_start
    Insert boundary: ultrasound_tier, ultrasound_end
    ultrasound_index = Get interval at time: ultrasound_tier, ultrasound_start
    Set interval text: ultrasound_tier, ultrasound_index, "ultrasound"

    # "c1" 7th phone
    c1_start = Get start time of interval: 1, phone_index + 6
    c1_end = Get end time of interval: 1, phone_index + 6
    # "v1" 8th phone
    v1_start = Get start time of interval: 1, phone_index + 7
    v1_end = Get end time of interval: 1, phone_index + 7
    # "c2" 9th phone
    c2_start = Get start time of interval: 1, phone_index + 8
    c2_end = Get end time of interval: 1, phone_index + 8

    # Consonants tier
    Insert boundary: consonants_tier, c1_start
    Insert boundary: consonants_tier, c1_end
    c1_index = Get interval at time: consonants_tier, c1_start
    Set interval text: 5, c1_index, "c1"

    Insert boundary: consonants_tier, c2_start
    Insert boundary: consonants_tier, c2_end
    c2_index = Get interval at time: 5, c2_start
    Set interval text: 5, c2_index, "c2"

    Set interval text: 5, c1_index + 1, "v1"

  endif

endfor

Remove tier: 1 ; phones
Remove tier: 1 ; words
Remove tier: 1 ; activity

Save as text file: "'directory_concatenated$'/'speaker$'-search.TextGrid"

filenames = Read from file: "'directory_concatenated$'/'speaker$'-filenames.TextGrid"

selectObject: palign ; now it only has the search interval tiers
plusObject: filenames

Merge

filenames_tier = 3

intervals = Get number of intervals: filenames_tier

for interval from 1 to intervals
    selectObject: "TextGrid merged"
    start = Get start point: filenames_tier, interval
    end  = Get end point: filenames_tier, interval
    file_name$ = Get label of interval: filenames_tier, interval

    Extract part: start, end, "no"

    Remove tier: filenames_tier
    Write to text file: "'directory_recordings$'/'file_name$'.TextGrid"
    Remove
endfor
