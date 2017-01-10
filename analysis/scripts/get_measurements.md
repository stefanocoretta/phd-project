---
title: Get voicing durations
author: Stefano Coretta
---

This script extracts several durations related to voicing. The main function `merge` is a loop that reads the TextGrids from the derived ultrasound and EGG folders and merges the tier with the gestures from the ultrasound and the tier with the voiced/unvoiced intervals from the EGG.


#### get_measurements.praat
```praat

<<<read>>>

<<<merge>>>

```

This is the form that prompts the user to input the directories of the derived ultrasound (`directory_us`) and EGG (`directory_egg`) data, and the ID of the participant (`speaker`). Do not include the participant folder in the path because it will be automatically included in the main function.

#### "read"
```praat
form Get voicing durations
    word directory_us ../../pilot/data/derived/ultrasound
    word directory_egg ../../pilot/data/derived/egg
    word speaker SC01
endform

directory_us_annotations$ = "'directory_us$'/'speaker$'/annotations"
directory_egg_vuv$ = "'directory_egg$'/'speaker$'"

createDirectory("../../pilot/data/derived/merged/'speaker$'")
directory_out$ = "../../pilot/data/derived/merged/'speaker$'"

result_file$ = "../../pilot/results/'speaker$'-measurements.csv"
result_header$ = "speaker,word,target,max,release,voff,voffr"
writeFileLine: result_file$, result_header$

Create Strings as file list: "filelist_us", "'directory_us_annotations$'/*.TextGrid"
files_us = Get number of strings

Create Strings as file list: "filelist_egg", "'directory_egg_vuv$'/*.TextGrid"
files_egg = Get number of strings
```

#### "merge"
```praat
for file from 1 to files_us
    selectObject: "Strings filelist_us"
    file$ = Get string: file
    Read from file: "'directory_us_annotations$'/'file$'"
    filename$ = selected$("TextGrid")

    num_tiers = Get number of tiers

    if num_tiers == 4
        Extract one tier: 4

        selectObject: "Strings filelist_egg"
        Read from file: "'directory_egg_vuv$'/'filename$'-vuv.TextGrid"

        selectObject: "TextGrid PointTier_0"
        plusObject: "TextGrid " + filename$ + "-vuv"

        Merge

        Set tier name: 1, "gestures"
        Insert interval tier: 3, "stimulus"

        Read Strings from raw text file: "'directory_us_annotations$'/'filename$'.txt"
        prompt$ = Get string: 1
        stimulus$ = extractWord$(prompt$, " ")

        selectObject: "TextGrid merged"
        Set interval text: 3, 1, stimulus$

        Save as text file: "'directory_out$'/'filename$'-merged.TextGrid"

        <<<calculate>>>
    endif
endfor
```

For the current TextGrid, get the number of points in the `gestures` point tier and, if `number_of_points > 0`, loop through the points. If the point is labelled `target_TT` or `target_TD`, get the time and save it to `target`. Else, write an empty value to `target`, and if the label is `max_TT` or `max_TD`, get the time and write it to `max`. Else, write an empty to `max`, and if the label is `release_TT` or `release_TD`, write the value to `release`. Else, write an empty to `release`.

#### "calculate"
```praat
        number_of_points = Get number of points: 1

        target = undefined
        max = undefined
        release = undefined
        voff = undefined
        voffr = undefined

        if number_of_points > 0
            for point to number_of_points
                point_label$ = Get label of point: 1, point
                if point_label$ == "target_TT" or point_label$ == "target_TD"
                    target = Get time of point: 1, point
                    vuv = Get interval at time: 2, target
                    vuv_label$ = Get label of interval: 2, vuv
                    if vuv_label$ == "U"
                        voff = Get starting point: 2, vuv
                    else
                        voffr = 0
                    endif
                elif point_label$ == "max_TT" or point_label$ == "max_TD"
                    max = Get time of point: 1, point
                    if target == undefined
                        vuv = Get interval at time: 2, max
                        vuv_label$ = Get label of interval: 2, vuv
                        if vuv_label$ == "U"
                            voff = Get starting point: 2, vuv
                        else
                            voffr = 0
                        endif
                    endif
                elif point_label$ == "release_TT" or point_label$ == "release_TD"
                    release = Get time of point: 1, point
                endif
            endfor
            if voffr <> 0
                if voff == undefined or release == undefined
                    voffr = undefined
                else
                    voffr = (release - voff) * 1000
                endif
            endif
        endif

        result_line$ = "'speaker$','stimulus$','target','max','release',
            ...'voff','voffr'"
        appendFileLine: result_file$, result_line$
```
