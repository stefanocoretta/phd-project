# Wavegram analysis

This script extracts wavegram data from the EGG data.

## wavegram.praat
```praat
<<<preamble>>>

<<<main loop>>>

<<<smoothing>>>
```

## "preamble"
```praat
lower = 40
upper = 10000
smoothWidth = 11
results$ = "../results"
createDirectory(results$)
data$ = "../data"
resultsHeader$ = "file,token,time,"
resultsFile$ = "'results$'/wavegram.csv"
writeFileLine: resultsFile$, resultsHeader$
fileList = Create Strings as file list: "fileList", data$
numberOfFiles = Get number of strings
```

The preamble defines a few settings for filtering and smoothing, and the results file.

## "main loop"
```praat
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

    <<<vowel loop>>>
endfor
```

The main loop goes through each file, extracts the relevat portions using a vuv textgrid, and gets the numeric data.

## "vowel loop"
```praat
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
        selectionStart = midPoint - 0.25
        selectionEnd = midPoint + 0.25
        selectObject: sound2
        selection = Extract part: selectionStart, selectionEnd, "rectangular",
            ...1, "yes"

        <<<degg>>>

        <<<get periods>>>

        removeObject: selection
    endif
endfor
```

In this loop, each interval corresponding to an uttered vowel is extracted, the DEGG is calculated and the wavegram data is extracted from the DEGG.

## "degg"
```praat
eggSmooth = Filter (pass Hann band): lower, upper, 100
@smoothing: smoothWidth
Rename: "egg_smooth"
eggPointProcess = To PointProcess (periodic, peaks): 75, 600, "yes", "no"

selectObject: eggSmooth
deggSmooth = Copy: "degg_smooth"
Formula: "self [col + 1] - self [col]"
@smoothing: smoothWidth
deggPointProcess = To PointProcess (periodic, peaks): 75, 600, "yes", "no"
```

The raw EGG is filtered and smoothed using a triangular smooth, and from this the DEGG is calculated. Two PointProcess files are also created, which roughly mark each glottal period in the EGG and DEGG.

## "get periods"
```praat
for period from 1 to numberOfPeriods
    minAmplitude = Get minimum: 0, 0, "Sinc70"
    maxAmplitude = Get maximum: 0, 0, "Sinc70"

    periodStart = Get start time
    periodEnd = Get end time

    while sampleTime < periodTime
        sampleTime = sampleTime + sampleRate

        amplitude = Get value at time: 1, sampleTime, "Sinc70"

        amplitudeNorm = (amplitude - minAmplitude) /
            ...(maxAmplitude - minAmplitude)

        sampleTimeNorm = (sampleTime - periodStart) /
            ...(periodEnd - periodStart)
    endwhile
endfor
```

For each glottal period, the normalised amplitude is calculated for each sample within the period. Normalisation of amplitude and sample time is achieved through unity-based rescaling (range 0-1).

## "smoothing"
```praat
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
```
