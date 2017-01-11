directory$ = "./data"
lower = 40
upper = 10000
smooth_width = 11
result_file$ = "degg-tracing.csv"
header$ = "sound,time,maximum,minimum"
writeFileLine: result_file$, header$

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

Create Strings as file list: "filelist", "'directory$'"
files = Get number of strings

for file to files
    selectObject: "Strings filelist"
    file$ = Get string: file
    
    sound = Read from file: "'directory$'/'file$'"
    sound$ = selected$("Sound")
    
    egg = Extract one channel: 2
    Multiply: -1
    
    duration = Get total duration
    center = duration / 2
    start = center - 2.5
    end = center + 2.5
    Extract part: start, end, "rectangular", 1, "no"
    Rename: "egg"

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
    
            time = egg_minimum_1
    
            result_line$ = "'sound$','time','degg_maximum_rel','degg_minimum_rel'"
    
            appendFileLine: "'result_file$'", "'result_line$'"
    
        endif
    endfor
endfor
