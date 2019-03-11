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

writeInfoLine: "Initialise...'newline$'"
mono_dir$ = "../data/raw/mono"

wav_list = Create Strings as file list: "wav_list", "'mono_dir$'/*.wav"
files = Get number of strings
appendInfoLine: "> Found 'files' sound files."

for file from 1 to files
  selectObject: wav_list
  file_name$ = Get string: file
  speaker$ = file_name$ - ".wav"
  appendInfoLine: "'newline$'Processing speaker 'speaker$'."
  appendInfo: ""

  if fileReadable("'mono_dir$'/'speaker$'-annotation.TextGrid")
    appendInfoLine: "Found annotation file for 'speaker$'. Skipping to the next speaker."
    appendInfo: ""
    goto next
  endif

  sound = Read from file: "'mono_dir$'/'file_name$'"
  # The new tg:
  textgrid = To TextGrid: "sentence, word, phones, release", "release"
    # Tiers indexes of textgrid
    sentence_tier = 1
    word_tier = 2
    phones_tier = 3
    release_tier = 4

  palign = Read from file: "'mono_dir$'/'speaker$'-palign-corrected.TextGrid"
    # Tiers indexes of paling
    activity_tier = 4
    tokens_tier = 2
    phon_tier = 1

  # The tg with the sentences:
  sentences = Read from file: "'mono_dir$'/'speaker$'.TextGrid"

  selectObject: palign
  speech_intervals = Get number of intervals: activity_tier
  
  for speech_interval to speech_intervals
      selectObject: palign
      speech_label$ = Get label of interval: activity_tier, speech_interval
      if speech_label$ == "speech"
  
          # Sentence
          speech_start = Get start time of interval: activity_tier, speech_interval
          speech_end = Get end time of interval: activity_tier, speech_interval
          selectObject: textgrid
          Insert boundary: sentence_tier, speech_start
          Insert boundary: sentence_tier, speech_end
          selectObject: sentences
          this_sentence = Get interval at time: 1, speech_start
          this_sentence$ = Get label of interval: 1, this_sentence
          if this_sentence$ == "#"
            this_sentence$ = Get label of interval: 1, this_sentence + 1
          endif
          selectObject: textgrid
          this_sentence_new = Get interval at time: sentence_tier, speech_start
          Set interval text: sentence_tier, this_sentence_new, this_sentence$
  
          # Word
          selectObject: palign
          word_1 = Get interval at time: tokens_tier, speech_start
          word_interval = word_1 + 2
          word$ = Get label of interval: tokens_tier, word_interval
          word_start = Get start time of interval: tokens_tier, word_interval
          word_end = Get end time of interval: tokens_tier, word_interval
          selectObject: textgrid
          Insert boundary: word_tier, word_start
          Insert boundary: word_tier, word_end
          word_new = Get interval at time: word_tier, word_start
          Set interval text: word_tier, word_new, word$
  
          # Phones
          selectObject: palign
          p_1 = Get interval at time: phon_tier, word_start
          p_1$ = Get label of interval: phon_tier, p_1
          p_1_start = Get start time of interval: phon_tier, p_1
          if p_1_start != word_start
            appendInfoLine: "'tab$'Found a misaligned phone at interval 'p_1'!"
          endif
          p_2_start = Get end time of interval: phon_tier, p_1
          p_2$ = Get label of interval: phon_tier, p_1 + 1
          p_3_start = Get start time of interval: phon_tier, p_1 + 2
          p_3_end = Get end time of interval: phon_tier, p_1 + 2
          p_3$ = Get label of interval: phon_tier, p_1 + 2
          selectObject: textgrid
          Insert boundary: phones_tier, p_1_start
          Insert boundary: phones_tier, p_2_start
          Insert boundary: phones_tier, p_3_start
          Insert boundary: phones_tier, p_3_end
          p_1_new = Get interval at time: phones_tier, p_1_start
          Set interval text: phones_tier, p_1_new, p_1$
          Set interval text: phones_tier, p_1_new + 1, p_2$
          Set interval text: phones_tier, p_1_new + 2, p_3$
  
          @detect: p_1_start, p_2_start
          @detect: p_3_start, p_3_end
  
      endif
  endfor
  
  selectObject: textgrid
  Save as text file: "'mono_dir$'/'speaker$'-annotation.TextGrid"

  removeObject: sound, textgrid, palign, sentences

  label next
endfor

procedure detect: start_time, end_time
  selectObject: sound
  sound_consonant = Extract part: start_time, end_time,
      ..."rectangular", 1, "yes"

  Filter (pass Hann band): 400, 0, 100
  sound_filt = selected("Sound")
  
  spectrum = To Spectrum: "no"
  Rename: "original"
  
  spectrum_hilbert = Copy: "hilbert"
  # Hibbert transform
  Formula: "if row=1 then Spectrum_original[2,col] else -Spectrum_original[1,col] fi"
  sound_hilbert = To Sound
  # We need the num of samples in "plosion index"
  samples = Get number of samples
  Formula: "abs(self)"
  matrix = Down to Matrix
  period = Get column distance

  # Defaults in @avanthapadmanabha2014
  m1_time = 0.006
  m2_time = 0.016
  
  for sample from 1 to samples ; the number of samples of sound_hilbert
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
  plosion_sound = Shift times by: start_time
  plosion_pp = To PointProcess (extrema): 1, "yes", "no", "Sinc70"
  
  # To reduce detection error when there is noise in the first part of the consonant
  Remove points between: start_time, start_time + 0.015
  # The time of the burst onset
  burst_onset = Get time from index: 1

  selectObject: textgrid
  if burst_onset <> undefined
      Insert point: release_tier, burst_onset, "release"
  endif

  removeObject: sound_consonant, sound_filt, spectrum, spectrum_hilbert, sound_hilbert, matrix,
    ...plosion_sound, plosion_pp
endproc
