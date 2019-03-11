######################################
# This is a script from the project 'Vowel duration and consonant voicing: An
# articulatory study', subproject 'English'.
# Author: Stefano Coretta.
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
#
# !!! WARNING !!!
#
# This script is generated automatically, DO NOT EDIT
#
######################################

stereo$ = "../data/raw/stereo"
mono$ = "../data/raw/mono"
Create Strings as file list: "file_list", "'stereo$'/*.wav"
files = Get number of strings

createDirectory: mono$

for file from 1 to files
  selectObject: "Strings file_list"
  file$ = Get string: file
  participant$ = file$ - "-stereo.wav"
  mono_file$ = "'mono$'/'participant$'.wav"

  if fileReadable(mono_file$)
    appendInfoLine: "Skipping 'participant$'.wav..."
  else

    stereo = Read from file: "'stereo$'/'file$'"
    file_name$ = selected$("Sound")

    # Audio is in channel 1
    ch_1 = Extract one channel: 1

    # Downsample
    ch_1_22050 = Resample: 22050, 50

    Save as WAV file: mono_file$

    removeObject: stereo, ch_1, ch_1_22050

  endif

endfor
