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

directory$ = "../'project$'/data/derived/ultrasound/'speaker$'/alignment"

result_file$ = "../'project$'/results/'speaker$'-vowel-durations.csv"

header$ = "index,speaker,word,vowel.duration,closure.duration,
    ...sentence.duration"
writeFileLine: result_file$, header$

bursts = Read from file: "'directory$'/'speaker$'-burst.TextGrid"

palign = Read from file: "'directory$'/'speaker$'-palign.TextGrid"

intervals = Get number of intervals: 2
index = 0

for interval to intervals
    selectObject: palign
    label$ = Get label of interval: 2, interval
    if label$ == label_lang$
        index += 1
        word$ = Get label of interval: 2, interval + 1
        start_target = Get start time of interval: 2, interval + 1
        start_consonant = Get interval at time: 1, start_target
        start_vowel = Get start time of interval: 1, start_consonant + 1
        end_vowel = Get end time of interval: 1, start_consonant + 1
        v_duration = (end_vowel - start_vowel) * 1000
        sentence_interval = Get interval at time: 3, start_target
        start_sentence = Get start time of interval: 3, sentence_interval
        end_sentence = Get end time of interval: 3, sentence_interval
        sentence_duration = end_sentence - start_sentence

        selectObject: bursts
        burst_interval = Get nearest index from time: 1, end_vowel
        burst = Get time of point: 1, burst_interval
        if burst < end_vowel or burst > end_sentence
            burst = undefined
        endif

        closure = (burst - end_vowel) * 1000

        result_line$ = "'index','speaker$','word$','v_duration','closure','sentence_duration'"
        appendFileLine: "'result_file$'", "'result_line$'"
    endif
endfor

removeObject: palign, bursts
