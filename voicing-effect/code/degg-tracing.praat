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

form dEGG tracing
    word project voicing-effect
    word speaker it01
    comment Specify the lower and upper frequency (in Hz) for filtering:
    real lower 40
    real upper 10000
    comment Specify the smooth width "m" (the number of points):
    real smooth_width 11
endform

directory$ = "../data/derived/egg/'speaker$'"
directory_textgrid$ = "../data/derived/ultrasound/'speaker$'/audio"

result_file$ = "../results/egg/'speaker$'-degg-tracing.csv"
header$ = "speaker,file,date,word,time,rel.time,proportion,maximum,minimum"
writeFileLine: "'result_file$'", "'header$'"

Create Strings as file list: "filelist", "'directory$'/*.wav"
files = Get number of strings

for file to files
    selectObject: "Strings filelist"
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

        Filter (pass Hann band): lower, upper, 100
        @smoothing: smooth_width
        Rename: "egg_smooth"
        To PointProcess (periodic, peaks): 75, 600, "yes", "no"
        pp_end = Get end time
        Remove points between: 0, start
        Remove points between: end, pp_end
        
        selectObject: "Sound egg_smooth"
        Copy: "degg"
        Formula: "self [col + 1] - self [col]"
        ; @smoothing: smooth_width
        Rename: "degg_smooth"
        To PointProcess (periodic, peaks): 75, 600, "yes", "no"
        Remove points between: 0, start
        Remove points between: end, pp_end
        
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
        
                if degg_maximum <= egg_minimum_1
                    degg_maximum = Get time from index: degg_maximum_point_1 + 1
                endif
        
                selectObject: "Sound degg_smooth"
                degg_minimum = Get time of minimum: degg_maximum, egg_minimum_2, "Sinc70"
        
                degg_maximum_rel = (degg_maximum - egg_minimum_1) / period
                degg_minimum_rel = (degg_minimum - egg_minimum_1) / period
        
                time = egg_minimum_1 - start
                proportion = (egg_minimum_1 - start) / (end - start)
        
                result_line$ = "'speaker$','filename$','date$','stimulus$','egg_minimum_1',
                    ...'time','proportion','degg_maximum_rel','degg_minimum_rel'"
        
                appendFileLine: "'result_file$'", "'result_line$'"
            endif
        endfor
    endif
endfor
