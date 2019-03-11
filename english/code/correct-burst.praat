######################################
# This is a script from the project 'Vowel duration and consonant voicing: An
# articulatory study', subproject 'English'.
# Author: Stefano Coretta.
######################################
# MIT License
#
# Copyright (c) 2016-2019 Stefano Coretta
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

form Select participant
  word speaker en01
endform

mono_dir$ = "../data/raw/mono"

sound = Read from file: "'mono_dir$'/'speaker$'.wav"
annotation = Read from file: "'mono_dir$'/'speaker$'-annotation.TextGrid"

selectObject: sound, annotation

cons_tier = 3

selectObject: annotation
consonants_num = Get number of intervals: cons_tier

for i from 1 to consonants_num - 3
  selectObject: annotation
  consonant$ = Get label of interval: cons_tier, i
  if consonant$ <> ""
    c_start = Get start time of interval: cons_tier, i
    c_end = Get end time of interval: cons_tier, i

    selectObject: sound, annotation
    View & Edit
    editor: annotation
      Select: c_start, c_end
      Zoom to selection
      pauseScript: "Annotate then continue"
      Close
    endeditor

    selectObject: annotation
    c_start = Get start time of interval: cons_tier, i + 2
    c_end = Get end time of interval: cons_tier, i + 2

    selectObject: sound, annotation
    View & Edit
    editor: annotation
      Select: c_start, c_end
      Zoom to selection
      pauseScript: "Annotate then continue"
      Close
    endeditor

    i += 3
  endif
endfor
