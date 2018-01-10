form Wavegram
    word speaker it01
endform

lower = 40
upper = 10000
smoothWidth = 11
results$ = "../results/wavegram"
directory_textgrid$ = "../data/derived/ultrasound/'speaker$'/audio"
createDirectory(results$)
directory$ = "../data/derived/egg/'speaker$'"
resultsHeader$ = "speaker,file,date,word,rel_time,time,sequence,sample,amplitude"
resultsFile$ = "'results$'/'speaker$'-wavegram.csv"
writeFileLine: resultsFile$, resultsHeader$
fileList = Create Strings as file list: "fileList", "'directory$'/*.wav"
numberOfFiles = Get number of strings

#### Files loop ####
for file to numberOfFiles
    selectObject: fileList
    file$ = Get string: file
    filename$ = file$ - ".wav"

    Read Strings from raw text file: "'directory_textgrid$'/'filename$'.txt"
    prompt$ = Get string: 1
    stimulus$ = extractWord$(prompt$, " ")
    date$ = Get string: 2

    Read separate channels from sound file: "'directory$'/'file$'"

    Read from file: "'directory_textgrid$'/'filename$'.TextGrid"
    intervals = Get number of intervals: 3

    if intervals > 1
        start = Get starting point: 3, 2
        end = Get end point: 3, 2

        selectObject: "Sound 'filename$'_ch2"
        ; Extract part: start, end, "rectangular", 1, "yes"
        Rename: "egg"

        #### Vowel loop ####
        eggSmooth = Filter (pass Hann band): lower, upper, 100
        @smoothing: smoothWidth
        sampling_period = Get sampling period
        time_lag = (smoothWidth - 1) / 2 * sampling_period
        Shift times by: time_lag
        Rename: "egg_smooth"
        eggPointProcess = noprogress To PointProcess (periodic, peaks): 75, 600, "yes", "no"
        pp_end = Get end time
        Remove points between: 0, start
        Remove points between: end, pp_end
        
        selectObject: eggSmooth
        deggSmooth = Copy: "degg_smooth"
        Formula: "self [col + 1] - self [col]"
        ; @smoothing: smoothWidth
        Remove noise: 0, 0.25, 0.025, 80, 10000, 40, "Spectral subtraction"
        ; sampling_period = Get sampling period
        ; time_lag = (smoothWidth - 1) / 2 * sampling_period
        ; Shift times by: time_lag
        deggPointProcess = noprogress To PointProcess (periodic, peaks): 75, 600, "yes", "no"
        Remove points between: 0, start
        Remove points between: end, pp_end
        
        selectObject: eggPointProcess
        eggPoints = Get number of points
        meanPeriod = Get mean period: 0, 0, 0.0001, 0.02, 1.3
        
        sequence = 0
        
        for point to eggPoints - 2
            selectObject: eggPointProcess
            point1 = Get time from index: point
            point2 = Get time from index: point + 1
            point3 = Get time from index: point + 2
            selectObject: eggSmooth
            eggMinimum1 = Get time of minimum: point1, point2, "Sinc70"
            eggMinimum2 = Get time of minimum: point2, point3, "Sinc70"
            period = eggMinimum2 - eggMinimum1
        
            if period <= meanPeriod * 2
                selectObject: deggSmooth
                minAmplitude = Get minimum: eggMinimum1, eggMinimum2, "Sinc70"
                maxAmplitude = Get maximum: eggMinimum1, eggMinimum2, "Sinc70"
            
                sampleStart = Get sample number from time: eggMinimum1
                sampleEnd = Get sample number from time: eggMinimum2
                numberOfSamples = sampleEnd - sampleStart
                sample = sampleStart
            
                timeNorm = (eggMinimum1 - start) /
                    ...(end - start)
            
                while sample <= sampleEnd
                    amplitude = Get value at sample number: 1, sample
            
                    amplitudeNorm = (amplitude - minAmplitude) /
                        ...(maxAmplitude - minAmplitude)
            
                    sampleNorm = (sample - sampleStart) /
                        ...(sampleEnd - sampleStart)
            
                    # At sample rate 44100 Hz, each period has around 400 samples
                    sample = sample + 2
            
                    resultLine$ = "'speaker$','filename$','date$','stimulus$','egg_minimum_1','timeNorm','sequence','sampleNorm','amplitudeNorm'"
            
                    appendFileLine: resultsFile$, resultLine$
                endwhile
            endif
        
            sequence = sequence + 1
        endfor
    endif

    ; removeObject: "Sound egg", "Sound egg_smooth",
    ;     ..."PointProcess egg_smooth",
    ;     ..."Sound degg_smooth", "PointProcess degg_smooth", "Sound degg"

endfor

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
