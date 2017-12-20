# Tracegram of modal and breathy phonated vowels

## degg-tracing.praat
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
resultsHeader$ = "file,token,time,egg.minimum,degg.maximum,degg.minimum"
resultsFile$ = "'results$'/results.csv"
writeFileLine: resultsFile$, resultsHeader$
fileList = Create Strings as file list: "fileList", data$
numberOfFiles = Get number of strings
```

## "main loop"
```praat
for file to numberOfFiles
    selectObject: fileList
    fileName$ = Get string: file
    fileBareName$ = fileName$ - ".wav"
    sound = Read from file: "'data$'/'fileName$'"
    sound2 = Extract one channel: 2
    Multiply: -1
    # Check the paramenters of the filter in the literature
    Filter (pass Hann band): 100, 0, 100
    pointProcess = noprogress To PointProcess (periodic, peaks): 75, 600, "no", "yes"
    textGrid = To TextGrid (vuv): 0.02, 0.001
    numberOfIntervals = Get number of intervals: 1

    <<<vowel loop>>>
endfor
```

## "vowel loop"
```praat
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
        # The following two lines are easily breakable
        selectionStart = midPoint - 0.25
        selectionEnd = midPoint + 0.25
        selectObject: sound2
        selection = Extract part: selectionStart, selectionEnd, "rectangular",
            ...1, "yes"

        <<<degg>>>

        <<<tracing loop>>>

        removeObject: selection
    endif
endfor
```

## "degg"
```praat
eggSmooth = Filter (pass Hann band): lower, upper, 100
@smoothing: smoothWidth
Rename: "egg-smooth"
eggPointProcess = noprogress To PointProcess (periodic, peaks): 75, 600, "yes", "no"

selectObject: eggSmooth
deggSmooth = Copy: "degg-smooth"
Formula: "self [col + 1] - self [col]"
@smoothing: smoothWidth
deggPointProcess = noprogress To PointProcess (periodic, peaks): 75, 600, "yes", "no"
```

## "tracing loop"
```praat
selectObject: eggPointProcess
eggPoints = Get number of points
meanPeriod = Get mean period: 0, 0, 0.0001, 0.02, 1.3

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
        selectObject: deggPointProcess
        deggMaximumPoint1 = Get nearest index: eggMinimum1
        deggMaximum = Get time from index: deggMaximumPoint1

        if deggMaximum <= eggMinimum1
            deggMaximum = Get time from index: deggMaximumPoint1 + 1
        endif

        selectObject: deggSmooth
        deggMinimum = Get time of minimum: deggMaximum, eggMinimum2, "Sinc70"

        deggMaximumRel = (deggMaximum - eggMinimum1) / period
        deggMinimumRel = (deggMinimum - eggMinimum1) / period

        time = (eggMinimum1 - selectionStart) / (selectionEnd - selectionStart)

        resultLine$ = "'fileBareName$','token','time','eggMinimum1',
            ...'deggMaximumRel','deggMinimumRel'"

        appendFileLine: resultsFile$, resultLine$
    endif
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
