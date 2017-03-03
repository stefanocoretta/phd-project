form Select folder with TextGrid
    word project pilot
    word speaker SC01
    comment Supported languages: it, pl
    word language it
endform

if language$ == "it"
    label_lang$ = "k"
    label_2_lang$ = "dico"
elif language$ == "pl"
    label_lang$ = "j"
    label_2_lang$ = "mówię"
else
    exit "The language you selected is not valid"
endif

directory_audio$ = "../'project$'/data/derived/ultrasound/'speaker$'/audio"
directory_alignment$ = "../'project$'/data/derived/ultrasound/
    ...'speaker$'/alignment"

palign = Read from file: "'directory_alignment$'/'speaker$'-palign.TextGrid"

intervals = Get number of intervals: 1

speech_intervals = Get number of intervals: 3
sound = Read from file: "'directory_alignment$'/'speaker$'.wav"
textgrid = To TextGrid: "burst","burst"

for speech_interval to speech_intervals
    selectObject: palign
    speech_label$ = Get label of interval: 3, speech_interval
    if speech_label$ == "speech"
        speech_start = Get start time of interval: 3, speech_interval
        token_interval = Get interval at time: 2, speech_start
        token_end = Get end time of interval: 2, token_interval
        phone_interval = Get interval at time: 1, token_end
        start_consonant = Get start time of interval: 1, phone_interval + 2
        end_consonant = Get end time of interval: 1, phone_interval + 2

        selectObject: sound
        sound_consonant = Extract part: start_consonant, end_consonant,
            ..."rectangular", 1, "yes"

        Filter (pass Hann band): 400, 0, 100
        sound_band = selected("Sound")
        
        spectrum = To Spectrum: "no"
        Rename: "original"
        
        spectrum_hilbert = Copy: "hilbert"
        Formula: "if row=1 then Spectrum_original[2,col] else -Spectrum_original[1,col] fi"
        sound_hilbert = To Sound
        samples = Get number of samples
        Formula: "abs(self)"
        matrix = Down to Matrix
        period = Get column distance

        m1_time = 0.006
        m2_time = 0.016
        
        for sample from 1 to samples
            current = sample * period
            selectObject: sound_hilbert
            mean_before = Get mean: 1, current - m1_time - m2_time, current - m1_time
            mean_after = Get mean: 1, current + m1_time, current + m1_time + m2_time
            window_average = (mean_before + mean_after) / 2
            current_value = Get value at time: 1, current, "Sinc70"
            plosion = current_value / window_average
        
            if plosion == undefined
                plosion = 0
            elif plosion < 3
                plosion = 0
            endif
        
            selectObject: matrix
            Set value: 1, sample, plosion
        endfor
        
        To Sound
        Shift times by: start_consonant
        To PointProcess (extrema): 1, "yes", "no", "Sinc70"
        half_consonant = start_consonant + ((end_consonant - start_consonant) / 3) * 2
        Remove points between: start_consonant, half_consonant
        burst = Get time from index: 1

        selectObject: textgrid
        if burst <> undefined
            Insert point: 1, burst, "burst"
        endif
    endif
endfor

selectObject: textgrid
Save as text file: "'directory_alignment$'/'speaker$'-burst.TextGrid"
