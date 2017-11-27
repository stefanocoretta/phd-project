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

form Extract vuv
    comment Specify the lower and upper frequency (in Hz) for filtering:
    real lower 40
    real upper 10000
    comment Specify the smooth width "m" (the number of points):
    real smooth_width 11
    boolean debug_mode
endform

directory$ = "../data/raw/audio"

Create Strings as file list: "file_list", "'directory$'/*.wav"
files = Get number of strings

for file from 1 to files
    selectObject: "Strings file_list"
    file$ = Get string: file
    Read from file: "'directory$'/'file$'"
    file_name$ = selected$("Sound")
    Extract one channel: 2
    egg$ = selected$("Sound")

    Filter (pass Hann band): lower, upper, 100
    @smoothing: smooth_width
    
    To PointProcess (periodic, cc): 75, 600
    
    To TextGrid (vuv): 0.02, 0.001

    if debug_mode == 0
        removeObject: "Sound " + file_name$, "Sound " + file_name$ + "_ch2",
        ..."Sound " + file_name$ + "_ch2_band", "PointProcess " + file_name$ + "_ch2_band",
        ..."TextGrid " + file_name$ + "_ch2_band", "Sound " + egg$
    endif
endfor

removeObject: "Strings file_list"
