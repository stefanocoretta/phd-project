
form Get measurements
    word speaker sc01
endform

directory_us_annotations$ = "../data/derived/ultrasound/'speaker$'/
    ...annotations"
directory_egg_vuv$ = "../data/derived/egg/'speaker$'"

createDirectory("../data/derived/merged/'speaker$'")
directory_out$ = "../data/derived/merged/'speaker$'"

result_file$ = "../results/'speaker$'-measurements.csv"
result_header$ = "speaker,word,target,max,release,voff,voffr"
writeFileLine: result_file$, result_header$

Create Strings as file list: "filelist_us", "'directory_us_annotations$'/*.TextGrid"
files_us = Get number of strings

Create Strings as file list: "filelist_egg", "'directory_egg_vuv$'/*.TextGrid"
files_egg = Get number of strings

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
    endif
endfor

