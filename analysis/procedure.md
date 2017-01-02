# Procedure for analyzing data

## Ultrasound data

1. **Export** `.wav` and `.txt` from `AAA` to `/data/derived/ultrasound/[ID]/audio` folder ([ID] = participant ID)
1. **Force alignment and search area**
   1. Run `alingment_input.praat`: the output is a concatenanted `.wav` file and a `.txt` file listing the stimuli
   1. Run SPPAS on concatenated `.wav` and `.txt`
   1. Run `separate_alignment.praat`: the output is TextGrid files for each `AAA` `.wav` file
   1. Import TextGrids back in `AAA`
1. **Tongue tracking**
   1. Create a spline template and save it (`.fst`)
   1. Batch process splines with template
   1. Check splines
   1. Batch process snap-to-fit
1. **Calculate kinematics**
   1. Check relevant splines for Tongue Dorsum and Tongue Tip
   1. Load `AnaVal-[ID].avl` from `Edit values` and change splines to TD and TT splines (Save it for the future)
   1. Calculate Maths for entire session
1. **Find target, maximum and release**
   1. Select TD stimuli
   1. `Find...` > `Load` and `execute` `td_function_50.srh`
   1. Select TT stimuli
   1. `Find...` > `Load` and `execute` `tt_function_95.srh`
1. **Export data** in `results` folder with `Export.xsu` (to do)
1. **Export annotations** in `data/derived/ultrasound/[ID]/annotations` folder to the file `[ID]_export.txt`

## EGG data

1. **Synchronise** EGG with `sync_egg.praat`: the output is written in `/data/derived/egg/[ID]`
1. **Extract vuv** (Voiced/UnVoiced) with `extract_vuv.praat`: the output is written in the same folder as above
1. **Calculate measurements** from ultrasound and EGG annotations with `get_voicing_durations.praat`: the resulting TextGrids are written in `/data/derived/merged/[ID]` and the measurements in `results` to the file `[ID]_measurements.csv`

## `AAA` files extensions
* `.esu`: tabs in the main window
* `.fst`: fans template
* `.avl`: analysis values chart
* `.srh`: search analysis value
* `.xsu`: export settings
