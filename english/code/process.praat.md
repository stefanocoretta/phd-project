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


## Script headers

### "script header"
```praat
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
```
