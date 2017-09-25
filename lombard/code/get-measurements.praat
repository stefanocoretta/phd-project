data_folder$ = "../data/derived/audio"
Create Strings as file list: "sound_list", "'data_folder$'/*.wav"
number_files = Get number of strings

createDirectory: "../results"
result_file$ = "../results/formants.csv"
header$ = ""
writeFileLine: result_file$, header$

for file from 1 to number_files
    select Strings sound_list
    file$ = Get string: file
    sound = Read from file: "'data_folder$'/'file$'"
    speaker$ = selected$("Sound")
    textgrid = Read from file: "'data_folder$'/'speaker$'-palign_copy.TextGrid"

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
    
            selectObject: sound
            sound_part = Extract part: vowel_start - 0.05, vowel_end + 0.05, "rectangular", 1, "yes"
            formant = To Formant (burg): 0, 5, 5500, 0.025, 50
            pitch = To Pitch: 0, 75, 600
    
            for point from 1 to 10
                selectObject: formant
                point_time = vowel_start + (step * point)
                f1 = Get value at time: 1, point_time, "Hertz", "Linear"
                f2 = Get value at time: 2, point_time, "Hertz", "Linear"
                f3 = Get value at time: 3, point_time, "Hertz", "Linear"
    
                selectObject: pitch
                pitch_value = Get value at time: point_time, "Hertz", "Linear"
    
                writeFileLine: result_file$, "'speaker$','word$','point',
                    ...'point_time','f1','f2','f3','pitch_value','vowel_duration'"
            endfor
    
        endif
    endfor
endfor
