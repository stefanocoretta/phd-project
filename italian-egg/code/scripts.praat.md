# Stop release detection

This script detects the release of C1 and C2. The algorythm is based on @avanthapadmanabha2014.

```praat release-detection.praat
<<<script header>>>

<<<file loop>>>

<<<findRelease>>>
```

```praat "file loop"
stereo$ = "../data/raw/stereo"
audio$ = "../data/raw/audio"

Create Strings as file list: "tg_list", "'stereo$'/*-palign-corrected.TextGrid"
tg_number = Get number of strings

for file from 1 to tg_number

  selectObject: "Strings tg_list"
  file$ = Get string: file
  Read from file: "'stereo$'/'file$'"
  palign = selected("TextGrid")
  speaker$ = file$ - "-palign-corrected.TextGrid"

  <<<find release>>>

endfor
```

The following procedure defines the algorithm.

```praat "findRelease"
###################
# Define findRelease procedure
###################

procedure findRelease: .start_time, .end_time, .label$
  selectObject: sound

  .sound_consonant = Extract part: .start_time, .end_time,
    ..."rectangular", 1, "yes"

  <<<hilbert>>>

  <<<plosion index>>>

endproc
```

To calculate the plosion index, it is first necessary to create the hilbert transform of the sound.

```praat "hilbert"
Filter (pass Hann band): 400, 0, 100
sound_band = selected("Sound")

spectrum = To Spectrum: "no"
Rename: "original"

spectrum_hilbert = Copy: "hilbert"
Formula: "if row=1 then Spectrum_original[2,col] else -Spectrum_original[1,col] fi"
sound_hilbert = To Sound
.samples = Get number of samples
Formula: "abs(self)"
matrix = Down to Matrix
.period = Get column distance
```

We can now calculate the plosion index.

```praat "plosion index"
.m1_time = 0.006
.m2_time = 0.016

for .sample from 1 to .samples
  .current = .sample * .period
  selectObject: sound_hilbert
  .mean_before = Get mean: 1, .current - .m1_time - .m2_time, .current - .m1_time
  .mean_after = Get mean: 1, .current + .m1_time, .current + .m1_time + .m2_time
  .window_average = (.mean_before + .mean_after) / 2
  .current_value = Get value at time: 1, .current, "Sinc70"
  .plosion = .current_value / .window_average

  if .plosion == undefined
    .plosion = 0
  elif .plosion < 3
    .plosion = 0
  endif

  selectObject: matrix
  Set value: 1, .sample, .plosion
endfor

To Sound
Shift times by: .start_time
To PointProcess (extrema): 1, "yes", "no", "Sinc70"
# .half_consonant = .start_time + ((.end_time - .start_time) / 3) * 2
# Remove points between: .start_time, .half_consonant
.release = Get time from index: 1

selectObject: textgrid
if .release <> undefined
  Insert point: 1, .release, .label$
endif
```

We start by identifying the inverval that corresponds to C2.

```praat "find release"
speech_intervals = Get number of intervals: 3
sound = Read from file: "'audio$'/'speaker$'.wav"
textgrid = To TextGrid: "release_c1, release_c2","release_c1, release_c2"

for speech_interval to speech_intervals

  selectObject: palign
  speech_label$ = Get label of interval: 3, speech_interval

  if speech_label$ == "speech"
    speech_start = Get start time of interval: 3, speech_interval
    frame_interval = Get interval at time: 2, speech_start
    frame_end = Get end time of interval: 2, frame_interval
    c1_interval = Get interval at time: 1, frame_end
    c2_interval = c1_interval + 2

    c1_start = Get start time of interval: 1, c1_interval
    c1_end = Get end time of interval: 1, c1_interval
    c2_start = Get start time of interval: 1, c2_interval
    c2_end = Get end time of interval: 1, c2_interval

    @findRelease: c1_start, c1_end, "release_c1"

    @findRelease: c2_start, c2_end, "release_c2"
  endif

endfor

selectObject: textgrid
Save as text file: "'audio$'/'speaker$'-rel.TextGrid"
```

# Voice onset/offset detection

This script finds the onsent and offset of the voicing interval that includes V1.

```praat voicing-detection.praat
<<<script header>>>

<<<egg loop>>>

appendInfoLine: "Done!"
```

Each EGG file is smoothed with a weighted moving average and a VUV textgrid is created.

```praat "egg loop"
stereo$ = "../data/raw/stereo"
egg$ = "../data/raw/egg"

Create Strings as file list: "tg_list", "'stereo$'/*-palign-corrected.TextGrid"
tg_number = Get number of strings

writeInfoLine: "Found 'tg_number' files.'newline$'Starting now...'newline$'"

for file from 1 to tg_number

  selectObject: "Strings tg_list"
  file$ = Get string: file

  speaker$ = file$ - "-palign-corrected.TextGrid"
  appendInfoLine: "Processing 'speaker$'..."

  Read from file: "'stereo$'/'file$'"
  palign = selected("TextGrid")
  Read from file: "'egg$'/'speaker$'_egg.wav"
  egg = selected("Sound")

  <<<vuv>>>

  <<<smoothing>>>

endfor
```

```praat "vuv"
appendInfoLine: "'tab$'Smoothing..."

@smoothing: 11

appendInfoLine: "'tab$'VUV..."

noprogress To PointProcess (periodic, cc): 75, 600

To TextGrid (vuv): 0.02, 0

Write to text file: "'egg$'/'speaker$'-vuv.TextGrid"
```

```praat "smoothing"
procedure smoothing : .width
    .weight = .width / 2 + 0.5

    .formula$ = "( "

    for .w to .weight - 1
        .formula$ = .formula$ + string$(.w) + " * (self [col - " + string$(.w) + "] +
            ...self [col - " + string$(.w) + "]) + "
    endfor

    .formula$ = .formula$ + string$(.weight) + " * (self [col]) ) / " +
        ...string$(.weight ^ 2)

    Formula: .formula$

    .sampling_period = Get sampling period
    .time_lag = (.width - 1) / 2 * .sampling_period
    Shift times by: .time_lag
endproc
```

# Script header

```praat "script header"
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
```