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

form Create closure annotations
    word project voicing-effect
    word speaker it01
    comment Supported languages: it, pl
    word language it
endform

if language$ == "it"
    label_lang$ = "k"
    label_2_lang$ = "dico"
elif language$ == "pl"
    label_lang$ = "j"
    label_2_lang$ = "mowie"
else
    exit "The language you selected is not valid"
endif

ultrasound_dir$ = "../data/ultrasound/derived"

speaker_rec_dir$ = "'ultrasound_dir$'/'speaker$'/recordings"
file_list = Create Strings as file list: "file_list", "'speaker_rec_dir$'/*.wav"
number_of_files = Get number of strings

for wav from 1 to number_of_files
  selectObject: file_list
  wav_file$ = Get string: wav
  textgrid_file$ = wav_file$ - ".wav"
  textgrid = Read from file: "'speaker_rec_dir$'/'textgrid_file$'.TextGrid"

  Insert point tier: 4, "closure"
  number_of_intervals = Get number of intervals: 3

  if number_of_intervals == 3
  vowel$ = Get label of interval: 3, 2

    if vowel$ != ""
      closure = Get end time of interval: 3, 2
      Insert point: 4, closure, "closure_"
    endif
  endif

  Save as text file: "'speaker_rec_dir$'/'textgrid_file$'.TextGrid"
  removeObject: textgrid
endfor

