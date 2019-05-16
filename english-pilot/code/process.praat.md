# Data processing for the study of English gestural timing

## Force alignment input

### alignment-input.praat
```praat
<<<script header>>>

<<<check objects>>>

<<<get recordings>>>

<<<concatenate recoverably>>>

<<<save input>>>
```

The script gets all the recordings of a speaker from `data/ultrasound/derived/ID/recordings/` (where `ID` is the participant ID) and it concatenates them in a single `.wav` file.
A `.TextGrid` file with intervals marking the individual recordings in the concatenated file and a `.txt` file with a list of the prompts is created as well.

### "check objects"
```praat
select all
number_selected = numberOfSelected ()
if number_selected > 0
    exitScript: "The Objects window is not empty. Please, remove the objects in the Objects window to run this script."
endif
```

### "get recordings"
```praat
form Generate input for force alignment with SPPAS
    word speaker en01
endform

directory_speaker$ = "../data/ultrasound/derived/'speaker$'"
directory_recordings$ = "'directory_speaker$'/recordings"
createDirectory("'directory_speaker$'/concatenated")
directory_concatenated$ = "'directory_speaker$'/concatenated"
# We need a .txt file with the list of prompts for alignment
writeFile: "'directory_concatenated$'/'speaker$'.txt", ""

file_list = Create Strings as file list: "filelist", "'directory_recordings$'/*.wav"
recordings = Get number of strings

for recording from 1 to recordings
    select Strings filelist
    file$ = Get string: recording
    Read from file: "'directory_recordings$'/'file$'"
    sound = selected("Sound")
    sound$ = file$ - ".wav"
endfor
```

The form asks for a speaker ID.
The `.wav` files from the `recordings` folder of that speaker are read in.

### "concatenate recoverably"
```praat
select all
minusObject: file_list
Concatenate recoverably
# A `Sound chain` and a `TextGrid chain` are created

selectObject: "TextGrid chain"

intervals = Get number of intervals: 1

for interval from 1 to intervals
    start = Get start point: 1, interval
    end  = Get end point: 1, interval
    file_name$ = Get label of interval: 1, interval

    # We need to get the prompts (sentences) to create a prompt list
    Read Strings from raw text file: "'directory_recordings$'/'file_name$'.txt"
    prompt$ = Get string: 1
    selectObject: "TextGrid chain"
    appendFileLine: "'directory_concatenated$'/'speaker$'.txt", "'prompt$'"
endfor
```

This chunk select all objects except the file list and concatenates the sound objects.
Then, the script loops through the intervals in the TextGrid which correspond to the names of the files and it gets the prompt from the corresponding `.txt` files in `recordings/`.

### "save input"
```praat
selectObject: "Sound chain"
Save as WAV file: "'directory_concatenated$'/'speaker$'.wav"

selectObject: "TextGrid chain"
Save as text file: "'directory_concatenated$'/'speaker$'-filenames.TextGrid"
```

Finally, the concatenated `.wav` files and the `.TextGrid` with the file names are saved in `concatenated/`.

## Ultrasound search intervals

### search-intervals.praat
```praat
<<<script header>>>

<<<get paling>>>

<<<set search>>>

<<<save search chunks>>>
```

### "get paling"
```praat
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
```

The user is prompt to indicate the participant ID.
Then the script read the TextGrid file with the corrected force alingment (`ID-palign.TextGrid`).
The number of intervals of the TextGrid file is saved in `intervals` and two new tiers are created (`ultrasound` and `consonants`).

### "set search"
```praat
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
```

Now we can create intervals cointaing the search intervals for ultrasound and kinematics which will be used in `AAA` for spline batch processing and to find consonantal gestures.
For each interval in the activity tier containing the text "speech", the script gets the index of the first phone in the sentence ("aI"), then gets the start time of "\@U" in "sold" and the end time of the "@" in "today" which correspond to the start and end of the "ultrasound" interval.
In the consonants tier, the intervals corresponding to C1, V1, and C2 are added.
A concatenated `[ID]-search.TextGrid` is saved in the `concatenated` folder.

### "save search chunks"
```praat
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
```

Individual search interval TextGrid chunks are saved in the `recordings` folder for import in `AAA`.

## Script headers

### "script header"
```praat
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
```
