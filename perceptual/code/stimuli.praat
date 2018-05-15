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

createDirectory("../data/derived/")
createDirectory("../data/derived/stimuli")
raw_data$ = "../data/raw/stimuli"
derived_data$ = "../data/derived/stimuli"

wav = Read from file: "'raw_data$'/pata.wav"
textgrid = Read from file: "'raw_data$'/pata.TextGrid"
vowel = Read from file: "'raw_data$'/vowel.wav"
voicing = Read from file: "'raw_data$'/voicing.wav"

selectObject: wav
Save as WAV file: "'derived_data$'/pata_a0.wav"

selectObject: textgrid
vowel_time = Get time of point: 1, 1
voicing_time = Get time of point: 1, 1
end_time = Get end time

selectObject: wav
wav_1 = Extract part: 0, vowel_time, "rectangular", 1, "no"
selectObject: vowel
vowel_copy = Copy: "vowel_copy"
selectObject: wav
wav_2 = Extract part: vowel_time, end_time, "rectangular", 1, "no"

selectObject: wav_1, vowel_copy, wav_2
concat = Concatenate
Save as WAV file: "'derived_data$'/pata_a1.wav"

selectObject: wav
wav_1 = Extract part: 0, vowel_time, "rectangular", 1, "no"
selectObject: vowel
vowel_copy = Copy: "vowel_copy"
selectObject: vowel
vowel_copy_2 = Copy: "vowel_copy_2"
selectObject: wav
wav_2 = Extract part: vowel_time, end_time, "rectangular", 1, "no"

selectObject: wav_1, vowel_copy, vowel_copy_2, wav_2
concat_2 = Concatenate
Save as WAV file: "'derived_data$'/pata_a2.wav"

selectObject: wav
wav_1 = Extract part: 0, vowel_time, "rectangular", 1, "no"
selectObject: vowel
vowel_copy = Copy: "vowel_copy"
selectObject: vowel
vowel_copy_2 = Copy: "vowel_copy_2"
selectObject: vowel
vowel_copy_3 = Copy: "vowel_copy_3"
selectObject: wav
wav_2 = Extract part: vowel_time, end_time, "rectangular", 1, "no"

selectObject: wav_1, vowel_copy, vowel_copy_2, vowel_copy_3, wav_2
concat_3 = Concatenate
Save as WAV file: "'derived_data$'/pata_a3.wav"
