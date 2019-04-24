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

form Get vowel duration
    word project voicing-effect
    word speaker it01
    comment Supported languages: it, pl
    word language it
endform

if language$ == "it"
    label_lang$ = "dico"
elif language$ == "pl"
    label_lang$ = "mowie"
else
    exit "The language you selected is not valid"
endif

directory$ = "../data/ultrasound/derived/'speaker$'/concatenated"
directory_palign$ = "../data/ultrasound/raw/corrected-palign"

result_file$ = "../data/datasets/acoustics/'speaker$'-durations.csv"

header$ = "index,speaker,file,rec_date,ipu_prompt,word,time,sentence_ons,sentence_off,word_ons,word_off,v1_ons,c2_ons,v2_ons,c1_rel,c2_rel"

writeFileLine: result_file$, header$

bursts = Read from file: "'directory$'/'speaker$'-burst.TextGrid"

release_c1_textgrid = Read from file: "'directory$'/'speaker$'-release-c1.TextGrid"

sentences = Read from file: "'directory$'/'speaker$'.TextGrid"

palign = Read from file: "'directory_palign$'/'speaker$'-palign.TextGrid"
intervals = Get number of intervals: 2

fileNames = Read from file: "'directory$'/'speaker$'-filenames.TextGrid"
index = 0

for interval to intervals
    selectObject: palign
    label$ = Get label of interval: 2, interval
    if label$ == label_lang$
        index += 1
        word$ = Get label of interval: 2, interval + 1
        word_onset = Get start time of interval: 2, interval + 1
        word_offset = Get end time of interval: 2, interval + 1
        # word_duration = (end_target - start_target) * 1000
        c1 = Get interval at time: 1, word_onset
        v1_onset = Get start time of interval: 1, c1 + 1
        c2_onset = Get end time of interval: 1, c1 + 1
        v2_onset = Get end time of interval: 1, c1 + 2
        # v_duration = (end_vowel - start_vowel) * 1000
        # v2_duration = (end_target - end_consonant2) * 1000
        sentence_interval = Get interval at time: 3, word_onset
        sentence$ = Get label of interval: 3, sentence_interval
        sentence_onset = Get start time of interval: 3, sentence_interval

        if sentence$ <> ""
          sentence_offset = Get end time of interval: 3, sentence_interval
          # sentence_duration = end_sentence - start_sentence

          selectObject: bursts
          burst_interval = Get nearest index from time: 1, c2_onset
          release = Get time of point: 1, burst_interval
          if release < c2_onset or release > sentence_offset
              release = undefined
          endif

          # closure = (burst - end_vowel) * 1000
          # rvot = (end_consonant2 - burst) * 1000
          # consonant_duration = closure + rvot

          selectObject: release_c1_textgrid
          release_c1_point = Get nearest index from time: 1, v1_onset
          release_c1 = Get time of point: 1, release_c1_point
          if release_c1 < word_onset or release_c1 > sentence_offset
              release_c1 = undefined
          endif

          # c1_duration = (start_vowel - start_target) * 1000
          # c1_closure = (release_c1 - start_target) * 1000
          # c1_rvot = (start_vowel - release_c1) * 1000
          # c1_rvofft = (end_vowel - release_c1) * 1000

          selectObject: sentences
          prompt = Get interval at time: 2, v1_onset
          prompt$ = Get label of interval: 2, prompt

          selectObject: fileNames
          fileName = Get interval at time: 1, v1_onset
          fileName$ = Get label of interval: 1, fileName
          file_start = Get start time of interval: 1, fileName

          # Get times relative to the start of the individual audio chunk file
          word_onset = word_onset - file_start
          word_offset = word_offset - file_start
          v1_onset = v1_onset - file_start
          c2_onset = c2_onset - file_start
          v2_onset = v2_onset - file_start
          c1_rel = release_c1 - file_start
          c2_rel = release - file_start
          time = sentence_onset
          sentence_onset = sentence_onset - file_start
          sentence_offset = sentence_offset - file_start
        else
          word_onset = undefined
          word_offset = undefined
          v1_onset = undefined
          c2_onset = undefined
          v2_onset = undefined
          c1_rel = undefined
          c2_rel = undefined
          time = sentence_onset
          sentence_onset = undefined
          sentence_offset = undefined

          selectObject: fileNames
          fileName = Get interval at time: 1, time
          fileName$ = Get label of interval: 1, fileName
        endif

        # rel_rel = (burst - release_c1) * 1000

        Read Strings from raw text file: "../data/ultrasound/derived/'speaker$'/recordings/'fileName$'.txt"
        rec_date$ = Get string: 2

        result_line$ = "'index','speaker$','fileName$','rec_date$','prompt$','word$',
          ...'time',
          ...'sentence_onset','sentence_offset','word_onset','word_offset',
          ...'v1_onset','c2_onset','v2_onset','c1_rel','c2_rel'"

        appendFileLine: "'result_file$'", "'result_line$'"
    endif
endfor

removeObject: palign, bursts
