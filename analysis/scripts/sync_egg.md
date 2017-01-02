---
title: Sync EGG files with Ultrasound files recorded with AAA
author: Stefano Coretta
---

The following chunk calls the header of the script, which is defined at the end of the documentation, the padding function, and the main function.

#### sync_egg.praat
```praat
<<<header>>>
<<<padding>>>
<<<function>>>
```

## Zero padding function

The following code creates a procedure called zeroPadding. The procedure allows automatic zero padding in file names with numeric indexes. For example: `Sound001.wav`, `Sound002.wav`, ..., `Sound010.wav`, ..., `Sound100.wav`.

#### "padding"
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

## Main function

The script works by selecting all the files in the Object window after loading files. Before running, the script checks if the objects list is empty. If not, the script exits and prompts the user to clean the objects list.

#### "function"
```praat
select all
number_selected = numberOfSelected ()
if number_selected > 0
    exitScript: "Please, remove the objects in the Objects window. For this
    ... script to work, the Objects list must be empty."
endif

```

The form saves the directory with the EGG `.wav` files and the directory with the `.wav` files exported from AAA. Moreover, a boolean is stored as well for enabling the debugging mode. In the debugging mode, all intermediate files produced by the script are kept in the Objects window. They are deleted otherwise.

#### "function"+=
```praat
form Syncronise EGG data
    word egg_directory ../../pilot/data/raw/egg
    word us_directory ../../pilot/data/derived/ultrasound
    word out_directory ../../pilot/data/derived/egg
    word speaker SC01
    boolean invert_egg_signal 1
    boolean debug_mode
endform

```

The directory sync is created in the EGG directory for saving the output of the script. The file lists of the EGG and ultrasound `.wav` files are saved in `filelist_egg` and `filelist_us`.
The number of files in the EGG folder is saved in `files`.

#### "function"+=
```praat
createDirectory ("'out_directory$'/'speaker$'")

Create Strings as file list: "filelist_egg", "'egg_directory$'/'speaker$'/*.wav"
files = Get number of strings
Create Strings as file list: "filelist_us", "'us_directory$'/'speaker$'/audio/*.wav"

```

For every file listed in `filelist_egg`, it reads the file to a Sound.

#### "function"+=
```praat
for file from 1 to files
    select Strings filelist_egg
    file$ = Get string: file
    Read from file: "'egg_directory$'/'speaker$'/'file$'"
endfor

```

Every object is then selected, minus the two file lists. The Sounds are concatenated to `Sound chain`.

#### "function"+=
```praat
select all
minusObject: "Strings filelist_egg"
minusObject: "Strings filelist_us"
Concatenate
```

While `Sound chain` is selected, the script extracts all channels (the object is a stereo sound: channel 1 is the audio, channel 2 is the EGG signal). For cross-correlation to work, the two sound files must have the same sampling frequency.
AAA records at a frequency of 22050 Hz. To ensure that the EGG audio is at the same sampling frequency, resampling is performed. `Sound chain_ch1_22050` is created from `Sound chain_ch1`.

#### "function"+=
```praat
Extract all channels

selectObject: "Sound chain_ch1"
Resample: 22050, 50

```

The extraction of each simulus from the concatenated sound is achieved through the EGG signal (which is inverted if the `invert egg sygnal` option was selected in the options window). The function `To TextGrid (silences)` efficiently recognises the voiced streaches of the audio which roughly corresponds to the spoken stimuli. (*Warning*: this assumes that the EGG files don't contain spurious material)
The minimum duration for silence is set to 1 second to avoid voiceless segments being annotated as silence. The output is `TextGrid chain_ch2`.
The number of intervals in the TextGrid is saved in the variable `intervals`.

#### "function"+=
```praat

if invert_egg_signal == 1
    selectObject: "Sound chain_ch2"
    Formula: "-self"

    plusObject: "Sound chain_ch1"
    Combine to stereo
endif

selectObject: "Sound chain_ch2"

To TextGrid (silences): 100, 0, -25, 1, 0.1, "silence", "speech"
intervals = Get number of intervals: 1

```

For each interval in the `TextGrid chain_ch2` wich is labelled `speech`, the start and end time of the interval are moved by -1.5 and 1 second respectively. This ensures that there is enough audio before and after the stimulus for cross-correlation. The original left and right boundaries are removed. The result is that the interval label is changed to `speechsilence`.

#### "function"+=
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

#### "function"+=
```praat
intervals = Get number of intervals: 1

index = 1

```

For every interval in the TextGrid it is checked if the label is `speechsilence`. The intervals with this label correspond to the individual stimuli in the concatenated EGG sound files. If the label is `speechsilence`, the script gets the start and end time of that interval.

#### "function"+=
```praat
for interval from 1 to intervals
    label$ = Get label of interval: 1, interval
    if label$ == "speechsilence"
        start = Get starting point: 1, interval
        end = Get end point: 1, interval

```

Then the resampled `Sound chain_ch1_22050` is selected and the portion from `start` to `end` is extracted. This portion corresponds to the TextGrid interval and, thus, to the stimulus. The sound is named `Sound chain_ch1_22050_part`.

#### "function"+=
```praat
        selectObject: "Sound chain_ch1_22050"
        Extract part: start, end, "rectangular", 1, "no"

```

The counter `index` is now used to read the audio file from the ultrasound directory. Since the order of the stimuli is the same in both the EGG and unltrasound files, a counter that increases for every interval wth the `speechsilence` label is sufficient. The name of the file is saved after reading and the file remains selected.

#### "function"+=
```praat
        selectObject: "Strings filelist_us"
        file_us$ = Get string: index
        Read from file: "'us_directory$'/'speaker$'/audio/'file_us$'"
        file_us_name$ = selected$ ("Sound")

```

The extracted portion from the EGG audio channel is added to the selection. The cross-correlation between the EGG and ultrasound audio is performed. The time of maximum amplitude in the generated cross-correlated sound corresponds to the off-set between the two files.

#### "function"+=
```praat
        plusObject: "Sound chain_ch1_22050_part"

        Cross-correlate: "peak 0.99", "zero"
        offset = Get time of maximum: 0, 0, "Sinc70"

```

The concatenated stereo sound (or the recombined stereo if the `invert egg signal` option is active) is selected and a portion is extracted. The portion starting point corresponds to the starting point of the TextGrid interval plus the off-set obtained from the correlation. The end point is the same as the one of the interval. (The endpoint does not matter, since timing is calculated from the beginning of the file.) The sound is finally saved in the `sync` folder.

#### "function"+=
```praat
        if invert_egg_signal == 1
            selectObject: "Sound combined_2"
        else
            selectObject: "Sound chain"
        endif

        start = start + abs(offset)
        Extract part: start, end, "rectangular", 1, "no"
        @zeroPadding: index, 3
        Save as WAV file: "'out_directory$'/'speaker$'/'speaker$'-'zeroPadding.return$'.wav"

```

If the debugging mode is off, all the intermediate files are removed. Otherwise they are kept for inspection. The index is increased by one and the TextGrid is selected for the next cycle of the for loop.

#### "function"+=
```praat
        if debug_mode == 0
            removeObject: "Sound chain_ch1_22050_part", "Sound " + file_us_name$,
            ..."Sound chain_ch1_22050_part_" + file_us_name$

            if invert_egg_signal == 1
                removeObject: "Sound combined_2_part"
            else
                removeObject: "Sound chain_part"
            endif
        endif

        index += 1
        select TextGrid chain_ch2
    endif
endfor
```

## Script header

The following chunk is the header of the script.

#### "header"
```praat
######################################
# sync_egg.praat v1.0.0
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
