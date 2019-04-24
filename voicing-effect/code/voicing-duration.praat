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

form Get duration of voicing
    word speaker it01
endform

vuvDirectory$ = "../data/egg/derived/'speaker$'"
recordings_dir$ = "../data/ultrasound/derived/'speaker$'/recordings"
resultsFile$ = "../data/datasets/egg/'speaker$'-voicing.csv"
resultsHeader$ = "speaker,file,rec_date,word,voicing_start,voicing_end,voicing_duration,voiced_points"
writeFileLine: resultsFile$, resultsHeader$

Create Strings as file list: "vuvList", "'vuvDirectory$'/*.TextGrid"
numberOfVuv = Get number of strings
index = 0

for vuv to numberOfVuv
    selectObject: "Strings vuvList"
    vuvFile$ = Get string: vuv
    vuvTextGrid = Read from file: "'vuvDirectory$'/'vuvFile$'"
    vuvTextGrid$ = selected$("TextGrid")
    palignTextGrid$ = vuvTextGrid$ - "-vuv"

    Read Strings from raw text file: "'recordings_dir$'/'palignTextGrid$'.txt"
    recDate$ = Get string: 2

    palignTextGrid = Read from file: "'recordings_dir$'/'palignTextGrid$'-palign.TextGrid"
    plusObject: vuvTextGrid
    Merge
    numberOfWords = Get number of intervals: 3

    for word to numberOfWords
        word$ = Get label of interval: 3, word
        if word$ == "dico" or word$ == "mowie"
            index = index + 1
            wordStart = Get start time of interval: 3, word + 1
            segment = Get interval at time: 2, wordStart
            vowelStart = Get start time of interval: 2, segment + 1
            vowelEnd = Get end time of interval: 2, segment + 1
            midPoint = vowelStart + (vowelEnd - vowelStart)
            voiced = Get interval at time: 1, midPoint
            voicedStart = Get start time of interval: 1, voiced
            voicedEnd = Get end time of interval: 1, voiced
            voicing = (voicedEnd - voicedStart) * 1000
            stimulus$ = Get label of interval: 3, word + 1
    
            sentenceInterval = Get interval at time: 4, vowelStart
            sentenceStart = Get start time of interval: 4, sentenceInterval
            sentenceEnd = Get end time of interval: 4, sentenceInterval
            sentenceDuration = sentenceEnd - sentenceStart
    
            consonant_start = Get start time of interval: 2, segment + 2
            consonant_end = Get end time of interval: 2, segment + 2
            consonant_duration = consonant_end - consonant_start
            one_tenth = consonant_duration / 10
    
            voiced_points = 0
    
            for point from 1 to 5
              this_point = consonant_start + (one_tenth * point)
              vuv_interval = Get interval at time: 1, this_point
              voicing$ = Get label of interval: 1, vuv_interval
              if voicing$ == "V"
                voiced_points = voiced_points + 1
              endif
            endfor
    
            resultLine$ = "'speaker$','palignTextGrid$','recDate$','stimulus$',
                ...'voicedStart','voicedEnd','voicing','voiced_points'"
            appendFileLine: resultsFile$, resultLine$
        endif
    endfor
endfor
