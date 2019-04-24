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

form Generate input for force alignment with SPPAS
    word project voicing-effect
    word speaker it01
endform

directory_speaker$ = "../data/ultrasound/derived/'speaker$'"
directory_audio$ = "'directory_speaker$'/recordings"
createDirectory ("'directory_speaker$'/concatenated")
directory_alignment$ = "'directory_speaker$'/concatenated"
writeFile: "'directory_alignment$'/'speaker$'.txt", ""

Create Strings as file list: "filelist", "'directory_audio$'/*.wav"
files = Get number of strings

for file from 1 to files
    select Strings filelist
    file$ = Get string: file
    Read from file: "'directory_audio$'/'file$'"
    sound = selected("Sound")
    sound$ = file$ - ".wav"
endfor

select all
minusObject: "Strings filelist"
Concatenate recoverably

selectObject: "TextGrid chain"
Duplicate tier: 1, 1, "Orthography"

intervals = Get number of intervals: 1

for interval from 1 to intervals
    start = Get start point: 1, interval
    end  = Get end point: 1, interval
    filename$ = Get label of interval: 1, interval

    Read Strings from raw text file: "'directory_audio$'/'filename$'.txt"
    prompt$ = Get string: 1
    selectObject: "TextGrid chain"
    Set interval text: 1, interval, "'prompt$'"
    appendFileLine: "'directory_alignment$'/'speaker$'.txt", "'prompt$'"
endfor

selectObject: "Sound chain"
Save as WAV file: "'directory_alignment$'/'speaker$'.wav"

selectObject: "TextGrid chain"
Copy: "filenames"
Remove tier: 1
Save as text file: "'directory_alignment$'/'speaker$'-filenames.TextGrid"
