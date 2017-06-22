form Get duration of voicing
    word speaker it01
endform

vuvDirectory$ = "../data/derived/egg/'speaker$'"
palignDirectory$ = "../data/derived/ultrasound/'speaker$'/audio"
resultsFile$ = "../results/egg/'speaker$'-voicing.csv"
resultsHeader$ = "index,speaker,file,rec.date,word,voicing.start,voicing.end,voicing.duration,sentence.duration"
writeFileLine: resultsFile$, resultsHeader$

Create Strings as file list: "vuvList", "'vuvDirectory$'/*.TextGrid"
numberOfVuv = Get number of strings
index = 0

for vuv to numberOfVuv
    selectObject: "Strings vuvList"
    vuvFile$ = Get string: vuv
    vuvTextGrid = Read from file: "'vuvDirectory$'/'vuvFile$'"
    vuvTextGrid$ = selected$("TextGrid")
    palignTextGrid$ = vuvTextGrid$ - "-vuv"

    Read Strings from raw text file: "'palignDirectory$'/'palignTextGrid$'.txt"
    recDate$ = Get string: 2

    palignTextGrid = Read from file: "'palignDirectory$'/'palignTextGrid$'-palign.TextGrid"
    plusObject: vuvTextGrid
    Merge
    numberOfWords = Get number of intervals: 3

    for word to numberOfWords
        word$ = Get label of interval: 3, word
        if word$ == "dico" or word$ == "mowie"
            index = index + 1
            wordStart = Get start time of interval: 3, word + 1
            segment = Get interval at time: 2, wordStart
            vowelStart = Get start time of interval: 2, segment + 1
            vowelEnd = Get end time of interval: 2, segment + 1
            midPoint = vowelStart + (vowelEnd - vowelStart)
            voiced = Get interval at time: 1, midPoint
            voicedStart = Get start time of interval: 1, voiced
            voicedEnd = Get end time of interval: 1, voiced
            voicing = (voicedEnd - voicedStart) * 1000
            stimulus$ = Get label of interval: 3, word + 1
    
            sentenceInterval = Get interval at time: 4, vowelStart
            sentenceStart = Get start time of interval: 4, sentenceInterval
            sentenceEnd = Get end time of interval: 4, sentenceInterval
            sentenceDuration = sentenceEnd - sentenceStart
    
            resultLine$ = "'index','speaker$','palignTextGrid$','recDate$','stimulus$',
                ...'voicedStart','voicedEnd','voicing','sentenceDuration'"
            appendFileLine: resultsFile$, resultLine$
        endif
    endfor
endfor
