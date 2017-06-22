form Extract vuv
    word project voicing-effect
    word speaker it01
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
    
    To PointProcess (periodic, cc): 75, 600
    
    To TextGrid (vuv): 0.02, 0.001

    Write to text file: "'directory$'/'speaker$'/'filename$'-vuv.TextGrid"
    
    if debug_mode == 0
        removeObject: "Sound " + filename$, "Sound " + filename$ + "_ch2",
        ..."PointProcess " + filename$ + "_ch2", "TextGrid " + filename$ + "_ch2"
    endif
endfor

removeObject: "Strings filelist"
