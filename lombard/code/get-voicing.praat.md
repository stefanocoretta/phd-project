# Extraction of voicing durations

## get-voicing.praat
```praat
<<<preparation>>>

<<<file loop>>>

<<<smoothing>>>
```

The script reads each `.wav` file in `data/raw/audio/` and extracts voicing durations from the EGG signal.

## "preparation"
```praat
data_folder$ = "../data/raw/audio"
textgrid_folder$ = "../data/derived/audio"
Create Strings as file list: "sound_list", "'data_folder$'/*.wav"
number_files = Get number of strings

createDirectory: "../results"
voicing_file$ = "../results/voicing.csv"
voicing_header$ = "speaker,word,time,word_duration,vowel_duration,
    ...consonant_duration,voicing_duration,sentence_norm"
writeFileLine: acoustic_file$, acoustic_header$
```

## "file loop"
```praat
for file from 1 to number_files
    selectObject: "Strings sound_list"
    file$ = Get string: file
    sound = Read from file: "'data_folder$'/'file$'"
    speaker$ = selected$("Sound")
    textgrid = Read from file: "'textgrid_folder$'/'speaker$'-palign_copy.TextGrid"
    tokenisation = Read from file: "'textgrid_folder$'/'speaker$'-token.TextGrid"

    <<<filter egg>>>

    <<<word loop>>>
endfor
```

## "filter egg"
```praat
selectObject: sound
egg = Extract one channel: 2
Filter (pass Hann band): 40, 10000, 100
@smoothing: 11
To PointProcess (periodic, cc): 75, 600
vuv = To TextGrid (vuv): 0.02, 0.001
```

## "smoothing"
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
