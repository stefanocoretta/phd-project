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

mono_dir$ = "../data/raw/mono"
results_dir$ = "../data/datasets"
results_file$ = "'results_dir$'/english-durations.csv"
results_header$ = "speaker,sentence,sentence_ons,sentence_off,c1_rel,c2_rel,v1_ons,v1_off"
writeFileLine: results_file$, results_header$

file_list = Create Strings as file list: "file_list", "'mono_dir$'/*-annotation-corrected.TextGrid"
textgrid_num = Get number of strings

sentence_tier = 1
phones_tier = 3
release_tier = 4

for speaker from 1 to textgrid_num
  selectObject: file_list
  annotation$ = Get string: speaker

  annotation = Read from file: "'mono_dir$'/'annotation$'"
  speaker$ = annotation$ - "-annotation-corrected.TextGrid"
  phones_num = Get number of intervals: phones_tier

  for phone from 1 to phones_num - 3
    label$ = Get label of interval: phones_tier, phone
  
    if label$ != ""
      c1_start = Get start time of interval: phones_tier, phone
      c1_end = Get end time of interval: phones_tier, phone
      sentence = Get interval at time: sentence_tier, c1_start
      sentence$ = Get label of interval: sentence_tier, sentence
      sentence_start = Get start time of interval: sentence_tier, sentence
      sentence_end = Get end time of interval: sentence_tier, sentence
  
      c1_rel_i = Get nearest index from time: release_tier, c1_start
      c1_rel = Get time of point: release_tier, c1_rel_i
      if c1_rel < c1_start or c1_rel > c1_end
        c1_rel = undefined
      endif
  
      v1 = phone + 1
  
      v1_start = Get start time of interval: phones_tier, v1
      v1_end = Get end time of interval: phones_tier, v1
  
      c2 = phone + 2
  
      c2_start = Get start time of interval: phones_tier, c2
      c2_end = Get end time of interval: phones_tier, c2
  
      c2_rel_i = Get nearest index from time: release_tier, c2_start
      c2_rel = Get time of point: release_tier, c2_rel_i
      if c2_rel < c2_start or c2_rel > c2_end
        c2_rel = undefined
      endif
  
      results_line$ = "'speaker$','sentence$','sentence_start','sentence_end',
        ...'c1_rel','c2_rel','v1_start','v1_end'"
      appendFileLine: results_file$, results_line$
  
      phone += 3
    endif
  
  endfor

  removeObject: annotation

endfor
