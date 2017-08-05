lower = 40
upper = 10000
smoothWidth = 11
results$ = "../results"
createDirectory(results$)
data$ = "../data"
resultsHeader$ = "file,token,time,sequence,sample,amplitude"
resultsFile$ = "'results$'/wavegram.csv"
writeFileLine: resultsFile$, resultsHeader$
fileList = Create Strings as file list: "fileList", data$
numberOfFiles = Get number of strings

#### Files loop ####
for file from 1 to numberOfFiles
    selectObject: fileList
    fileName$ = Get string: file
    fileBareName$ = fileName$ - ".wav"
    sound = Read from file: "'data$'/'fileName$'"
    sound2 = Extract one channel: 2
    # signal is inverted when recorded
    Multiply: -1
    Filter (pass Hann band): lower, upper, 100
    pointProcess = To PointProcess (periodic, peaks): 75, 600, "no", "yes"
    textGrid = To TextGrid (vuv): 0.02, 0.001
    numberOfIntervals = Get number of intervals: 1

    #### Vowel loop ####
    token = 0
    for interval to numberOfIntervals
        selectObject: textGrid
        intervalLabel$ = Get label of interval: 1, interval
        if intervalLabel$ == "V"
            token += 1
            start = Get start time of interval: 1, interval
            end = Get end time of interval: 1, interval
            vowelDuration = end - start
            midPoint = start + (vowelDuration / 2)
            # Warning: The following two lines are easily breakable
            selectionStart = midPoint - 0.05
            selectionEnd = midPoint + 0.05
            selectObject: sound2
            selection = Extract part: selectionStart, selectionEnd, "rectangular",
                ...1, "yes"
    
            eggSmooth = Filter (pass Hann band): lower, upper, 100
            @smoothing: smoothWidth
            Rename: "egg_smooth"
            eggPointProcess = To PointProcess (periodic, peaks): 75, 600, "yes", "no"
            
            selectObject: eggSmooth
            deggSmooth = Copy: "degg_smooth"
            Formula: "self [col + 1] - self [col]"
            @smoothing: smoothWidth
            deggPointProcess = To PointProcess (periodic, peaks): 75, 600, "yes", "no"
    
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
                
                    timeNorm = (eggMinimum1 - selectionStart) /
                        ...(selectionEnd - selectionStart)
                
                    while sample <= sampleEnd
                        amplitude = Get value at sample number: 1, sample
                
                        amplitudeNorm = (amplitude - minAmplitude) /
                            ...(maxAmplitude - minAmplitude)
                
                        sampleNorm = (sample - sampleStart) /
                            ...(sampleEnd - sampleStart)
                
                        # At sample rate 44100 Hz, each period has around 400 samples
                        sample = sample + 2
                
                        resultLine$ = "'fileBareName$','token','timeNorm','sequence','sampleNorm','amplitudeNorm'"
                
                        appendFileLine: resultsFile$, resultLine$
                    endwhile
                endif
            
                sequence = sequence + 1
            endfor
    
            removeObject: selection
        endif
    endfor
endfor

procedure smoothing : .width
    .weight = .width / 2 + 0.5

    .formula$ = "( "

    for .w to .weight - 1
        .formula$ = .formula$ + string$(.w) + " * (self [col - " +
            ...string$(.w) + "] + self [col - " + string$(.w) + "]) + "
    endfor

    .formula$ = .formula$ + string$(.weight) + " * (self [col]) ) / " +
        ...string$(.weight ^ 2)

    Formula: .formula$
endproc
