# Pre-process data for force-alignment

## filter.praat
```praat
raw$ = "../data/raw/audio"
derived$ = "../data/derived/audio"
Create Strings as file list: "file_list", "'raw$'/*.wav"
files = Get number of strings

<<<file loop>>>
```

The files in `raw/` are read and processed for alignment.

## "file loop"
```praat
for file from 1 to files
    select Strings file_list
    file$ = Get string: file
    Read from file: "'raw$'/'file$'"
    file_name$ = selected$ ("Sound")

    Extract one channel: 1

    Filter (pass Hann band): 40, 10000, 100

    Save as WAV file: "'derived$'/'file_name$'.wav"
endfor
```

For each file, read the file, extract the left channel (audio), filter within range 40-10000 Hz, save the file in `derived/`.
