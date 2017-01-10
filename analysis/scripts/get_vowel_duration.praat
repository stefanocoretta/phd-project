form Select folder with files
    text directory /Volumes/humrss$/Common/data/pilot/ultrasound/SC01/audio/alignment
    text speaker SC
endform

result_file$ = "'directory$'/vowel-durations.csv"

header$ = "index,word,duration"
writeFileLine: "'result_file$'", "'header$'"

Read from file: "'directory$'/'speaker$'.wav"
Read from file: "'directory$'/'speaker$'-manual.TextGrid"

intervals = Get number of intervals: 2
index = 0

for interval to intervals
    label$ = Get label of interval: 2, interval
    if label$ == "dico"
        index += 1
        word$ = Get label of interval: 2, interval + 1
        start_target = Get starting point: 2, interval + 1
        start_consonant = Get interval at time: 1, start_target
        start_vowel = Get starting point: 1, start_consonant + 1
        end_vowel = Get end point: 1, start_consonant + 1
        v_duration = (end_vowel - start_vowel) * 1000

        result_line$ = "'index','word$','v_duration'"
        appendFileLine: "'result_file$'", "'result_line$'"
    endif
endfor

select all
Remove
