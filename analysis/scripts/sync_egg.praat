######################################
# sync_egg.praat v1.0.0
######################################
# Copyright 2016 Stefano Coretta
#
# stefanocoretta.altervista.org
#
# This program is free software: you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later
# version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
# details.
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
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

select all
number_selected = numberOfSelected ()
if number_selected > 0
    exitScript: "Please, remove the objects in the Objects window. For this
    ... script to work, the Objects list must be empty."
endif

form Syncronise EGG data
    word egg_directory ../../pilot/data/raw/egg
    word us_directory ../../pilot/data/derived/ultrasound
    word out_directory ../../pilot/data/derived/egg
    word speaker SC01
    boolean invert_egg_signal 1
    boolean debug_mode
endform

createDirectory ("'out_directory$'/'speaker$'")

Create Strings as file list: "filelist_egg", "'egg_directory$'/'speaker$'/*.wav"
files = Get number of strings
Create Strings as file list: "filelist_us", "'us_directory$'/'speaker$'/audio/*.wav"

for file from 1 to files
    select Strings filelist_egg
    file$ = Get string: file
    Read from file: "'egg_directory$'/'speaker$'/'file$'"
endfor

select all
minusObject: "Strings filelist_egg"
minusObject: "Strings filelist_us"
Concatenate
Extract all channels

selectObject: "Sound chain_ch1"
Resample: 22050, 50


if invert_egg_signal == 1
    selectObject: "Sound chain_ch2"
    Formula: "-self"

    plusObject: "Sound chain_ch1"
    Combine to stereo
endif

selectObject: "Sound chain_ch2"

To TextGrid (silences): 100, 0, -25, 1, 0.1, "silence", "speech"
intervals = Get number of intervals: 1

for interval from 1 to intervals
    label$ = Get label of interval: 1, interval
    if label$ == "speech"
        start = Get starting point: 1, interval
        end = Get end point: 1, interval
        Insert boundary: 1, start - 0.2
        Insert boundary: 1, end + 1
        Remove left boundary: 1, interval + 1
        Remove right boundary: 1, interval
    endif
endfor

intervals = Get number of intervals: 1

index = 1

for interval from 1 to intervals
    label$ = Get label of interval: 1, interval
    if label$ == "speechsilence"
        start = Get starting point: 1, interval
        end = Get end point: 1, interval

        selectObject: "Sound chain_ch1_22050"
        Extract part: start, end, "rectangular", 1, "no"
        Formula: "-self"

        selectObject: "Strings filelist_us"
        file_us$ = Get string: index
        Read from file: "'us_directory$'/'speaker$'/audio/'file_us$'"
        file_us_name$ = selected$ ("Sound")

        plusObject: "Sound chain_ch1_22050_part"

        Cross-correlate: "peak 0.99", "zero"
        offset = Get time of maximum: 0, 0, "Sinc70"

        if invert_egg_signal == 1
            selectObject: "Sound combined_2"
        else
            selectObject: "Sound chain"
        endif

        start = start - offset
        Extract part: start, end, "rectangular", 1, "no"
        @zeroPadding: index, 3
        Save as WAV file: "'out_directory$'/'speaker$'/'speaker$'-'zeroPadding.return$'.wav"

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
