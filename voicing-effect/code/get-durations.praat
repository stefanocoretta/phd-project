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

header$ = "index,speaker,file,rec.date,word,time,word.duration,c1.duration,vowel.duration,
    ...closure.duration,rvot,c2.duration,v2.duration,sentence.duration"
writeFileLine: result_file$, header$

bursts = Read from file: "'directory$'/'speaker$'-burst.TextGrid"

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
        start_target = Get start time of interval: 2, interval + 1
        end_target = Get end time of interval: 2, interval + 1
        word_duration = (end_target - start_target) * 1000
        start_consonant = Get interval at time: 1, start_target
        start_vowel = Get start time of interval: 1, start_consonant + 1
        c1_duration = (start_vowel - start_target) * 1000
        end_vowel = Get end time of interval: 1, start_consonant + 1
        end_consonant2 = Get end time of interval: 1, start_consonant + 2
        v_duration = (end_vowel - start_vowel) * 1000
        v2_duration = (end_target - end_consonant2) * 1000
        sentence_interval = Get interval at time: 3, start_target
        start_sentence = Get start time of interval: 3, sentence_interval
        end_sentence = Get end time of interval: 3, sentence_interval
        sentence_duration = end_sentence - start_sentence

        selectObject: bursts
        burst_interval = Get nearest index from time: 1, end_vowel
        burst = Get time of point: 1, burst_interval
        if burst < end_vowel or burst > end_sentence
            burst = undefined
        endif

        closure = (burst - end_vowel) * 1000
        rvot = (end_consonant2 - burst) * 1000
        consonant_duration = closure + rvot

        selectObject: fileNames
        fileName = Get interval at time: 1, start_vowel
        fileName$ = Get label of interval: 1, fileName

        Read Strings from raw text file: "../data/ultrasound/derived/'speaker$'/recordings/'fileName$'.txt"
        rec_date$ = Get string: 2

        result_line$ = "'index','speaker$','fileName$','rec_date$','word$','start_target',
            ...'word_duration','c1_duration','v_duration','closure','rvot',
            ...'consonant_duration','v2_duration','sentence_duration'"
        appendFileLine: "'result_file$'", "'result_line$'"
    endif
endfor

removeObject: palign, bursts
