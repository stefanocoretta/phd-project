######################################
# This is a script from the project 'Vowel duration and consonant voicing: An
# articulatory study', Stefano Coretta
######################################
# MIT License
#
# Copyright (c) 2016 Stefano Coretta
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
######################################

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

directory$ = "../data/egg/derived"

Create Strings as file list: "filelist", "'directory$'/'speaker$'/*.wav"
files = Get number of strings

for file from 1 to files
    selectObject: "Strings filelist"
    file$ = Get string: file
    Read from file: "'directory$'/'speaker$'/'file$'"
    filename$ = selected$("Sound")

    Extract one channel: 2
    
    noprogress Filter (pass Hann band): lower, upper, 100
    @smoothing: smooth_width
    
    noprogress To PointProcess (periodic, cc): 75, 600
    
    To TextGrid (vuv): 0.02, 0.001

    Write to text file: "'directory$'/'speaker$'/'filename$'-vuv.TextGrid"
    
    if debug_mode == 0
        removeObject: "Sound " + filename$, "Sound " + filename$ + "_ch2",
        ..."Sound " + filename$ + "_ch2_band", "PointProcess " + filename$ + "_ch2_band",
        ..."TextGrid " + filename$ + "_ch2_band"
    endif
endfor

removeObject: "Strings filelist"
