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

The main loop goes through each file, extracts the relevat prosions using a vuv textgrid, and gets the numeric data.

## "main loop"
```praat
for file from 1 to numberOfFiles

    <<<calculate degg>>>

    <<<get periods>>>
endfor
```

For each glottal period, the normalised amplitude is calculated for each sample within the period. Normalisation of amplitude and sample time is achieved through unity-based rescaling (range 0-1).

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
