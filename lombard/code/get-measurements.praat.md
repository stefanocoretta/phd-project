# Acoustic measurements script for Lombard

## get-measurements.praat
```praat
<<<preparation>>>

<<<file loop>>>
```

The script reads each `.wav` file in `data/rediver/audio/` and performs standard calculations.

## "preparation"
```praat
data_folder$ = "../data/derived/audio"
Create Strings as file list: "sound_list", "'data_folder$'/*.wav"
number_files = Get number of strings

createDirectory: "../results"
acoustic_file$ = "../results/acoustics.csv"
acoustic_header$ = "speaker,word,time,point,f1,f2,f3,pitch,sentence_norm"
writeFileLine: acoustic_file$, acoustic_header$
duration_file$ = "../results/durations.csv"
duration_header$ = "speaker,word,time,word_duration,vowel_duration,
    ...consonant_duration,sentence_norm"
writeFileLine: duration_file$, duration_header$
```

## "file loop"
```praat
for file from 1 to number_files
    select Strings sound_list
    file$ = Get string: file
    sound = Read from file: "'data_folder$'/'file$'"
    speaker$ = selected$("Sound")
    textgrid = Read from file: "'data_folder$'/'speaker$'-palign_copy.TextGrid"
    tokenisation = Read from file: "'data_folder$'/'speaker$'-token.TextGrid"

    <<<vowel loop>>>
endfor
```

## "vowel loop"
```praat
selectObject: textgrid
number_intervals = Get number of intervals: 2

for interval from 1 to number_intervals
    selectObject: textgrid
    label$ = Get label of interval: 2, interval
    if label$ == "V"
        vowel_start = Get start time of interval: 2, interval
        vowel_end = Get end time of interval: 2, interval
        vowel_duration = vowel_end - vowel_start
        step = vowel_duration / 11
        word_interval = Get interval at time: 3, vowel_start
        word$ = Get label of interval: 3, word_interval
        word_start = Get start time of interval: 3, word_interval
        word_end = Get end time of interval: 3, word_interval
        word_duration = word_end - word_start
        consonant_duration = word_end - vowel_end

        selectObject: tokenisation
        sentence_interval = Get interval at time: 1, word_start
        sentence_norm$ = Get label of interval: 1, sentence_interval

        appendFileLine: duration_file$, "'speaker$','word$','word_start',
            ...'word_duration','vowel_duration','consonant_duration',
            ...'sentence_norm$'"

        selectObject: sound
        sound_part = Extract part: vowel_start - 0.05, vowel_end + 0.05, "rectangular", 1, "yes"
        noprogress To Formant (burg): 0, 5, 5500, 0.025, 50
        formant = selected("Formant")
        selectObject: sound_part
        noprogress To Pitch: 0, 75, 600
        pitch = selected("Pitch")

        for point from 1 to 10
            selectObject: formant
            point_time = vowel_start + (step * point)
            f1 = Get value at time: 1, point_time, "Hertz", "Linear"
            f2 = Get value at time: 2, point_time, "Hertz", "Linear"
            f3 = Get value at time: 3, point_time, "Hertz", "Linear"

            selectObject: pitch
            pitch_value = Get value at time: point_time, "Hertz", "Linear"

            appendFileLine: acoustic_file$, "'speaker$','word$','word_start',
                ...'point','f1','f2','f3','pitch_value','sentence_norm$'"
        endfor

    endif
endfor
```

`step` is the duration between each measurement point such that there are 10 points independently of the duration of the vowel.
