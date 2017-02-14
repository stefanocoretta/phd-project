form Get vowel duration
    word project pilot
    word speaker SC01
    comment Supported languages: it, pl
    word language it
endform

if language$ == "it"
    label_lang$ = "dico"
elif language$ == "pl"
    label_lang$ = "mówię"
else
    exit "The language you selected is not valid"
endif

directory$ = "../../'project$'/data/derived/ultrasound/'speaker$'/alignment"

result_file$ = "../../'project$'/results/'speaker$'-vowel-durations.csv"

header$ = "index,speaker,word,duration"
writeFileLine: result_file$, header$

palign = Read from file: "'directory$'/'speaker$'-palign.TextGrid"

intervals = Get number of intervals: 2
index = 0

for interval to intervals
    label$ = Get label of interval: 2, interval
    if label$ == label_lang$
        index += 1
        word$ = Get label of interval: 2, interval + 1
        start_target = Get starting point: 2, interval + 1
        start_consonant = Get interval at time: 1, start_target
        start_vowel = Get starting point: 1, start_consonant + 1
        end_vowel = Get end point: 1, start_consonant + 1
        v_duration = (end_vowel - start_vowel) * 1000

        result_line$ = "'index','speaker$','word$','v_duration'"
        appendFileLine: "'result_file$'", "'result_line$'"
    endif
endfor

removeObject: palign
