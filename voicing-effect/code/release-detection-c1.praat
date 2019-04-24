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

form Select folder with TextGrid
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

directory_audio$ = "../data/ultrasound/derived/'speaker$'/recordings"
directory_alignment$ = "../data/ultrasound/derived/
    ...'speaker$'/concatenated"
directory_palign$ = "../data/ultrasound/raw/corrected-palign"

palign_original = Read from file: "'directory_palign$'/'speaker$'-palign.TextGrid"
palign = Read from file: "'directory_palign$'/'speaker$'-palign.TextGrid"
selectObject: palign

intervals = Get number of intervals: 1

speech_intervals = Get number of intervals: 3
sound = Read from file: "'directory_alignment$'/'speaker$'.wav"
textgrid = To TextGrid: "release_c1", "release_c1"

for speech_interval to speech_intervals
    selectObject: palign
    speech_label$ = Get label of interval: 3, speech_interval
    if speech_label$ == "speech"
        speech_start = Get start time of interval: 3, speech_interval
        token_interval = Get interval at time: 2, speech_start
        token_end = Get end time of interval: 2, token_interval
        # Get interval number of /p/ (C1)
        phone_interval = Get interval at time: 1, token_end
        start_consonant = Get start time of interval: 1, phone_interval
        end_consonant = Get end time of interval: 1, phone_interval

        selectObject: sound
        sound_consonant = Extract part: start_consonant, end_consonant,
            ..."rectangular", 1, "yes"

        Filter (pass Hann band): 400, 0, 100
        sound_band = selected("Sound")
        
        spectrum = To Spectrum: "no"
        Rename: "original"
        
        spectrum_hilbert = Copy: "hilbert"
        Formula: "if row=1 then Spectrum_original[2,col] else -Spectrum_original[1,col] fi"
        sound_hilbert = To Sound
        samples = Get number of samples
        Formula: "abs(self)"
        matrix = Down to Matrix
        period = Get column distance

        m1_time = 0.006
        m2_time = 0.016
        
        for sample from 1 to samples
            current = sample * period
            selectObject: sound_hilbert
            mean_before = Get mean: 1, current - m1_time - m2_time, current - m1_time
            mean_after = Get mean: 1, current + m1_time, current + m1_time + m2_time
            window_average = (mean_before + mean_after) / 2
            current_value = Get value at time: 1, current, "Sinc70"
            plosion = current_value / window_average
        
            if plosion == undefined
                plosion = 0
            elif plosion < 3
                plosion = 0
            endif
        
            selectObject: matrix
            Set value: 1, sample, plosion
        endfor
        
        To Sound
        Shift times by: start_consonant
        To PointProcess (extrema): 1, "yes", "no", "Sinc70"
        half_consonant = start_consonant + ((end_consonant - start_consonant) / 3) * 2
        Remove points between: start_consonant, half_consonant
        burst = Get time from index: 1

        selectObject: textgrid
        if burst <> undefined
            Insert point: 1, burst, "release_c1"
        endif
    endif
endfor

selectObject: textgrid
Save as text file: "'directory_alignment$'/'speaker$'-release-c1.TextGrid"
