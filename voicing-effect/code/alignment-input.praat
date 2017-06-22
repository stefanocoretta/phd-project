form Generate input for force alignment with SPPAS
    word project voicing-effect
    word speaker it01
endform

directory_speaker$ = "../data/derived/ultrasound/'speaker$'"
directory_audio$ = "'directory_speaker$'/audio"
createDirectory ("'directory_speaker$'/alignment")
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
