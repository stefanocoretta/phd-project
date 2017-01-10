# Documentation of data processing

## Prepare files for force alignment in SPPAS

### alignment_input.praat
```praat
<<<get audio>>>

<<<concatenate recoverably>>>

<<<write sppas>>>
```

The following chunk asks the user for the name of the project directory and the participant ID. Then it reads the audio files from the `audio` directory (whih contains the audio files exported from `AAA`). The directory `alignment` is created as well.

### "get audio"
```praat
form Generate input for force alignment with SPPAS
    word project pilot
    word speaker SC01
endform

directory_speaker$ = "../../'project$'/data/derived/ultrasound/'speaker$'"
directory_audio$ = "'directory_speaker$'/audio"
createDirectory ("'directory$'/alignment")
directory_alignment$ = "'directory_speaker$'/alignment"
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
```

The following select all objects except the file list and concatenates the sound objects. SPASS needs a tier named `Orthography`, so we create one. Then, the script loops through the intervals in the TextGrid which correspond to the names of the files, it writes the prompt in the interval and in the text file for IPU detection.

### "concatenate recoverably"
```praat
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
```

Finally, we can save the concatenated sound file and the TextGrid with the file names. The latter will be used in the script `search-area.praat` to separate the concatenated TextGrid.

### "write sppas"
```praat
selectObject: "Sound chain"
Save as WAV file: "'directory_alignment$'/'speaker$'.wav"

selectObject: "TextGrid chain"
Copy: "filenames"
Remove tier: 1
Save as text file: "'directory_alignment$'/filenames.TextGrid"
```

## Extract the search area for spline batch processing and kinematics in `AAA`

### search_area.praat
```praat
<<<get alignment>>>

<<<set search>>>

<<<extract search>>>
```

The user is prompt to indicate the project name, the participant ID and the language. Depending on the language selected, the appropriate speech segments are stored for subsequent extraction of the search area. Then the script read the TextGrid file with the force alingment (`ID-palign.TextGrid`). The number of intervals of the TextGrid file is saved in `intervals` and two new tiers are created (`ultrasound` and `kinematics`)

### "get alignment"
```praat
form Select folder with TextGrid
    word project pilot
    word speaker SC01
    comment Supported languages: it, pl
    word language it
endform

if language$ == "it"
    label_lang$ = "k"
    label_2_lang$ = "dico"
elif language == "pl"
    label_lang$ = "j"
    label_2_lang$ = "móvię"
else
    exit "The language you selected is not valid"
endif

directory_audio$ = "../../'project$'/data/derived/ultrasound/'speaker$'/audio"
directory_alignment$ = "../../'project$'/data/derived/ultrasound/'speaker$'/alignment"

palign = Read from file: "'directory_alignment$'/'speaker$'-palign.TextGrid"

intervals = Get number of intervals: 1

Insert interval tier: 4, "ultrasound"
Insert interval tier: 5, "kinematics"
```

Now we can create intervals cointaing the search area for ultrasound and kinematics which will be used in `AAA` for spline batch processing and to find consonantal gestures moments. Then, `search.TextGrid` is saved in the `alignmet` folder.

### "set search"
```praat
for interval to intervals
    label$ = Get label of interval: 1, interval
    if label$ == label_lang$
        start_ultrasound = Get starting point: 1, interval
        interval_2 = Get interval at time: 2, start_ultrasound
        label_2$ = Get label of interval: 2, interval_2
        if label_2$ == label_2_lang$
            end_ultrasound = Get end point: 1, interval + 7
            Insert boundary: 4, start_ultrasound
            Insert boundary: 4, end_ultrasound
            ultrasound = Get interval at time: 4, start_ultrasound
            Set interval text: 4, ultrasound, "ultrasound"

            start_kinematics_1 = Get start point: 1, interval + 3
            start_kinematics_2 = Get end point: 1, interval + 3
            start_kinematics = start_kinematics_1 + ((start_kinematics_2 - start_kinematics_1) / 2)
            end_kinematics_1 = Get start point: 1, interval + 5
            end_kinematics_2 = Get end point: 1, interval + 5
            end_kinematics = end_kinematics_1 + ((end_kinematics_2 - end_kinematics_1) / 2)
            Insert boundary: 5, start_kinematics
            Insert boundary: 5, end_kinematics
            kinematics = Get interval at time: 5, start_kinematics
            Set interval text: 5, kinematics, "kinematics"
        endif
    endif
endfor

Remove tier: 1
Remove tier: 1
Remove tier: 1

Save as text file: "'directory_alignment$'/search.TextGrid"
```

Then, the script saves each search area to separate TextGrids in the `audio` folder. The file names are extracted from `ID-filenames.TextGrid`.

### "extract search"
```praat
filenames = Read from file: "'directory_alignment$'/'speaker$'-filenames.TextGrid"
filenames_tier = 3

selectObject: palign
plusObject: filenames

Merge

intervals = Get number of intervals: filenames_tier

for interval from 1 to intervals
    selectObject: "TextGrid merged"
    start = Get start point: filenames_tier, interval
    end  = Get end point: filenames_tier, interval
    filename$ = Get label of interval: filenames_tier, interval

    Extract part: start, end, "no"

    Remove tier: filenames_tier
    Write to text file: "'directory_audio$'/'filename$'.TextGrid"
    Remove
endfor
```
