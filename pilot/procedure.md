# Procedure for analysing data

## Ultrasound data

1. **Export** `.wav` and `.txt` from `AAA` to `/data/derived/ultrasound/[ID]/audio` folder ([ID] = participant ID) as [ID]-00n.wav
1. **Force alignment and search area**
   1. Run `alignment-input.praat`: the output is a concatenated `.wav` file and a `.txt` file listing the stimuli, written in `/data/derived/ultrasound/[ID]/alignment`
   1. Make sure the `.txt` contains "Mowie" (unicode safe because of AAA)
   1. **WARNING OVERWRITE** Run SPPAS on concatenated `.wav` and `.txt`
   1. Check alignment
   1. Run `search-area.praat`: the output is TextGrid files for each `AAA` `.wav` file, saved in `/data/derived/ultrasound/[ID]/audio`, and a merged TextGrid, saved in `/data/derived/ultrasound/[ID]/alignment`
   1. Import TextGrids back in `AAA`
1. **Tongue tracking**
   1. Create a spline template for the speaker and save it (`.fst`)
   1. Batch process splines with template
   1. Check splines
   1. Batch process snap-to-fit
1. **Calculate kinematics**
   1. Check relevant splines for Tongue Dorsum and Tongue Tip
   1. Load `AnaVal-[ID].avl` from `Edit values` and change splines to TD and TT splines (Save it for the future)
   1. Calculate Maths for entire session
1. **Find consonantal gestures**
   1. Select TD stimuli
   1. `Find...` > `Load` and `execute` `td_function.srh`
   1. Select TT stimuli
   1. `Find...` > `Load` and `execute` `tt_function.srh`
1. **Export data** in `results` folder with `Export.xsu` to the file `[ID]-aaa.txt`
1. **Export kinematics annotations** (from `Export > Files...`) in `data/derived/ultrasound/[ID]/kinematics` folder as `[ID]-00n.TextGrid`
1. **Burst detection**
   1. Run `burst-detection.praat`: the output is a `.TextGrid` file, written in `/data/derived/ultrasound/[ID]/alignment`
   1. Check bursts
1. **Get durations**
   1. Run `get-durations.praat`: the output is written in the `results` folder

## EGG data

1. **Synchronise** EGG with `sync-egg.praat`: the output is written in `/data/derived/egg/[ID]`
1. **Extract vuv** (Voiced/UnVoiced) with `extract-vuv.praat`: the output is written in the same folder as above
1. **Calculate dEGG tracegrams** with `degg-tracing.praat`: the results are written in `results`
1. **Calculate measurements** from ultrasound and EGG annotations with `get-measurements.praat`: the resulting TextGrids are written in `/data/derived/merged/[ID]` and the measurements in `results` to the file `[ID]-measurements.csv`

## `AAA` files extensions
* `.esu`: tabs in the main window
* `.fst`: fans template
* `.avl`: analysis values chart
* `.srh`: search analysis value
* `.xsu`: export settings
