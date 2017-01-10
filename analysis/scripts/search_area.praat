form Select folder with TextGrid
    word project pilot
    word speaker SC01
    comment Supported languages: it, pl
    word language it
endform

if language$ == "it"
    label_lang$ = "k"
    label_2_lang$ = "dico"
elif language == "pl"
    label_lang$ = "j"
    label_2_lang$ = "móvię"
else
    exit "The language you selected is not valid"
endif

directory_audio$ = "../../'project$'/data/derived/ultrasound/'speaker$'/audio"
directory_alignment$ = "../../'project$'/data/derived/ultrasound/'speaker$'/alignment"

palign = Read from file: "'directory_alignment$'/'speaker$'-palign.TextGrid"

intervals = Get number of intervals: 1

Insert interval tier: 4, "ultrasound"
Insert interval tier: 5, "kinematics"

for interval to intervals
    label$ = Get label of interval: 1, interval
    if label$ == label_lang$
        start_ultrasound = Get starting point: 1, interval
        interval_2 = Get interval at time: 2, start_ultrasound
        label_2$ = Get label of interval: 2, interval_2
        if label_2$ == label_2_lang$
            end_ultrasound = Get end point: 1, interval + 7
            Insert boundary: 4, start_ultrasound
            Insert boundary: 4, end_ultrasound
            ultrasound = Get interval at time: 4, start_ultrasound
            Set interval text: 4, ultrasound, "ultrasound"

            start_kinematics_1 = Get start point: 1, interval + 3
            start_kinematics_2 = Get end point: 1, interval + 3
            start_kinematics = start_kinematics_1 + ((start_kinematics_2 - start_kinematics_1) / 2)
            end_kinematics_1 = Get start point: 1, interval + 5
            end_kinematics_2 = Get end point: 1, interval + 5
            end_kinematics = end_kinematics_1 + ((end_kinematics_2 - end_kinematics_1) / 2)
            Insert boundary: 5, start_kinematics
            Insert boundary: 5, end_kinematics
            kinematics = Get interval at time: 5, start_kinematics
            Set interval text: 5, kinematics, "kinematics"
        endif
    endif
endfor

Remove tier: 1
Remove tier: 1
Remove tier: 1

Save as text file: "'directory_alignment$'/search.TextGrid"

filenames = Read from file: "'directory_alignment$'/'speaker$'-filenames.TextGrid"
filenames_tier = 3

selectObject: palign
plusObject: filenames

Merge

intervals = Get number of intervals: filenames_tier

for interval from 1 to intervals
    selectObject: "TextGrid merged"
    start = Get start point: filenames_tier, interval
    end  = Get end point: filenames_tier, interval
    filename$ = Get label of interval: filenames_tier, interval

    Extract part: start, end, "no"

    Remove tier: filenames_tier
    Write to text file: "'directory_audio$'/'filename$'.TextGrid"
    Remove
endfor
