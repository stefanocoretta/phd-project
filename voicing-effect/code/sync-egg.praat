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
######################################

select all
number_selected = numberOfSelected ()
if number_selected > 0
    exitScript: "Please, remove the objects in the Objects window. For this
    ... script to work, the Objects list must be empty."
endif

form Syncronise EGG data
    word project voicing-effect
    word speaker sc01
    boolean debug_mode
endform
egg_directory$ = "../data/raw/egg"
us_directory$ = "../data/derived/ultrasound"
out_directory$ = "../data/derived/egg"
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
Multiply: -1
Extract all channels

selectObject: "Sound chain_ch1"
Resample: 22050, 50

selectObject: "Sound chain_ch2"

To TextGrid (silences): 100, 0, -25, 1, 0.1, "silence", "speech"
intervals = Get number of intervals: 1
Insert interval tier: 2, "new"

for interval from 1 to intervals
    label$ = Get label of interval: 1, interval
    if label$ == "speech"
        start = Get starting point: 1, interval
        end = Get end point: 1, interval
        Insert boundary: 2, start - 1.5
        Insert boundary: 2, end + 1
        new_interval = Get interval at time: 2, start
        Set interval text: 2, new_interval, "speech"
    endif
endfor

Remove tier: 1
intervals = Get number of intervals: 1

index = 1

for interval from 1 to intervals
    label$ = Get label of interval: 1, interval
    if label$ == "speech"
        start = Get starting point: 1, interval
        end = Get end point: 1, interval

        selectObject: "Sound chain_ch1_22050"
        Extract part: start, end, "rectangular", 1, "no"

        selectObject: "Strings filelist_us"
        file_us$ = Get string: index
        Read from file: "'us_directory$'/'speaker$'/audio/'file_us$'"
        file_us_name$ = selected$ ("Sound")

        plusObject: "Sound chain_ch1_22050_part"

        crosscorrelated = Cross-correlate: "peak 0.99", "zero"
        offset = Get time of maximum: 0, 0, "Sinc70"

        selectObject: "Sound chain"

        start = start - offset
        Extract part: start, end, "rectangular", 1, "no"
        Save as WAV file: "'out_directory$'/'speaker$'/'file_us_name$'.wav"

        if debug_mode == 0
            removeObject: "Sound chain_ch1_22050_part", "Sound " + file_us_name$,
            ...crosscorrelated, "Sound chain_part"
        endif

        index += 1
        select TextGrid chain_ch2
    endif
endfor
