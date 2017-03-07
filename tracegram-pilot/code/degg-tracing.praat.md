# Wavegram of modal and breathy phonated vowels

## degg-tracing.praat
```praat
<<<preamble>>>

<<<main loop>>>

<<<smoothing>>>
```

## "preamble"
```praat

```

## "main loop"
```praat
for file to numberOfFiles
    Read from file: "'directory$'/'fileName$'"
    To PointProcess (periodic, peaks): 75, 600, "no", "yes"
    To TextGrid (vuv): 0.02, 0.001

    <<<vowel loop>>>
endfor
```

## "vowel loop"
```praat
for vowel to numberOfVowels
    <<<degg>>>

    <<<tracing loop>>>
endfor
```

## "degg"
```praat
Filter (pass Hann band): lower, upper, 100
@smoothing: smoothWidth
Rename: "egg-smooth"
To PointProcess (periodic, peaks): 75, 600, "yes", "no"

selectObject: "Sound egg-smooth"
Copy: "degg"
Formula: "self [col + 1] - self [col]"
@smoothing: smoothWidth
Rename: "degg-smooth"
To PointProcess (periodic, peaks): 75, 600, "yes", "no"
```

## "tracing loop"
```praat

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
