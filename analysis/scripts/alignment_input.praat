

form Generate input for force alignment with SPPAS
    word directory /Volumes/humrss$/Common/data/pilot/ultrasound/SC01/audio
    word speaker SC
endform

createDirectory ("'directory$'/alignment")
writeFile: "'directory$'/alignment/'speaker$'.txt", ""

Create Strings as file list: "filelist", "'directory$'/*.wav"
files = Get number of strings

for file from 1 to files
    select Strings filelist
    file$ = Get string: file
    Read from file: "'directory$'/'file$'"
    soundID = selected("Sound")
    filebare$ = file$ - ".wav"
endfor

select all
minus Strings filelist
Concatenate recoverably

select Sound chain
Rename: "'speaker$'"
select TextGrid chain
Rename: "'speaker$'"

select Sound 'speaker$'
select TextGrid 'speaker$'
Duplicate tier: 1, 1, "Orthography"

intervals = Get number of intervals: 1

for interval from 1 to intervals
    start = Get start point: 1, interval
    end  = Get end point: 1, interval
    filename$ = Get label of interval: 1, interval

    Read Strings from raw text file: "'directory$'/'filename$'.txt"
    stimulus$ = Get string: 1
    select TextGrid 'speaker$'
    Set interval text: 1, interval, "'stimulus$'"
    appendFileLine: "'directory$'/alignment/'speaker$'.txt", "'stimulus$'"
endfor

select Sound 'speaker$'
Save as WAV file: "'directory$'/alignment/'speaker$'.wav"

select TextGrid 'speaker$'
Copy: "'speaker$'_filenames"
Remove tier: 1
Save as text file: "'directory$'/alignment/'speaker$'_filenames.TextGrid"
