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

form Get formants and fundamental frequency
  word speaker it01
  word sex f
endform

if sex$ == "f"
  max_formant = 5500
else
  max_formant = 5000
endif

result_header$ = "speaker,file,word,time,f1,f2,f3,f0"
result_file$ = "../data/datasets/acoustics/'speaker$'-formants.csv"
writeFileLine: result_file$, result_header$

directory_audio$ = "../data/ultrasound/derived/'speaker$'/recordings"
file_list = Create Strings as file list: "file_list", "'directory_audio$'/*.wav"
number_of_files = Get number of strings

for file from 1 to number_of_files
  selectObject: file_list
  file$ = Get string: file
  file_bare$ = file$ - ".wav"
  sound = Read from file: "'directory_audio$'/'file$'"
  palign = Read from file: "'directory_audio$'/'file_bare$'-palign.TextGrid"
  search = Read from file: "'directory_audio$'/'file_bare$'.TextGrid"

  vowel_intervals = Get number of intervals: 3
  
  if vowel_intervals > 1
    vowel$ = Get label of interval: 3, 2
  else
    vowel$ = ""
  endif
  
  if vowel$ != ""
    vowel_start = Get start time of interval: 3, 2
    vowel_end = Get end time of interval: 3, 2
    vowel_duration = vowel_end - vowel_start
    duration_tenth = vowel_duration / 10
  
    selectObject: sound
    sound_vowel = Extract part: vowel_start - 0.5, vowel_end + 0.5, "rectangular", 1, "yes"
    formant = noprogress To Formant (burg): 0, 5, max_formant, 0.025, 50
    selectObject: sound
    pitch = noprogress To Pitch: 0, 75, 600
    selectObject: palign
    word = Get interval at time: 2, vowel_start
    word$ = Get label of interval: 2, word
  
    for time_point from 1 to 9
      time = vowel_start + (duration_tenth * time_point)
      selectObject: formant
      f1 = Get value at time: 1, time, "Hertz", "Linear"
      f2 = Get value at time: 2, time, "Hertz", "Linear"
      f3 = Get value at time: 3, time, "Hertz", "Linear"
  
      selectObject: pitch
      f0 = Get value at time: time, "Hertz", "Linear"
  
      result_line$ = "'speaker$','file_bare$','word$','time_point','f1','f2','f3','f0'"
      appendFileLine: result_file$, result_line$
    endfor
  
  endif

endfor
