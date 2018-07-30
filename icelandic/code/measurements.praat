raw_dir$ = "../data/raw"
out$ = "../data/datasets/measurements.csv"
header$ = "speaker,index,word,sentence_duration,rr"
writeFileLine: out$, header$

Create Strings as file list: "file_list", "'raw_dir$'/*_ann.TextGrid"
files = Get number of strings

for file from 1 to files
  selectObject: "Strings file_list"
  file$ = Get string: file
  speaker$ = file$ - "_ann.TextGrid"
  Read from file: "'raw_dir$'/'file$'"

  points = Get number of points: 3
  index = 0

  for point from 1 to points
    point_label$ = Get label of point: 3, point

    if point_label$ == "c1"
      index = index + 1
      c1_time = Get time of point: 3, point
      
      sentence_int = Get interval at time: 1, c1_time
      sentence_start = Get start time of interval: 1, sentence_int
      sentence_end = Get end time of interval: 1, sentence_int
      sentence_duration = sentence_end - sentence_start
      
      word_int = Get interval at time: 2, c1_time
      word$ = Get label of interval: 2, word_int
      
      c2_time = Get time of point: 3, point + 1
      rr = (c2_time - c1_time) * 1000

      out_line$ = "'speaker$','index','word$','sentence_duration','rr'"

      appendFileLine: out$, out_line$
    endif

  endfor

endfor
