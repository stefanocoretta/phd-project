######################################
# extract_vuv.praat v1.0.0
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

form Extract vuv
    word directory ../../pilot/data/derived/egg
    word speaker SC01
endform

Create Strings as file list: "filelist", "'directory$'/'speaker$'/*.wav"
files = Get number of strings

for file from 1 to files
    selectObject: "Strings filelist"
    file$ = Get string: file
    Read from file: "'directory$'/'speaker$'/'file$'"
    filename$ = selected$("Sound")

    Extract one channel: 2

    To PointProcess (periodic, cc): 75, 600

    To TextGrid (vuv): 0.02, 0.001

    Write to text file: "'directory$'/'speaker$'/'filename$'_vuv.TextGrid"

    removeObject: "Sound " + filename$, "Sound " + filename$ + "_ch2",
        ..."PointProcess " + filename$ + "_ch2", "TextGrid " + filename$ + "_ch2"

endfor

removeObject: "Strings filelist"


