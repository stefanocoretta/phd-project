######################################
# save_wav.praat v1.0.0
######################################
# Copyright 2016 Stefano Coretta
#
# stefanocoretta.altervista.org
#
# This program is free software: you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later
# version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
# details. # You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
######################################

form Select output folder
    word directory ~/Desktop/
endform

select all
number = numberOfSelected()

previous$ = ""
index = 1

for i to number
    sound = selected(i)
    sound$ = selected$("Sound", i)

    if sound$ == previous$
        index +=1
        Save as WAV file: "'directory$'/'sound$'-'index'.wav"
        previous$ = sound$
    else
        index = 1
        Save as WAV file: "'directory$'/'sound$'-'index'.wav"
        previous$ = sound$
    endif

endfor
