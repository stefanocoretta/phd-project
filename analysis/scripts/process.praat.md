# Documentation of data processing

This file contains the documentation of the scripts in the `analysis/scripts` folder. The documentation has been written in literate markdown. To produce the scripts form the documentation, use the `lmt` package (written in Go by Dave MacFarlane, at https://github.com/driusan/lmt).

## Prepare files for force alignment in SPPAS

### alignment-input.praat
```praat
<<<get audio>>>

<<<concatenate recoverably>>>

<<<write sppas>>>
```

The following chunk asks the user for the name of the project directory and the participant ID. Then it reads the audio files from the `audio` directory (whih contains the audio files exported from `AAA`). The directory `alignment` is created as well.

### "get audio"
```praat
form Generate input for force alignment with SPPAS
    word project pilot
    word speaker SC01
endform

directory_speaker$ = "../../'project$'/data/derived/ultrasound/'speaker$'"
directory_audio$ = "'directory_speaker$'/audio"
createDirectory ("'directory_speaker$'/alignment")
directory_alignment$ = "'directory_speaker$'/alignment"
writeFile: "'directory_alignment$'/'speaker$'.txt", ""

Create Strings as file list: "filelist", "'directory_audio$'/*.wav"
files = Get number of strings

for file from 1 to files
    select Strings filelist
    file$ = Get string: file
    Read from file: "'directory_audio$'/'file$'"
    sound = selected("Sound")
    sound$ = file$ - ".wav"
endfor
```

The following select all objects except the file list and concatenates the sound objects. SPASS needs a tier named `Orthography`, so we create one. Then, the script loops through the intervals in the TextGrid which correspond to the names of the files, it writes the prompt in the interval and in the text file for IPU detection.

### "concatenate recoverably"
```praat
select all
minusObject: "Strings filelist"
Concatenate recoverably

selectObject: "TextGrid chain"
Duplicate tier: 1, 1, "Orthography"

intervals = Get number of intervals: 1

for interval from 1 to intervals
    start = Get start point: 1, interval
    end  = Get end point: 1, interval
    filename$ = Get label of interval: 1, interval

    Read Strings from raw text file: "'directory_audio$'/'filename$'.txt"
    prompt$ = Get string: 1
    selectObject: "TextGrid chain"
    Set interval text: 1, interval, "'prompt$'"
    appendFileLine: "'directory_alignment$'/'speaker$'.txt", "'prompt$'"
endfor
```

Finally, we can save the concatenated sound file and the TextGrid with the file names. The latter will be used in the script `search-area.praat` to separate the concatenated TextGrid.

### "write sppas"
```praat
selectObject: "Sound chain"
Save as WAV file: "'directory_alignment$'/'speaker$'.wav"

selectObject: "TextGrid chain"
Copy: "filenames"
Remove tier: 1
Save as text file: "'directory_alignment$'/'speaker$'-filenames.TextGrid"
```

## Extract the search area for spline batch processing and kinematics in `AAA`

### search-area.praat
```praat
<<<get alignment>>>

<<<set search>>>

<<<extract search>>>
```

The user is prompt to indicate the project name, the participant ID and the language. Depending on the language selected, the appropriate speech segments are stored for subsequent extraction of the search area. Then the script read the TextGrid file with the force alingment (`ID-palign.TextGrid`). The number of intervals of the TextGrid file is saved in `intervals` and two new tiers are created (`ultrasound` and `kinematics`)

### "get alignment"
```praat
form Select folder with TextGrid
    word project pilot
    word speaker SC01
    comment Supported languages: it, pl
    word language it
endform

if language$ == "it"
    label_lang$ = "k"
    label_2_lang$ = "dico"
elif language == "pl"
    label_lang$ = "j"
    label_2_lang$ = "móvię"
else
    exit "The language you selected is not valid"
endif

directory_audio$ = "../../'project$'/data/derived/ultrasound/'speaker$'/audio"
directory_alignment$ = "../../'project$'/data/derived/ultrasound/'speaker$'/alignment"

palign = Read from file: "'directory_alignment$'/'speaker$'-palign.TextGrid"

intervals = Get number of intervals: 1

Insert interval tier: 4, "ultrasound"
Insert interval tier: 5, "kinematics"
```

Now we can create intervals cointaing the search area for ultrasound and kinematics which will be used in `AAA` for spline batch processing and to find consonantal gestures moments. Then, `search.TextGrid` is saved in the `alignmet` folder.

### "set search"
```praat
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

            start_kinematics = Get start point: 1, interval + 3
            end_kinematics = Get start point: 1, interval + 6
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

Save as text file: "'directory_alignment$'/search.TextGrid"
```

Then, the script saves each search area to separate TextGrids in the `audio` folder. The file names are extracted from `ID-filenames.TextGrid`.

### "extract search"
```praat
filenames = Read from file: "'directory_alignment$'/'speaker$'-filenames.TextGrid"
filenames_tier = 3

selectObject: palign
plusObject: filenames

Merge

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
endfor
```

## Synchronise EGG data with `AAA` audio data

The following chunk calls the header of the script, which is defined at the end of the documentation, the padding function, and the main function.

### sync-egg.praat
```praat
<<<sync header>>>

<<<padding>>>

<<<sync function>>>
```

The following code creates a procedure called zeroPadding. The code is by Daniel Riggs and can be found at http://praatscriptingtutorial.com/procedures. The procedure allows automatic zero padding in file names with numeric indexes. For example: `Sound001.wav`, `Sound002.wav`, ..., `Sound010.wav`, ..., `Sound100.wav`.

### "padding"
```praat
procedure zeroPadding: .num, .numZeros
    .highestVal = 10 ^ .numZeros

    .num$ = string$: .num
    .numLen = length: .num$

    .numToAdd = .numZeros - .numLen

    .zeroPrefix$ = ""
    if .numToAdd > 0
        for i from 1 to .numToAdd
            .zeroPrefix$ = .zeroPrefix$ + "0"
        endfor
    endif

    .return$ = .zeroPrefix$ + .num$
endproc

```

The script works by selecting all the files in the Object window after loading files.

### "sync function"
```praat
<<<check objects>>>

<<<read files>>>

<<<sync>>>
```

Before running, the script checks if the objects list is empty. If not, the script exits and prompts the user to clean the objects list.

### "check objects"
```praat
select all
number_selected = numberOfSelected ()
if number_selected > 0
    exitScript: "Please, remove the objects in the Objects window. For this
    ... script to work, the Objects list must be empty."
endif
```

The form asks for the project name and the participant ID. A boolean is stored as well for enabling the debug mode. In the debug mode, all intermediate files produced by the script are kept in the Objects window. They are deleted otherwise.

### "read files"
```praat
form Syncronise EGG data
    word project pilot
    word speaker SC01
    boolean debug_mode
endform
```

The file lists of the EGG and ultrasound `.wav` files are saved in `filelist_egg` and `filelist_us`.
The number of files in the EGG folder is saved in `files`.

### "read files"+=
```praat
egg_directory$ = "../../'project$'/data/raw/egg"
us_directory$ = "../../'project$'/data/derived/ultrasound"
out_directory$ = "../../'project$'/data/derived/egg"
createDirectory ("'out_directory$'/'speaker$'")

Create Strings as file list: "filelist_egg", "'egg_directory$'/'speaker$'/*.wav"
files = Get number of strings
Create Strings as file list: "filelist_us", "'us_directory$'/'speaker$'/audio/*.wav"

```

For every file listed in `filelist_egg`, it reads the file.

### "read files"+=
```praat
for file from 1 to files
    select Strings filelist_egg
    file$ = Get string: file
    Read from file: "'egg_directory$'/'speaker$'/'file$'"
endfor

```

Every object is then selected, minus the two file lists. The Sounds are concatenated to `Sound chain`.

### "read files"+=
```praat
select all
minusObject: "Strings filelist_egg"
minusObject: "Strings filelist_us"
Concatenate
```

While `Sound chain` is selected, the script inverts the signal (both the audio and the EGG signal are inverted during acquisition with the Laryngograph), and extracts all channels (the object is a stereo sound: channel 1 is the audio, channel 2 is the EGG signal). For cross-correlation to work, the two sound files must have the same sampling frequency.
AAA records at a frequency of 22050 Hz. To ensure that the EGG audio is at the same sampling frequency, resampling is performed. `Sound chain_ch1_22050` is created from `Sound chain_ch1`.

### "read files"+=
```praat
Multiply: -1
Extract all channels

selectObject: "Sound chain_ch1"
Resample: 22050, 50
```

The extraction of each simulus from the concatenated sound is achieved through the EGG signal. The function `To TextGrid (silences)` efficiently recognises the voiced streaches of the audio which roughly corresponds to the spoken stimuli. (*Warning*: this assumes that the EGG files don't contain spurious material)
The minimum duration for silence is set to 1 second to avoid voiceless segments being annotated as silence. The output is `TextGrid chain_ch2`.
The number of intervals in the TextGrid is saved in the variable `intervals`.

### "sync"
```praat
selectObject: "Sound chain_ch2"

To TextGrid (silences): 100, 0, -25, 1, 0.1, "silence", "speech"
intervals = Get number of intervals: 1

```

For each interval in the `TextGrid chain_ch2` wich is labelled `speech`, the start and end time of the interval are moved by -1.5 and 1 second respectively. This ensures that there is enough audio before and after the stimulus for cross-correlation. The original left and right boundaries are removed. The result is that the interval label is changed to `speechsilence`.

### "sync"+=
```praat
for interval from 1 to intervals
    label$ = Get label of interval: 1, interval
    if label$ == "speech"
        start = Get starting point: 1, interval
        end = Get end point: 1, interval
        Insert boundary: 1, start - 1.5
        Insert boundary: 1, end + 1
        Remove left boundary: 1, interval + 1
        Remove right boundary: 1, interval
    endif
endfor

```

We can now get the number of intervals of the updated TextGrid and set the counter `index` to 1. The counter is used to read the ultrasound audio files, and in the names of the output files (it is feeded to the `zeroPadding` procedure to create sortable file names).

### "sync"+=
```praat
intervals = Get number of intervals: 1

index = 1

```

For every interval in the TextGrid it is checked if the label is `speechsilence`. The intervals with this label correspond to the individual stimuli in the concatenated EGG sound files. If the label is `speechsilence`, the script gets the start and end time of that interval.

### "sync"+=
```praat
for interval from 1 to intervals
    label$ = Get label of interval: 1, interval
    if label$ == "speechsilence"
        start = Get starting point: 1, interval
        end = Get end point: 1, interval

```

Then the resampled `Sound chain_ch1_22050` is selected and the portion from `start` to `end` is extracted. This portion corresponds to the TextGrid interval and, thus, to the stimulus. The sound is named `Sound chain_ch1_22050_part`.

#### "sync"+=
```praat
        selectObject: "Sound chain_ch1_22050"
        Extract part: start, end, "rectangular", 1, "no"

```

The counter `index` is now used to read the audio file from the ultrasound directory. Since the order of the stimuli is the same in both the EGG and unltrasound files, a counter that increases for every interval wth the `speechsilence` label is sufficient. The name of the file is saved after reading and the file remains selected.

### "sync"+=
```praat
        selectObject: "Strings filelist_us"
        file_us$ = Get string: index
        Read from file: "'us_directory$'/'speaker$'/audio/'file_us$'"
        file_us_name$ = selected$ ("Sound")

```

The extracted portion from the EGG audio channel is added to the selection. The cross-correlation between the EGG and ultrasound audio is performed. The time of maximum amplitude in the generated cross-correlated sound corresponds to the off-set between the two files.

### "sync"+=
```praat
        plusObject: "Sound chain_ch1_22050_part"

        Cross-correlate: "peak 0.99", "zero"
        offset = Get time of maximum: 0, 0, "Sinc70"

```

The concatenated stereo sound (or the recombined stereo if the `invert egg signal` option is active) is selected and a portion is extracted. The portion starting point corresponds to the starting point of the TextGrid interval minus the off-set obtained from the correlation. If the offset is positive (when the audio is longer than the EGG audio), silence is added at the beginning of the EGG sound. If the offset is negative (the EGG sound is longer than the audio), the extra part is deleted from the beginning of the EGG sound to match the beginning of the audio. The end point is the same as the one of the interval. (The endpoint does not matter, since timing is calculated from the beginning of the file.) The sound is finally saved in the `sync` folder.

### "sync"+=
```praat
        selectObject: "Sound chain"

        start = start - offset
        Extract part: start, end, "rectangular", 1, "no"
        @zeroPadding: index, 3
        Save as WAV file: "'out_directory$'/'speaker$'/'speaker$'-'zeroPadding.return$'.wav"

```

If the debugging mode is off, all the intermediate files are removed. Otherwise they are kept for inspection. The index is increased by one and the TextGrid is selected for the next cycle of the for loop.

### "sync"+=
```praat
        if debug_mode == 0
            removeObject: "Sound chain_ch1_22050_part", "Sound " + file_us_name$,
            ..."Sound chain_ch1_22050_part_" + file_us_name$, "Sound chain_part"
        endif

        index += 1
        select TextGrid chain_ch2
    endif
endfor
```

## Extract VUV intervals

This script calculates the voiced and voiceless portions (VUV) in the synchronised EGG files based on the EGG signal.

### extract-vuv.praat
```praat
<<<get synced egg>>>

<<<vuv>>>
```

We first read ask for the project name and the speaker ID.

### "get synced egg"
```praat
form Extract vuv
    word project pilot
    word speaker SC01
    boolean debug_mode
endform

directory$ = "../../'project$'/data/derived/egg"

Create Strings as file list: "filelist", "'directory$'/'speaker$'/*.wav"
files = Get number of strings
```

Now, for each file in `derived/egg`, we can calculate the boundaries of the voiced and voiceless intervals in the file and save them to a TextGrid file.

### "vuv"
```praat
for file from 1 to files
    selectObject: "Strings filelist"
    file$ = Get string: file
    Read from file: "'directory$'/'speaker$'/'file$'"
    filename$ = selected$("Sound")

    <<<to vuv>>>

    <<<save vuv>>>
endfor

removeObject: "Strings filelist"
```

To calculate voiced and voicelss intervals, we can exploit the already available function `To TextGrid (vuv)`. The channel containing the EGG signal (channel 2) is extracted, a PointProcess object is created from the signal, and finally the `vuv` function is applied.

#### "to vuv"
```praat
Extract one channel: 2

To PointProcess (periodic, cc): 75, 600

To TextGrid (vuv): 0.02, 0.001
```

The resulting TextGrid is saved in the same synced EGG files folder.

#### "save vuv"
```praat
Write to text file: "'directory$'/'speaker$'/'filename$'-vuv.TextGrid"

if debug_mode == 0
    removeObject: "Sound " + filename$, "Sound " + filename$ + "_ch2",
    ..."PointProcess " + filename$ + "_ch2", "TextGrid " + filename$ + "_ch2"
endif
```

## Headers

### "sync header"
```praat
######################################
# sync-egg.praat v1.0.0
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
# This script syncs the audio files acquired by the Laryngograph with the audio
# files exported from AAA. Syncing is obtained through pair-wise
# cross-correlation of the audio files. The cross-correlation function returns
# the off-set in seconds between two files. The off-set is used to remove the
# leading audio from the longer file.
#
# Input: - .wav stereo files from the Laryngograph recordings (ch1 = audio, ch2 =
# EGG), saved in a folder
#     - .wav mono files exported from AAA, saved in a separate folder
# Output: - .wav stereo files (ch1 = audio, ch2 = EGG) whose start time is
# synced with the start time of the correspondet AAA file
#
# The zeroPadding procedure code is by Daniel Riggs and can be found at
# <http://praatscriptingtutorial.com/procedures>.
######################################
```
