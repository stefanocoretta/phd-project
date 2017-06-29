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
    word project voicing-effect
    word speaker it01
    comment Specify the lower and upper frequency (in Hz) for filtering:
    real lower 40
    real upper 10000
    comment Specify the smooth width "m" (the number of points):
    real smooth_width 11
    boolean debug_mode
endform

directory$ = "../data/derived/egg"

Create Strings as file list: "filelist", "'directory$'/'speaker$'/*.wav"
files = Get number of strings

for file from 1 to files
    selectObject: "Strings filelist"
    file$ = Get string: file
    Read from file: "'directory$'/'speaker$'/'file$'"
    filename$ = selected$("Sound")

    Extract one channel: 2
    
    Filter (pass Hann band): lower, upper, 100
    @smoothing: smooth_width
    
    To PointProcess (periodic, cc): 75, 600
    
    To TextGrid (vuv): 0.02, 0.001

    Write to text file: "'directory$'/'speaker$'/'filename$'-vuv.TextGrid"
    
    if debug_mode == 0
        removeObject: "Sound " + filename$, "Sound " + filename$ + "_ch2",
        ..."Sound " + filename$ + "_ch2_band", "PointProcess " + filename$ + "_ch2_band",
        ..."TextGrid " + filename$ + "_ch2_band"
    endif
endfor

removeObject: "Strings filelist"
