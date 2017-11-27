# EGG scripts for Lombard

## Calculate VUV intervals

This script detects the voiced and non-voiced intervals based on the EGG signal.

### get-voicing.praat
```praat
<<<smoothing>>>

<<<file list>>>

<<<vuv>>>
```

### "file list"
```praat
form Extract vuv
    comment Specify the lower and upper frequency (in Hz) for filtering:
    real lower 40
    real upper 10000
    comment Specify the smooth width "m" (the number of points):
    real smooth_width 11
    boolean debug_mode
endform

directory$ = "../data/raw/audio"
directory_tg$ = "../data/derived/audio"
results_file$ = "../results/voicing.csv"


Create Strings as file list: "file_list", "'directory$'/*.wav"
files = Get number of strings

writeFileLine: results_file$, "speaker,word,word_start,consonant_duration,
    ...voicing_duration,sentence_norm"
```

Set a few parameters and get a list of the `.wav` files in `/data/raw`.

### "vuv"
```praat
for file from 1 to files
    selectObject: "Strings file_list"
    file$ = Get string: file
    Read from file: "'directory$'/'file$'"
    file_name$ = selected$("Sound")
    speaker$ = file_name$
    Extract one channel: 2
    egg$ = selected$("Sound")

    <<<to vuv>>>

    <<<voicing>>>

    <<<remove objects>>>
endfor

removeObject: "Strings file_list"
```

For each file in the list, extract channel 2, which contains the EGG signal, create a TextGrid with the voiced and non-voiced (VUV) intervals, then remove objects if `debug_mode == 0`.

#### "to vuv"
```praat
Filter (pass Hann band): lower, upper, 100
@smoothing: smooth_width

To PointProcess (periodic, cc): 75, 600

vuv = To TextGrid (vuv): 0.02, 0.001
```

To extract the VUV intervals, pass filter and smooth the EGG signal, create a PointProcess object and create a VUV TextGrid from the PointProcess object.

### "voicing"
```praat
textgrid = Read from file: "'directory_tg$'/'file_name$'-palign_copy.TextGrid"
textgrid$ = selected$("TextGrid")
tokenisation = Read from file: "'directory_tg$'/'speaker$'-token.TextGrid"

selectObject: textgrid
plusObject: vuv
Merge
merged = selected()

number_of_vowels = Get number of intervals: 3

for vowel from 1 to number_of_vowels
    label$ = Get label of interval: 3, vowel
    if label$ == "V"
        consonant_onset = Get end time of interval: 3, vowel
        consonant_interval = Get interval at time: 2, consonant_onset
        consonant_offset = Get end time of interval: 2, consonant_interval
        consonant_duration = consonant_offset - consonant_onset
        vuv_interval = Get interval at time: 1, consonant_onset
        vuv_label$ = Get label of interval: 1, vuv_interval
        word = Get interval at time: 4, consonant_onset
        word_start = Get start time of interval: 4, word
        word$ = Get label of interval: 4, word
        selectObject: tokenisation
        sentence_interval = Get interval at time: 1, word_start
        sentence_norm$ = Get label of interval: 1, sentence_interval
        selectObject: merged

        if vuv_label$ == "U"
            voicing_duration = 0
        else
            voicing_offset = Get end time of interval: 1, vuv_interval

            if voicing_offset > consonant_offset
                voicing_duration = consonant_offset - consonant_onset
            else
                voicing_duration = voicing_offset - consonant_onset
            endif
        endif

        appendFileLine: results_file$, "'speaker$','word$','word_start',
            ...'consonant_duration','voicing_duration','sentence_norm$'"
    endif
endfor
```


### "remove objects"
```praat
if debug_mode == 0
    removeObject: "Sound " + file_name$, "Sound " + file_name$ + "_ch2",
    ..."Sound " + file_name$ + "_ch2_band", "PointProcess " + file_name$ + "_ch2_band",
    ..."TextGrid " + file_name$ + "-palign_copy", vuv, merged, tokenisation
endif
```

### "smoothing"
```praat
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
endproc
```
