

#### degg_tracing.praat
```praat
<<<smoothing>>>

<<<get files list>>>

<<<file loop>>>
```

First we get the file list and we start looping through the files.

#### "get files list"
```praat
form dEGG tracing
    word project pilot
    word speaker SC01
    comment Specify the lower and upper frequency (in Hz) for filtering:
    real lower 40
    real upper 10000
    comment Specify the smooth width "m" (the number of points):
    real smooth_width 11
endform

directory$ = "../../'project$'/data/derived/egg/'speaker$'"
directory_textgrid$ = "../../'project$'/data/derived/ultrasound/'speaker$'/annotations"

result_file$ = "../../'project$'/results/'speaker$'_degg_tracing.csv"
header$ = "speaker,file,word,time,maximum,minimum,position"
writeFileLine: "'result_file$'", "'header$'"

Create Strings as file list: "filelist", "'directory$'/*.wav"
files = Get number of strings
```

For each file, extract both channels.
Read from the corrisponding TextGrid in `/data/derived/ultrasound/ID/annotations` and get the starting and end point of the `kinematics` interval.
Now, we can extract the same interval from channel 2 of the EGG file.
Rename the ectracted part as `egg`, and execute the main function, which extracts the dEGG trace.

#### "file loop"
```praat
for file to files
    selectObject: "Strings filelist"
    file$ = Get string: file
    filename$ = file$ - ".wav"

    Read Strings from raw text file: "'directory_textgrid$'/'filename$'.txt"
    prompt$ = Get string: 1
    stimulus$ = extractWord$(prompt$, " ")

    Read separate channels from sound file: "'directory$'/'file$'"

    Read from file: "'directory_textgrid$'/'filename$'.TextGrid"
    tiers = Get number of tiers

if tiers == 4
    start = Get starting point: 3, 2
    end = Get end point: 3, 2
    label$ = Get label of point: 4, 1
    if label$ == "target_TD" or label$ == "target_TT"
        target = Get time of point: 4, 1
    else
        target = undefined
    endif

    selectObject: "Sound 'filename$'_ch2"
    Extract part: start, end, "rectangular", 1, "yes"
    Rename: "egg"

    <<<main function>>>
endif
endfor
```

#### "main function"
```praat
<<<degg>>>

<<<degg loop>>>
```

The EGG signal file `egg` is selected.
Filter EGG signal (`egg_band`) and smooth it with moving average (renamed to `egg_smooth`).
Create PointProcess (peaks) for EGG (`PointProcess egg_smooth`).
Calculate dEGG and smooth it (?) (`degg_smooth`).
Create PointProcess (peaks) of dEGG (`PointProcess degg_smooth`).

#### "degg"
```praat
Filter (pass Hann band): lower, upper, 100
@smoothing: smooth_width
Rename: "egg_smooth"
To PointProcess (periodic, peaks): 75, 600, "yes", "no"

selectObject: "Sound egg_smooth"
Copy: "degg"
Formula: "self [col + 1] - self [col]"
@smoothing: smooth_width
Rename: "degg_smooth"
To PointProcess (periodic, peaks): 75, 600, "yes", "no"
```

Loop through the EGG points and get minimum between the first two points.
The loop needs to go to the number of points minus 2 since we are selecting three points in each cycle of the loop.
This will need to be fixed if we want all cycles to be included.
Get dEGG maximum on the rigth of EGG minimum and get minimum of dEGG between current maximum and the next.
Normalise max and min to unity. This is gonna be the y axis.
The x axis needs to be time aligned: can choose between several (use minimum in EGG as arbitrary epoch, or midway between minima, or what else?)
Go to the second and third point and repeat.

**ATTENTION!** You don't need to normalise to unity. You need to get proportion `(period - value)/period`.

Trying egg_minimum_2 instead of degg_maximum_2 for cases when there is no degg_maximum_2.

#### "degg loop"
```praat
selectObject: "PointProcess egg_smooth"
egg_points = Get number of points
mean_period = Get mean period: 0, 0, 0.0001, 0.02, 1.3

for point to egg_points - 2
    selectObject: "PointProcess egg_smooth"
    point_1 = Get time from index: point
    point_2 = Get time from index: point + 1
    point_3 = Get time from index: point + 2
    selectObject: "Sound egg_smooth"
    egg_minimum_1 = Get time of minimum: point_1, point_2, "Sinc70"
    egg_minimum_2 = Get time of minimum: point_2, point_3, "Sinc70"
    period = egg_minimum_2 - egg_minimum_1

    if period <= mean_period * 2
        selectObject: "PointProcess degg_smooth"
        degg_maximum_point_1 = Get nearest index: egg_minimum_1
        degg_maximum = Get time from index: degg_maximum_point_1

        selectObject: "Sound degg_smooth"
        degg_minimum = Get time of minimum: degg_maximum, egg_minimum_2, "Sinc70"

        degg_maximum_rel = (degg_maximum - egg_minimum_1) / period
        degg_minimum_rel = (degg_minimum - egg_minimum_1) / period

        time = egg_minimum_1 - target

        if time == undefined
        elif time < 0
            position$ = "before"
        elif time > 0
            position$ = "after"
        endif

        if time != undefined
            result_line$ = "'speaker$','filename$','stimulus$','time',
                ...'degg_maximum_rel','degg_minimum_rel','position$'"

            appendFileLine: "'result_file$'", "'result_line$'"
        endif
    endif
endfor
```

#### "smoothing"
```praat
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
```
