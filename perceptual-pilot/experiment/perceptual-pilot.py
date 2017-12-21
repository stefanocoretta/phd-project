#!/usr/bin/env python2
# -*- coding: utf-8 -*-
"""
This experiment was created using PsychoPy2 Experiment Builder (v1.85.4),
    on Thu Dec 21 15:30:50 2017
If you publish work using this script please cite the PsychoPy publications:
    Peirce, JW (2007) PsychoPy - Psychophysics software in Python.
        Journal of Neuroscience Methods, 162(1-2), 8-13.
    Peirce, JW (2009) Generating stimuli for neuroscience using PsychoPy.
        Frontiers in Neuroinformatics, 2:10. doi: 10.3389/neuro.11.010.2008
"""

from __future__ import absolute_import, division
from psychopy import locale_setup, sound, gui, visual, core, data, event, logging
from psychopy.constants import (NOT_STARTED, STARTED, PLAYING, PAUSED,
                                STOPPED, FINISHED, PRESSED, RELEASED, FOREVER)
import numpy as np  # whole numpy lib is available, prepend 'np.'
from numpy import (sin, cos, tan, log, log10, pi, average,
                   sqrt, std, deg2rad, rad2deg, linspace, asarray)
from numpy.random import random, randint, normal, shuffle
import os  # handy system and path functions
import sys  # to get file system encoding

# Ensure that relative paths start from the same directory as this script
_thisDir = os.path.dirname(os.path.abspath(__file__)).decode(sys.getfilesystemencoding())
os.chdir(_thisDir)

# Store info about the experiment session
expName = 'perceptual-pilot'  # from the Builder filename that created this script
expInfo = {u'participant': u''}
dlg = gui.DlgFromDict(dictionary=expInfo, title=expName)
if dlg.OK == False:
    core.quit()  # user pressed cancel
expInfo['date'] = data.getDateStr()  # add a simple timestamp
expInfo['expName'] = expName

# Data file name stem = absolute path + name; later add .psyexp, .csv, .log, etc
filename = _thisDir + os.sep + u'data/%s_%s_%s' % (expInfo['participant'], expName, expInfo['date'])

# An ExperimentHandler isn't essential but helps with data saving
thisExp = data.ExperimentHandler(name=expName, version='',
    extraInfo=expInfo, runtimeInfo=None,
    originPath=None,
    savePickle=True, saveWideText=True,
    dataFileName=filename)
logging.console.setLevel(logging.WARNING)  # this outputs to the screen, not a file

endExpNow = False  # flag for 'escape' or other condition => quit the exp

# Start Code - component code to be run before the window creation

# Setup the Window
win = visual.Window(
    size=(1280, 800), fullscr=True, screen=0,
    allowGUI=False, allowStencil=False,
    monitor='testMonitor', color=[0,0,0], colorSpace='rgb',
    blendMode='avg', useFBO=True)
# store frame rate of monitor if we can measure it
expInfo['frameRate'] = win.getActualFrameRate()
if expInfo['frameRate'] != None:
    frameDur = 1.0 / round(expInfo['frameRate'])
else:
    frameDur = 1.0 / 60.0  # could not measure, so guess

# Initialize components for Routine "instructions"
instructionsClock = core.Clock()
text_5 = visual.TextStim(win=win, name='text_5',
    text=u'Grazie per aver accettato di partecipare a questo esperimento.\n\nQuello che devi fare \xe8 semplicemente ascoltare delle parole e dire se secondo te la seconda consonante \xe8 una "t" o una "d"\n\n(premi la barra spaziatrice per continuare, l\'esperimento non inizier\xe0 per ora)',
    font='Arial',
    pos=(0, 0), height=0.1, wrapWidth=None, ori=0, 
    color='white', colorSpace='rgb', opacity=1,
    depth=0.0);

# Initialize components for Routine "instructions_2"
instructions_2Clock = core.Clock()
text_10 = visual.TextStim(win=win, name='text_10',
    text=u'Le parole che sentirai sono parole inventante e iniziano tutte con una "p". Per esempio: "pata", "pudu".\n\nUna volta ascoltata la parola, dovrai premere il tasto per la "t" se pensi che la seconda consonante era una "t" o il tasto per la "d" se pensi che la seconda consonante era una "d".\n\n(premi la barra spaziatrice per continuare, l\'esperimento non inizier\xe0 per ora)',
    font='Arial',
    pos=(0, 0), height=0.1, wrapWidth=None, ori=0, 
    color='white', colorSpace='rgb', opacity=1,
    depth=0.0);

# Initialize components for Routine "instructions_3"
instructions_3Clock = core.Clock()
text_11 = visual.TextStim(win=win, name='text_11',
    text=u'Potrai ascoltare ogni parola solo una volta. Dopo aver sentito una parola, dovrai premere un tasto per indicare se la parola aveva una "t" o una "d". Le lettere che vedrai sullo schermo ti aiuteranno a ricordare quale tasto premere.\n\nCerca di rispondere velocemente ma accuratamente.\n\n(premi la barra spaziatrice per continuare, l\'esperimento non inizier\xe0 per ora)',
    font=u'Arial',
    pos=(0, 0), height=0.1, wrapWidth=None, ori=0, 
    color=u'white', colorSpace='rgb', opacity=1,
    depth=0.0);

# Initialize components for Routine "instructions_4"
instructions_4Clock = core.Clock()
text_12 = visual.TextStim(win=win, name='text_12',
    text=u'Prima di iniziare l\'esperimento, faremo una veloce prova.\n\nCome nell\'esperimento vero e proprio, dovrai dire se la parola che hai sentito contiene una "t" o una "d". Dopo aver dato la risposta, vedrai un messaggio che ti dir\xe0 se hai risposto correttamente o meno.\n\n(premi la barra spaziatrice per continuare, l\'esperimento non inizier\xe0 per ora)',
    font=u'Arial',
    pos=(0, 0), height=0.1, wrapWidth=None, ori=0, 
    color=u'white', colorSpace='rgb', opacity=1,
    depth=0.0);

# Initialize components for Routine "instructions_5"
instructions_5Clock = core.Clock()
text_13 = visual.TextStim(win=win, name='text_13',
    text=u"Questa prova potr\xe0 sembrarti semplice, ma considera che serve solo per farti familiarizzare con l'esperimento.\n\nPosiziona ora l'indice della mano sinistra e della mano destra sui tasti.\n\nQuando sei pronta/o per iniziare la prova, premi la barra spaziatrice sulla tastiera.\n\n(premi la barra spaziatrice per iniziare la prova)",
    font=u'Arial',
    pos=(0, 0), height=0.1, wrapWidth=None, ori=0, 
    color=u'white', colorSpace='rgb', opacity=1,
    depth=0.0);

# Initialize components for Routine "train"
trainClock = core.Clock()
sound_2 = sound.Sound('A', secs=-1)
sound_2.setVolume(1)
text_2 = visual.TextStim(win=win, name='text_2',
    text='d                   t',
    font='Arial',
    pos=(0, 0), height=0.2, wrapWidth=None, ori=0, 
    color='white', colorSpace='rgb', opacity=1,
    depth=-1.0);

# Initialize components for Routine "feedback"
feedbackClock = core.Clock()
msg='doh!'
text_4 = visual.TextStim(win=win, name='text_4',
    text='default text',
    font='Arial',
    pos=(0, 0), height=0.1, wrapWidth=None, ori=0, 
    color=1.0, colorSpace='rgb', opacity=1,
    depth=-1.0);

# Initialize components for Routine "ready"
readyClock = core.Clock()
text_3 = visual.TextStim(win=win, name='text_3',
    text=u"La prova \xe8 terminata.\n\nOra possiamo passare all'esperimento vero e proprio.\n\nQuando sei pronta/o per iniziare, premi la barra spaziatrice sulla tastiera.",
    font='Arial',
    pos=(0, 0), height=0.1, wrapWidth=None, ori=0, 
    color='white', colorSpace='rgb', opacity=1,
    depth=0.0);

# Initialize components for Routine "trial"
trialClock = core.Clock()
sound_1 = sound.Sound('A', secs=-1)
sound_1.setVolume(1)
text = visual.TextStim(win=win, name='text',
    text=u'd                   t',
    font=u'Arial',
    pos=(0, 0), height=0.2, wrapWidth=None, ori=0, 
    color=u'white', colorSpace='rgb', opacity=1,
    depth=-1.0);

# Initialize components for Routine "train_2"
train_2Clock = core.Clock()
sound_3 = sound.Sound('A', secs=-1)
sound_3.setVolume(1)
text_6 = visual.TextStim(win=win, name='text_6',
    text=u't                   d',
    font=u'Arial',
    pos=(0, 0), height=0.2, wrapWidth=None, ori=0, 
    color=u'white', colorSpace='rgb', opacity=1,
    depth=-1.0);

# Initialize components for Routine "feedback_2"
feedback_2Clock = core.Clock()
msg='doh!'
text_7 = visual.TextStim(win=win, name='text_7',
    text='default text',
    font='Arial',
    pos=(0, 0), height=0.1, wrapWidth=None, ori=0, 
    color=1.0, colorSpace='rgb', opacity=1,
    depth=-1.0);

# Initialize components for Routine "ready_2"
ready_2Clock = core.Clock()
text_8 = visual.TextStim(win=win, name='text_8',
    text=u"La prova \xe8 terminata.\n\nOra possiamo passare all'esperimento vero e proprio.\n\nQuando sei pronta/o per iniziare, premi la barra spaziatrice sulla tastiera.",
    font='Arial',
    pos=(0, 0), height=0.1, wrapWidth=None, ori=0, 
    color='white', colorSpace='rgb', opacity=1,
    depth=0.0);

# Initialize components for Routine "trial_2"
trial_2Clock = core.Clock()
sound_4 = sound.Sound('A', secs=-1)
sound_4.setVolume(1)
text_9 = visual.TextStim(win=win, name='text_9',
    text=u't                   d',
    font=u'Arial',
    pos=(0, 0), height=0.2, wrapWidth=None, ori=0, 
    color=u'white', colorSpace='rgb', opacity=1,
    depth=-1.0);

# Create some handy timers
globalClock = core.Clock()  # to track the time since experiment started
routineTimer = core.CountdownTimer()  # to track time remaining of each (non-slip) routine 

# ------Prepare to start Routine "instructions"-------
t = 0
instructionsClock.reset()  # clock
frameN = -1
continueRoutine = True
# update component parameters for each repeat
key_resp_5 = event.BuilderKeyResponse()
# keep track of which components have finished
instructionsComponents = [text_5, key_resp_5]
for thisComponent in instructionsComponents:
    if hasattr(thisComponent, 'status'):
        thisComponent.status = NOT_STARTED

# -------Start Routine "instructions"-------
while continueRoutine:
    # get current time
    t = instructionsClock.getTime()
    frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
    # update/draw components on each frame
    
    # *text_5* updates
    if t >= 0.0 and text_5.status == NOT_STARTED:
        # keep track of start time/frame for later
        text_5.tStart = t
        text_5.frameNStart = frameN  # exact frame index
        text_5.setAutoDraw(True)
    
    # *key_resp_5* updates
    if t >= 3 and key_resp_5.status == NOT_STARTED:
        # keep track of start time/frame for later
        key_resp_5.tStart = t
        key_resp_5.frameNStart = frameN  # exact frame index
        key_resp_5.status = STARTED
        # keyboard checking is just starting
        win.callOnFlip(key_resp_5.clock.reset)  # t=0 on next screen flip
        event.clearEvents(eventType='keyboard')
    if key_resp_5.status == STARTED:
        theseKeys = event.getKeys(keyList=['y', 'n', 'left', 'right', 'space'])
        
        # check for quit:
        if "escape" in theseKeys:
            endExpNow = True
        if len(theseKeys) > 0:  # at least one key was pressed
            key_resp_5.keys = theseKeys[-1]  # just the last key pressed
            key_resp_5.rt = key_resp_5.clock.getTime()
            # a response ends the routine
            continueRoutine = False
    
    # check if all components have finished
    if not continueRoutine:  # a component has requested a forced-end of Routine
        break
    continueRoutine = False  # will revert to True if at least one component still running
    for thisComponent in instructionsComponents:
        if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
            continueRoutine = True
            break  # at least one component has not yet finished
    
    # check for quit (the Esc key)
    if endExpNow or event.getKeys(keyList=["escape"]):
        core.quit()
    
    # refresh the screen
    if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
        win.flip()

# -------Ending Routine "instructions"-------
for thisComponent in instructionsComponents:
    if hasattr(thisComponent, "setAutoDraw"):
        thisComponent.setAutoDraw(False)
# check responses
if key_resp_5.keys in ['', [], None]:  # No response was made
    key_resp_5.keys=None
thisExp.addData('key_resp_5.keys',key_resp_5.keys)
if key_resp_5.keys != None:  # we had a response
    thisExp.addData('key_resp_5.rt', key_resp_5.rt)
thisExp.nextEntry()
# the Routine "instructions" was not non-slip safe, so reset the non-slip timer
routineTimer.reset()

# ------Prepare to start Routine "instructions_2"-------
t = 0
instructions_2Clock.reset()  # clock
frameN = -1
continueRoutine = True
# update component parameters for each repeat
key_resp_9 = event.BuilderKeyResponse()
# keep track of which components have finished
instructions_2Components = [text_10, key_resp_9]
for thisComponent in instructions_2Components:
    if hasattr(thisComponent, 'status'):
        thisComponent.status = NOT_STARTED

# -------Start Routine "instructions_2"-------
while continueRoutine:
    # get current time
    t = instructions_2Clock.getTime()
    frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
    # update/draw components on each frame
    
    # *text_10* updates
    if t >= 0.0 and text_10.status == NOT_STARTED:
        # keep track of start time/frame for later
        text_10.tStart = t
        text_10.frameNStart = frameN  # exact frame index
        text_10.setAutoDraw(True)
    
    # *key_resp_9* updates
    if t >= 3 and key_resp_9.status == NOT_STARTED:
        # keep track of start time/frame for later
        key_resp_9.tStart = t
        key_resp_9.frameNStart = frameN  # exact frame index
        key_resp_9.status = STARTED
        # keyboard checking is just starting
        win.callOnFlip(key_resp_9.clock.reset)  # t=0 on next screen flip
        event.clearEvents(eventType='keyboard')
    if key_resp_9.status == STARTED:
        theseKeys = event.getKeys(keyList=['y', 'n', 'left', 'right', 'space'])
        
        # check for quit:
        if "escape" in theseKeys:
            endExpNow = True
        if len(theseKeys) > 0:  # at least one key was pressed
            key_resp_9.keys = theseKeys[-1]  # just the last key pressed
            key_resp_9.rt = key_resp_9.clock.getTime()
            # a response ends the routine
            continueRoutine = False
    
    # check if all components have finished
    if not continueRoutine:  # a component has requested a forced-end of Routine
        break
    continueRoutine = False  # will revert to True if at least one component still running
    for thisComponent in instructions_2Components:
        if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
            continueRoutine = True
            break  # at least one component has not yet finished
    
    # check for quit (the Esc key)
    if endExpNow or event.getKeys(keyList=["escape"]):
        core.quit()
    
    # refresh the screen
    if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
        win.flip()

# -------Ending Routine "instructions_2"-------
for thisComponent in instructions_2Components:
    if hasattr(thisComponent, "setAutoDraw"):
        thisComponent.setAutoDraw(False)
# check responses
if key_resp_9.keys in ['', [], None]:  # No response was made
    key_resp_9.keys=None
thisExp.addData('key_resp_9.keys',key_resp_9.keys)
if key_resp_9.keys != None:  # we had a response
    thisExp.addData('key_resp_9.rt', key_resp_9.rt)
thisExp.nextEntry()
# the Routine "instructions_2" was not non-slip safe, so reset the non-slip timer
routineTimer.reset()

# ------Prepare to start Routine "instructions_3"-------
t = 0
instructions_3Clock.reset()  # clock
frameN = -1
continueRoutine = True
# update component parameters for each repeat
key_resp_10 = event.BuilderKeyResponse()
# keep track of which components have finished
instructions_3Components = [text_11, key_resp_10]
for thisComponent in instructions_3Components:
    if hasattr(thisComponent, 'status'):
        thisComponent.status = NOT_STARTED

# -------Start Routine "instructions_3"-------
while continueRoutine:
    # get current time
    t = instructions_3Clock.getTime()
    frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
    # update/draw components on each frame
    
    # *text_11* updates
    if t >= 0.0 and text_11.status == NOT_STARTED:
        # keep track of start time/frame for later
        text_11.tStart = t
        text_11.frameNStart = frameN  # exact frame index
        text_11.setAutoDraw(True)
    
    # *key_resp_10* updates
    if t >= 3 and key_resp_10.status == NOT_STARTED:
        # keep track of start time/frame for later
        key_resp_10.tStart = t
        key_resp_10.frameNStart = frameN  # exact frame index
        key_resp_10.status = STARTED
        # keyboard checking is just starting
        win.callOnFlip(key_resp_10.clock.reset)  # t=0 on next screen flip
        event.clearEvents(eventType='keyboard')
    if key_resp_10.status == STARTED:
        theseKeys = event.getKeys(keyList=['y', 'n', 'left', 'right', 'space'])
        
        # check for quit:
        if "escape" in theseKeys:
            endExpNow = True
        if len(theseKeys) > 0:  # at least one key was pressed
            key_resp_10.keys = theseKeys[-1]  # just the last key pressed
            key_resp_10.rt = key_resp_10.clock.getTime()
            # a response ends the routine
            continueRoutine = False
    
    # check if all components have finished
    if not continueRoutine:  # a component has requested a forced-end of Routine
        break
    continueRoutine = False  # will revert to True if at least one component still running
    for thisComponent in instructions_3Components:
        if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
            continueRoutine = True
            break  # at least one component has not yet finished
    
    # check for quit (the Esc key)
    if endExpNow or event.getKeys(keyList=["escape"]):
        core.quit()
    
    # refresh the screen
    if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
        win.flip()

# -------Ending Routine "instructions_3"-------
for thisComponent in instructions_3Components:
    if hasattr(thisComponent, "setAutoDraw"):
        thisComponent.setAutoDraw(False)
# check responses
if key_resp_10.keys in ['', [], None]:  # No response was made
    key_resp_10.keys=None
thisExp.addData('key_resp_10.keys',key_resp_10.keys)
if key_resp_10.keys != None:  # we had a response
    thisExp.addData('key_resp_10.rt', key_resp_10.rt)
thisExp.nextEntry()
# the Routine "instructions_3" was not non-slip safe, so reset the non-slip timer
routineTimer.reset()

# ------Prepare to start Routine "instructions_4"-------
t = 0
instructions_4Clock.reset()  # clock
frameN = -1
continueRoutine = True
# update component parameters for each repeat
key_resp_11 = event.BuilderKeyResponse()
# keep track of which components have finished
instructions_4Components = [text_12, key_resp_11]
for thisComponent in instructions_4Components:
    if hasattr(thisComponent, 'status'):
        thisComponent.status = NOT_STARTED

# -------Start Routine "instructions_4"-------
while continueRoutine:
    # get current time
    t = instructions_4Clock.getTime()
    frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
    # update/draw components on each frame
    
    # *text_12* updates
    if t >= 0.0 and text_12.status == NOT_STARTED:
        # keep track of start time/frame for later
        text_12.tStart = t
        text_12.frameNStart = frameN  # exact frame index
        text_12.setAutoDraw(True)
    
    # *key_resp_11* updates
    if t >= 3 and key_resp_11.status == NOT_STARTED:
        # keep track of start time/frame for later
        key_resp_11.tStart = t
        key_resp_11.frameNStart = frameN  # exact frame index
        key_resp_11.status = STARTED
        # keyboard checking is just starting
        win.callOnFlip(key_resp_11.clock.reset)  # t=0 on next screen flip
        event.clearEvents(eventType='keyboard')
    if key_resp_11.status == STARTED:
        theseKeys = event.getKeys(keyList=['y', 'n', 'left', 'right', 'space'])
        
        # check for quit:
        if "escape" in theseKeys:
            endExpNow = True
        if len(theseKeys) > 0:  # at least one key was pressed
            key_resp_11.keys = theseKeys[-1]  # just the last key pressed
            key_resp_11.rt = key_resp_11.clock.getTime()
            # a response ends the routine
            continueRoutine = False
    
    # check if all components have finished
    if not continueRoutine:  # a component has requested a forced-end of Routine
        break
    continueRoutine = False  # will revert to True if at least one component still running
    for thisComponent in instructions_4Components:
        if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
            continueRoutine = True
            break  # at least one component has not yet finished
    
    # check for quit (the Esc key)
    if endExpNow or event.getKeys(keyList=["escape"]):
        core.quit()
    
    # refresh the screen
    if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
        win.flip()

# -------Ending Routine "instructions_4"-------
for thisComponent in instructions_4Components:
    if hasattr(thisComponent, "setAutoDraw"):
        thisComponent.setAutoDraw(False)
# check responses
if key_resp_11.keys in ['', [], None]:  # No response was made
    key_resp_11.keys=None
thisExp.addData('key_resp_11.keys',key_resp_11.keys)
if key_resp_11.keys != None:  # we had a response
    thisExp.addData('key_resp_11.rt', key_resp_11.rt)
thisExp.nextEntry()
# the Routine "instructions_4" was not non-slip safe, so reset the non-slip timer
routineTimer.reset()

# ------Prepare to start Routine "instructions_5"-------
t = 0
instructions_5Clock.reset()  # clock
frameN = -1
continueRoutine = True
# update component parameters for each repeat
key_resp_12 = event.BuilderKeyResponse()
# keep track of which components have finished
instructions_5Components = [text_13, key_resp_12]
for thisComponent in instructions_5Components:
    if hasattr(thisComponent, 'status'):
        thisComponent.status = NOT_STARTED

# -------Start Routine "instructions_5"-------
while continueRoutine:
    # get current time
    t = instructions_5Clock.getTime()
    frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
    # update/draw components on each frame
    
    # *text_13* updates
    if t >= 0.0 and text_13.status == NOT_STARTED:
        # keep track of start time/frame for later
        text_13.tStart = t
        text_13.frameNStart = frameN  # exact frame index
        text_13.setAutoDraw(True)
    
    # *key_resp_12* updates
    if t >= 3 and key_resp_12.status == NOT_STARTED:
        # keep track of start time/frame for later
        key_resp_12.tStart = t
        key_resp_12.frameNStart = frameN  # exact frame index
        key_resp_12.status = STARTED
        # keyboard checking is just starting
        win.callOnFlip(key_resp_12.clock.reset)  # t=0 on next screen flip
        event.clearEvents(eventType='keyboard')
    if key_resp_12.status == STARTED:
        theseKeys = event.getKeys(keyList=['y', 'n', 'left', 'right', 'space'])
        
        # check for quit:
        if "escape" in theseKeys:
            endExpNow = True
        if len(theseKeys) > 0:  # at least one key was pressed
            key_resp_12.keys = theseKeys[-1]  # just the last key pressed
            key_resp_12.rt = key_resp_12.clock.getTime()
            # a response ends the routine
            continueRoutine = False
    
    # check if all components have finished
    if not continueRoutine:  # a component has requested a forced-end of Routine
        break
    continueRoutine = False  # will revert to True if at least one component still running
    for thisComponent in instructions_5Components:
        if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
            continueRoutine = True
            break  # at least one component has not yet finished
    
    # check for quit (the Esc key)
    if endExpNow or event.getKeys(keyList=["escape"]):
        core.quit()
    
    # refresh the screen
    if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
        win.flip()

# -------Ending Routine "instructions_5"-------
for thisComponent in instructions_5Components:
    if hasattr(thisComponent, "setAutoDraw"):
        thisComponent.setAutoDraw(False)
# check responses
if key_resp_12.keys in ['', [], None]:  # No response was made
    key_resp_12.keys=None
thisExp.addData('key_resp_12.keys',key_resp_12.keys)
if key_resp_12.keys != None:  # we had a response
    thisExp.addData('key_resp_12.rt', key_resp_12.rt)
thisExp.nextEntry()
# the Routine "instructions_5" was not non-slip safe, so reset the non-slip timer
routineTimer.reset()

# set up handler to look after randomisation of conditions etc
trials_3 = data.TrialHandler(nReps=int(expInfo['participant'][-3:]) % 2 == 1, method='random', 
    extraInfo=expInfo, originPath=-1,
    trialList=[None],
    seed=None, name='trials_3')
thisExp.addLoop(trials_3)  # add the loop to the experiment
thisTrial_3 = trials_3.trialList[0]  # so we can initialise stimuli with some values
# abbreviate parameter names if possible (e.g. rgb = thisTrial_3.rgb)
if thisTrial_3 != None:
    for paramName in thisTrial_3.keys():
        exec(paramName + '= thisTrial_3.' + paramName)

for thisTrial_3 in trials_3:
    currentLoop = trials_3
    # abbreviate parameter names if possible (e.g. rgb = thisTrial_3.rgb)
    if thisTrial_3 != None:
        for paramName in thisTrial_3.keys():
            exec(paramName + '= thisTrial_3.' + paramName)
    
    # set up handler to look after randomisation of conditions etc
    trials_2 = data.TrialHandler(nReps=2, method='random', 
        extraInfo=expInfo, originPath=-1,
        trialList=data.importConditions('stimuli-train-tright.csv'),
        seed=None, name='trials_2')
    thisExp.addLoop(trials_2)  # add the loop to the experiment
    thisTrial_2 = trials_2.trialList[0]  # so we can initialise stimuli with some values
    # abbreviate parameter names if possible (e.g. rgb = thisTrial_2.rgb)
    if thisTrial_2 != None:
        for paramName in thisTrial_2.keys():
            exec(paramName + '= thisTrial_2.' + paramName)
    
    for thisTrial_2 in trials_2:
        currentLoop = trials_2
        # abbreviate parameter names if possible (e.g. rgb = thisTrial_2.rgb)
        if thisTrial_2 != None:
            for paramName in thisTrial_2.keys():
                exec(paramName + '= thisTrial_2.' + paramName)
        
        # ------Prepare to start Routine "train"-------
        t = 0
        trainClock.reset()  # clock
        frameN = -1
        continueRoutine = True
        routineTimer.add(4.000000)
        # update component parameters for each repeat
        sound_2.setSound(file_name, secs=3.5)
        key_resp_3 = event.BuilderKeyResponse()
        # keep track of which components have finished
        trainComponents = [sound_2, text_2, key_resp_3]
        for thisComponent in trainComponents:
            if hasattr(thisComponent, 'status'):
                thisComponent.status = NOT_STARTED
        
        # -------Start Routine "train"-------
        while continueRoutine and routineTimer.getTime() > 0:
            # get current time
            t = trainClock.getTime()
            frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
            # update/draw components on each frame
            # start/stop sound_2
            if t >= 0.5 and sound_2.status == NOT_STARTED:
                # keep track of start time/frame for later
                sound_2.tStart = t
                sound_2.frameNStart = frameN  # exact frame index
                sound_2.play()  # start the sound (it finishes automatically)
            frameRemains = 0.5 + 3.5- win.monitorFramePeriod * 0.75  # most of one frame period left
            if sound_2.status == STARTED and t >= frameRemains:
                sound_2.stop()  # stop the sound (if longer than duration)
            
            # *text_2* updates
            if t >= 0.0 and text_2.status == NOT_STARTED:
                # keep track of start time/frame for later
                text_2.tStart = t
                text_2.frameNStart = frameN  # exact frame index
                text_2.setAutoDraw(True)
            frameRemains = 0.0 + 4- win.monitorFramePeriod * 0.75  # most of one frame period left
            if text_2.status == STARTED and t >= frameRemains:
                text_2.setAutoDraw(False)
            
            # *key_resp_3* updates
            if t >= 1 and key_resp_3.status == NOT_STARTED:
                # keep track of start time/frame for later
                key_resp_3.tStart = t
                key_resp_3.frameNStart = frameN  # exact frame index
                key_resp_3.status = STARTED
                # keyboard checking is just starting
                win.callOnFlip(key_resp_3.clock.reset)  # t=0 on next screen flip
                event.clearEvents(eventType='keyboard')
            frameRemains = 1 + 3- win.monitorFramePeriod * 0.75  # most of one frame period left
            if key_resp_3.status == STARTED and t >= frameRemains:
                key_resp_3.status = STOPPED
            if key_resp_3.status == STARTED:
                theseKeys = event.getKeys(keyList=['z', 'slash'])
                
                # check for quit:
                if "escape" in theseKeys:
                    endExpNow = True
                if len(theseKeys) > 0:  # at least one key was pressed
                    key_resp_3.keys = theseKeys[-1]  # just the last key pressed
                    key_resp_3.rt = key_resp_3.clock.getTime()
                    # was this 'correct'?
                    if (key_resp_3.keys == str(correct_answer)) or (key_resp_3.keys == correct_answer):
                        key_resp_3.corr = 1
                    else:
                        key_resp_3.corr = 0
                    # a response ends the routine
                    continueRoutine = False
            
            # check if all components have finished
            if not continueRoutine:  # a component has requested a forced-end of Routine
                break
            continueRoutine = False  # will revert to True if at least one component still running
            for thisComponent in trainComponents:
                if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
                    continueRoutine = True
                    break  # at least one component has not yet finished
            
            # check for quit (the Esc key)
            if endExpNow or event.getKeys(keyList=["escape"]):
                core.quit()
            
            # refresh the screen
            if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
                win.flip()
        
        # -------Ending Routine "train"-------
        for thisComponent in trainComponents:
            if hasattr(thisComponent, "setAutoDraw"):
                thisComponent.setAutoDraw(False)
        sound_2.stop()  # ensure sound has stopped at end of routine
        # check responses
        if key_resp_3.keys in ['', [], None]:  # No response was made
            key_resp_3.keys=None
            # was no response the correct answer?!
            if str(correct_answer).lower() == 'none':
               key_resp_3.corr = 1  # correct non-response
            else:
               key_resp_3.corr = 0  # failed to respond (incorrectly)
        # store data for trials_2 (TrialHandler)
        trials_2.addData('key_resp_3.keys',key_resp_3.keys)
        trials_2.addData('key_resp_3.corr', key_resp_3.corr)
        if key_resp_3.keys != None:  # we had a response
            trials_2.addData('key_resp_3.rt', key_resp_3.rt)
        
        # ------Prepare to start Routine "feedback"-------
        t = 0
        feedbackClock.reset()  # clock
        frameN = -1
        continueRoutine = True
        routineTimer.add(2.000000)
        # update component parameters for each repeat
        if not key_resp_3.keys :
            msg="Non hai risposto."
            msg_colour = "white"
        elif key_resp_3.corr:#stored on last run routine
            msg="Corretto!"
            msg_colour = "lime"
        else:
            msg="Ops! Sbagliato."
            msg_colour = "red"
        text_4.setColor(msg_colour, colorSpace='rgb')
        text_4.setText(msg)
        # keep track of which components have finished
        feedbackComponents = [text_4]
        for thisComponent in feedbackComponents:
            if hasattr(thisComponent, 'status'):
                thisComponent.status = NOT_STARTED
        
        # -------Start Routine "feedback"-------
        while continueRoutine and routineTimer.getTime() > 0:
            # get current time
            t = feedbackClock.getTime()
            frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
            # update/draw components on each frame
            
            
            # *text_4* updates
            if t >= 0.5 and text_4.status == NOT_STARTED:
                # keep track of start time/frame for later
                text_4.tStart = t
                text_4.frameNStart = frameN  # exact frame index
                text_4.setAutoDraw(True)
            frameRemains = 0.5 + 1.5- win.monitorFramePeriod * 0.75  # most of one frame period left
            if text_4.status == STARTED and t >= frameRemains:
                text_4.setAutoDraw(False)
            
            # check if all components have finished
            if not continueRoutine:  # a component has requested a forced-end of Routine
                break
            continueRoutine = False  # will revert to True if at least one component still running
            for thisComponent in feedbackComponents:
                if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
                    continueRoutine = True
                    break  # at least one component has not yet finished
            
            # check for quit (the Esc key)
            if endExpNow or event.getKeys(keyList=["escape"]):
                core.quit()
            
            # refresh the screen
            if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
                win.flip()
        
        # -------Ending Routine "feedback"-------
        for thisComponent in feedbackComponents:
            if hasattr(thisComponent, "setAutoDraw"):
                thisComponent.setAutoDraw(False)
        
        thisExp.nextEntry()
        
    # completed 2 repeats of 'trials_2'
    
    
    # ------Prepare to start Routine "ready"-------
    t = 0
    readyClock.reset()  # clock
    frameN = -1
    continueRoutine = True
    # update component parameters for each repeat
    key_resp_4 = event.BuilderKeyResponse()
    # keep track of which components have finished
    readyComponents = [text_3, key_resp_4]
    for thisComponent in readyComponents:
        if hasattr(thisComponent, 'status'):
            thisComponent.status = NOT_STARTED
    
    # -------Start Routine "ready"-------
    while continueRoutine:
        # get current time
        t = readyClock.getTime()
        frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
        # update/draw components on each frame
        
        # *text_3* updates
        if t >= 0.5 and text_3.status == NOT_STARTED:
            # keep track of start time/frame for later
            text_3.tStart = t
            text_3.frameNStart = frameN  # exact frame index
            text_3.setAutoDraw(True)
        
        # *key_resp_4* updates
        if t >= 0.0 and key_resp_4.status == NOT_STARTED:
            # keep track of start time/frame for later
            key_resp_4.tStart = t
            key_resp_4.frameNStart = frameN  # exact frame index
            key_resp_4.status = STARTED
            # keyboard checking is just starting
            win.callOnFlip(key_resp_4.clock.reset)  # t=0 on next screen flip
            event.clearEvents(eventType='keyboard')
        if key_resp_4.status == STARTED:
            theseKeys = event.getKeys(keyList=['y', 'n', 'left', 'right', 'space'])
            
            # check for quit:
            if "escape" in theseKeys:
                endExpNow = True
            if len(theseKeys) > 0:  # at least one key was pressed
                key_resp_4.keys = theseKeys[-1]  # just the last key pressed
                key_resp_4.rt = key_resp_4.clock.getTime()
                # a response ends the routine
                continueRoutine = False
        
        # check if all components have finished
        if not continueRoutine:  # a component has requested a forced-end of Routine
            break
        continueRoutine = False  # will revert to True if at least one component still running
        for thisComponent in readyComponents:
            if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
                continueRoutine = True
                break  # at least one component has not yet finished
        
        # check for quit (the Esc key)
        if endExpNow or event.getKeys(keyList=["escape"]):
            core.quit()
        
        # refresh the screen
        if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
            win.flip()
    
    # -------Ending Routine "ready"-------
    for thisComponent in readyComponents:
        if hasattr(thisComponent, "setAutoDraw"):
            thisComponent.setAutoDraw(False)
    # check responses
    if key_resp_4.keys in ['', [], None]:  # No response was made
        key_resp_4.keys=None
    trials_3.addData('key_resp_4.keys',key_resp_4.keys)
    if key_resp_4.keys != None:  # we had a response
        trials_3.addData('key_resp_4.rt', key_resp_4.rt)
    # the Routine "ready" was not non-slip safe, so reset the non-slip timer
    routineTimer.reset()
    
    # set up handler to look after randomisation of conditions etc
    trials = data.TrialHandler(nReps=5, method='random', 
        extraInfo=expInfo, originPath=-1,
        trialList=data.importConditions(u'stimuli-tright.csv'),
        seed=None, name='trials')
    thisExp.addLoop(trials)  # add the loop to the experiment
    thisTrial = trials.trialList[0]  # so we can initialise stimuli with some values
    # abbreviate parameter names if possible (e.g. rgb = thisTrial.rgb)
    if thisTrial != None:
        for paramName in thisTrial.keys():
            exec(paramName + '= thisTrial.' + paramName)
    
    for thisTrial in trials:
        currentLoop = trials
        # abbreviate parameter names if possible (e.g. rgb = thisTrial.rgb)
        if thisTrial != None:
            for paramName in thisTrial.keys():
                exec(paramName + '= thisTrial.' + paramName)
        
        # ------Prepare to start Routine "trial"-------
        t = 0
        trialClock.reset()  # clock
        frameN = -1
        continueRoutine = True
        # update component parameters for each repeat
        sound_1.setSound(file_name, secs=-1)
        key_resp_2 = event.BuilderKeyResponse()
        # keep track of which components have finished
        trialComponents = [sound_1, text, key_resp_2]
        for thisComponent in trialComponents:
            if hasattr(thisComponent, 'status'):
                thisComponent.status = NOT_STARTED
        
        # -------Start Routine "trial"-------
        while continueRoutine:
            # get current time
            t = trialClock.getTime()
            frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
            # update/draw components on each frame
            # start/stop sound_1
            if t >= 0.5 and sound_1.status == NOT_STARTED:
                # keep track of start time/frame for later
                sound_1.tStart = t
                sound_1.frameNStart = frameN  # exact frame index
                sound_1.play()  # start the sound (it finishes automatically)
            
            # *text* updates
            if t >= 0.0 and text.status == NOT_STARTED:
                # keep track of start time/frame for later
                text.tStart = t
                text.frameNStart = frameN  # exact frame index
                text.setAutoDraw(True)
            
            # *key_resp_2* updates
            if t >= 1 and key_resp_2.status == NOT_STARTED:
                # keep track of start time/frame for later
                key_resp_2.tStart = t
                key_resp_2.frameNStart = frameN  # exact frame index
                key_resp_2.status = STARTED
                # keyboard checking is just starting
                win.callOnFlip(key_resp_2.clock.reset)  # t=0 on next screen flip
                event.clearEvents(eventType='keyboard')
            if key_resp_2.status == STARTED:
                theseKeys = event.getKeys(keyList=['z', 'slash'])
                
                # check for quit:
                if "escape" in theseKeys:
                    endExpNow = True
                if len(theseKeys) > 0:  # at least one key was pressed
                    key_resp_2.keys = theseKeys[-1]  # just the last key pressed
                    key_resp_2.rt = key_resp_2.clock.getTime()
                    # a response ends the routine
                    continueRoutine = False
            
            # check if all components have finished
            if not continueRoutine:  # a component has requested a forced-end of Routine
                break
            continueRoutine = False  # will revert to True if at least one component still running
            for thisComponent in trialComponents:
                if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
                    continueRoutine = True
                    break  # at least one component has not yet finished
            
            # check for quit (the Esc key)
            if endExpNow or event.getKeys(keyList=["escape"]):
                core.quit()
            
            # refresh the screen
            if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
                win.flip()
        
        # -------Ending Routine "trial"-------
        for thisComponent in trialComponents:
            if hasattr(thisComponent, "setAutoDraw"):
                thisComponent.setAutoDraw(False)
        sound_1.stop()  # ensure sound has stopped at end of routine
        # check responses
        if key_resp_2.keys in ['', [], None]:  # No response was made
            key_resp_2.keys=None
        trials.addData('key_resp_2.keys',key_resp_2.keys)
        if key_resp_2.keys != None:  # we had a response
            trials.addData('key_resp_2.rt', key_resp_2.rt)
        # the Routine "trial" was not non-slip safe, so reset the non-slip timer
        routineTimer.reset()
        thisExp.nextEntry()
        
    # completed 5 repeats of 'trials'
    
    thisExp.nextEntry()
    
# completed int(expInfo['participant'][-3:]) % 2 == 1 repeats of 'trials_3'


# set up handler to look after randomisation of conditions etc
trials_4 = data.TrialHandler(nReps=int(expInfo['participant'][-3:]) % 2 == 0, method='random', 
    extraInfo=expInfo, originPath=-1,
    trialList=[None],
    seed=None, name='trials_4')
thisExp.addLoop(trials_4)  # add the loop to the experiment
thisTrial_4 = trials_4.trialList[0]  # so we can initialise stimuli with some values
# abbreviate parameter names if possible (e.g. rgb = thisTrial_4.rgb)
if thisTrial_4 != None:
    for paramName in thisTrial_4.keys():
        exec(paramName + '= thisTrial_4.' + paramName)

for thisTrial_4 in trials_4:
    currentLoop = trials_4
    # abbreviate parameter names if possible (e.g. rgb = thisTrial_4.rgb)
    if thisTrial_4 != None:
        for paramName in thisTrial_4.keys():
            exec(paramName + '= thisTrial_4.' + paramName)
    
    # set up handler to look after randomisation of conditions etc
    trials_5 = data.TrialHandler(nReps=5, method='random', 
        extraInfo=expInfo, originPath=-1,
        trialList=data.importConditions('stimuli-train-tleft.csv'),
        seed=None, name='trials_5')
    thisExp.addLoop(trials_5)  # add the loop to the experiment
    thisTrial_5 = trials_5.trialList[0]  # so we can initialise stimuli with some values
    # abbreviate parameter names if possible (e.g. rgb = thisTrial_5.rgb)
    if thisTrial_5 != None:
        for paramName in thisTrial_5.keys():
            exec(paramName + '= thisTrial_5.' + paramName)
    
    for thisTrial_5 in trials_5:
        currentLoop = trials_5
        # abbreviate parameter names if possible (e.g. rgb = thisTrial_5.rgb)
        if thisTrial_5 != None:
            for paramName in thisTrial_5.keys():
                exec(paramName + '= thisTrial_5.' + paramName)
        
        # ------Prepare to start Routine "train_2"-------
        t = 0
        train_2Clock.reset()  # clock
        frameN = -1
        continueRoutine = True
        routineTimer.add(4.000000)
        # update component parameters for each repeat
        sound_3.setSound(file_name, secs=3.5)
        key_resp_6 = event.BuilderKeyResponse()
        # keep track of which components have finished
        train_2Components = [sound_3, text_6, key_resp_6]
        for thisComponent in train_2Components:
            if hasattr(thisComponent, 'status'):
                thisComponent.status = NOT_STARTED
        
        # -------Start Routine "train_2"-------
        while continueRoutine and routineTimer.getTime() > 0:
            # get current time
            t = train_2Clock.getTime()
            frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
            # update/draw components on each frame
            # start/stop sound_3
            if t >= 0.5 and sound_3.status == NOT_STARTED:
                # keep track of start time/frame for later
                sound_3.tStart = t
                sound_3.frameNStart = frameN  # exact frame index
                sound_3.play()  # start the sound (it finishes automatically)
            frameRemains = 0.5 + 3.5- win.monitorFramePeriod * 0.75  # most of one frame period left
            if sound_3.status == STARTED and t >= frameRemains:
                sound_3.stop()  # stop the sound (if longer than duration)
            
            # *text_6* updates
            if t >= 0.0 and text_6.status == NOT_STARTED:
                # keep track of start time/frame for later
                text_6.tStart = t
                text_6.frameNStart = frameN  # exact frame index
                text_6.setAutoDraw(True)
            frameRemains = 0.0 + 4- win.monitorFramePeriod * 0.75  # most of one frame period left
            if text_6.status == STARTED and t >= frameRemains:
                text_6.setAutoDraw(False)
            
            # *key_resp_6* updates
            if t >= 1 and key_resp_6.status == NOT_STARTED:
                # keep track of start time/frame for later
                key_resp_6.tStart = t
                key_resp_6.frameNStart = frameN  # exact frame index
                key_resp_6.status = STARTED
                # keyboard checking is just starting
                win.callOnFlip(key_resp_6.clock.reset)  # t=0 on next screen flip
                event.clearEvents(eventType='keyboard')
            frameRemains = 1 + 3- win.monitorFramePeriod * 0.75  # most of one frame period left
            if key_resp_6.status == STARTED and t >= frameRemains:
                key_resp_6.status = STOPPED
            if key_resp_6.status == STARTED:
                theseKeys = event.getKeys(keyList=['z', 'slash'])
                
                # check for quit:
                if "escape" in theseKeys:
                    endExpNow = True
                if len(theseKeys) > 0:  # at least one key was pressed
                    key_resp_6.keys = theseKeys[-1]  # just the last key pressed
                    key_resp_6.rt = key_resp_6.clock.getTime()
                    # was this 'correct'?
                    if (key_resp_6.keys == str(correct_answer)) or (key_resp_6.keys == correct_answer):
                        key_resp_6.corr = 1
                    else:
                        key_resp_6.corr = 0
                    # a response ends the routine
                    continueRoutine = False
            
            # check if all components have finished
            if not continueRoutine:  # a component has requested a forced-end of Routine
                break
            continueRoutine = False  # will revert to True if at least one component still running
            for thisComponent in train_2Components:
                if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
                    continueRoutine = True
                    break  # at least one component has not yet finished
            
            # check for quit (the Esc key)
            if endExpNow or event.getKeys(keyList=["escape"]):
                core.quit()
            
            # refresh the screen
            if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
                win.flip()
        
        # -------Ending Routine "train_2"-------
        for thisComponent in train_2Components:
            if hasattr(thisComponent, "setAutoDraw"):
                thisComponent.setAutoDraw(False)
        sound_3.stop()  # ensure sound has stopped at end of routine
        # check responses
        if key_resp_6.keys in ['', [], None]:  # No response was made
            key_resp_6.keys=None
            # was no response the correct answer?!
            if str(correct_answer).lower() == 'none':
               key_resp_6.corr = 1  # correct non-response
            else:
               key_resp_6.corr = 0  # failed to respond (incorrectly)
        # store data for trials_5 (TrialHandler)
        trials_5.addData('key_resp_6.keys',key_resp_6.keys)
        trials_5.addData('key_resp_6.corr', key_resp_6.corr)
        if key_resp_6.keys != None:  # we had a response
            trials_5.addData('key_resp_6.rt', key_resp_6.rt)
        
        # ------Prepare to start Routine "feedback_2"-------
        t = 0
        feedback_2Clock.reset()  # clock
        frameN = -1
        continueRoutine = True
        routineTimer.add(2.000000)
        # update component parameters for each repeat
        if not key_resp_3.keys :
            msg="Non hai risposto."
            msg_colour = "white"
        elif key_resp_3.corr:#stored on last run routine
            msg="Corretto!"
            msg_colour = "lime"
        else:
            msg="Ops! Sbagliato."
            msg_colour = "red"
        text_7.setColor(msg_colour, colorSpace='rgb')
        text_7.setText(msg)
        # keep track of which components have finished
        feedback_2Components = [text_7]
        for thisComponent in feedback_2Components:
            if hasattr(thisComponent, 'status'):
                thisComponent.status = NOT_STARTED
        
        # -------Start Routine "feedback_2"-------
        while continueRoutine and routineTimer.getTime() > 0:
            # get current time
            t = feedback_2Clock.getTime()
            frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
            # update/draw components on each frame
            
            
            # *text_7* updates
            if t >= 0.5 and text_7.status == NOT_STARTED:
                # keep track of start time/frame for later
                text_7.tStart = t
                text_7.frameNStart = frameN  # exact frame index
                text_7.setAutoDraw(True)
            frameRemains = 0.5 + 1.5- win.monitorFramePeriod * 0.75  # most of one frame period left
            if text_7.status == STARTED and t >= frameRemains:
                text_7.setAutoDraw(False)
            
            # check if all components have finished
            if not continueRoutine:  # a component has requested a forced-end of Routine
                break
            continueRoutine = False  # will revert to True if at least one component still running
            for thisComponent in feedback_2Components:
                if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
                    continueRoutine = True
                    break  # at least one component has not yet finished
            
            # check for quit (the Esc key)
            if endExpNow or event.getKeys(keyList=["escape"]):
                core.quit()
            
            # refresh the screen
            if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
                win.flip()
        
        # -------Ending Routine "feedback_2"-------
        for thisComponent in feedback_2Components:
            if hasattr(thisComponent, "setAutoDraw"):
                thisComponent.setAutoDraw(False)
        
        thisExp.nextEntry()
        
    # completed 5 repeats of 'trials_5'
    
    
    # ------Prepare to start Routine "ready_2"-------
    t = 0
    ready_2Clock.reset()  # clock
    frameN = -1
    continueRoutine = True
    # update component parameters for each repeat
    key_resp_7 = event.BuilderKeyResponse()
    # keep track of which components have finished
    ready_2Components = [text_8, key_resp_7]
    for thisComponent in ready_2Components:
        if hasattr(thisComponent, 'status'):
            thisComponent.status = NOT_STARTED
    
    # -------Start Routine "ready_2"-------
    while continueRoutine:
        # get current time
        t = ready_2Clock.getTime()
        frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
        # update/draw components on each frame
        
        # *text_8* updates
        if t >= 0.5 and text_8.status == NOT_STARTED:
            # keep track of start time/frame for later
            text_8.tStart = t
            text_8.frameNStart = frameN  # exact frame index
            text_8.setAutoDraw(True)
        
        # *key_resp_7* updates
        if t >= 0.0 and key_resp_7.status == NOT_STARTED:
            # keep track of start time/frame for later
            key_resp_7.tStart = t
            key_resp_7.frameNStart = frameN  # exact frame index
            key_resp_7.status = STARTED
            # keyboard checking is just starting
            win.callOnFlip(key_resp_7.clock.reset)  # t=0 on next screen flip
            event.clearEvents(eventType='keyboard')
        if key_resp_7.status == STARTED:
            theseKeys = event.getKeys(keyList=['y', 'n', 'left', 'right', 'space'])
            
            # check for quit:
            if "escape" in theseKeys:
                endExpNow = True
            if len(theseKeys) > 0:  # at least one key was pressed
                key_resp_7.keys = theseKeys[-1]  # just the last key pressed
                key_resp_7.rt = key_resp_7.clock.getTime()
                # a response ends the routine
                continueRoutine = False
        
        # check if all components have finished
        if not continueRoutine:  # a component has requested a forced-end of Routine
            break
        continueRoutine = False  # will revert to True if at least one component still running
        for thisComponent in ready_2Components:
            if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
                continueRoutine = True
                break  # at least one component has not yet finished
        
        # check for quit (the Esc key)
        if endExpNow or event.getKeys(keyList=["escape"]):
            core.quit()
        
        # refresh the screen
        if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
            win.flip()
    
    # -------Ending Routine "ready_2"-------
    for thisComponent in ready_2Components:
        if hasattr(thisComponent, "setAutoDraw"):
            thisComponent.setAutoDraw(False)
    # check responses
    if key_resp_7.keys in ['', [], None]:  # No response was made
        key_resp_7.keys=None
    trials_4.addData('key_resp_7.keys',key_resp_7.keys)
    if key_resp_7.keys != None:  # we had a response
        trials_4.addData('key_resp_7.rt', key_resp_7.rt)
    # the Routine "ready_2" was not non-slip safe, so reset the non-slip timer
    routineTimer.reset()
    
    # set up handler to look after randomisation of conditions etc
    trials_6 = data.TrialHandler(nReps=5, method='random', 
        extraInfo=expInfo, originPath=-1,
        trialList=data.importConditions('stimuli-tleft.csv'),
        seed=None, name='trials_6')
    thisExp.addLoop(trials_6)  # add the loop to the experiment
    thisTrial_6 = trials_6.trialList[0]  # so we can initialise stimuli with some values
    # abbreviate parameter names if possible (e.g. rgb = thisTrial_6.rgb)
    if thisTrial_6 != None:
        for paramName in thisTrial_6.keys():
            exec(paramName + '= thisTrial_6.' + paramName)
    
    for thisTrial_6 in trials_6:
        currentLoop = trials_6
        # abbreviate parameter names if possible (e.g. rgb = thisTrial_6.rgb)
        if thisTrial_6 != None:
            for paramName in thisTrial_6.keys():
                exec(paramName + '= thisTrial_6.' + paramName)
        
        # ------Prepare to start Routine "trial_2"-------
        t = 0
        trial_2Clock.reset()  # clock
        frameN = -1
        continueRoutine = True
        # update component parameters for each repeat
        sound_4.setSound(file_name, secs=-1)
        key_resp_8 = event.BuilderKeyResponse()
        # keep track of which components have finished
        trial_2Components = [sound_4, text_9, key_resp_8]
        for thisComponent in trial_2Components:
            if hasattr(thisComponent, 'status'):
                thisComponent.status = NOT_STARTED
        
        # -------Start Routine "trial_2"-------
        while continueRoutine:
            # get current time
            t = trial_2Clock.getTime()
            frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
            # update/draw components on each frame
            # start/stop sound_4
            if t >= 0.5 and sound_4.status == NOT_STARTED:
                # keep track of start time/frame for later
                sound_4.tStart = t
                sound_4.frameNStart = frameN  # exact frame index
                sound_4.play()  # start the sound (it finishes automatically)
            
            # *text_9* updates
            if t >= 0.0 and text_9.status == NOT_STARTED:
                # keep track of start time/frame for later
                text_9.tStart = t
                text_9.frameNStart = frameN  # exact frame index
                text_9.setAutoDraw(True)
            
            # *key_resp_8* updates
            if t >= 1 and key_resp_8.status == NOT_STARTED:
                # keep track of start time/frame for later
                key_resp_8.tStart = t
                key_resp_8.frameNStart = frameN  # exact frame index
                key_resp_8.status = STARTED
                # keyboard checking is just starting
                win.callOnFlip(key_resp_8.clock.reset)  # t=0 on next screen flip
                event.clearEvents(eventType='keyboard')
            if key_resp_8.status == STARTED:
                theseKeys = event.getKeys(keyList=['z', 'slash'])
                
                # check for quit:
                if "escape" in theseKeys:
                    endExpNow = True
                if len(theseKeys) > 0:  # at least one key was pressed
                    key_resp_8.keys = theseKeys[-1]  # just the last key pressed
                    key_resp_8.rt = key_resp_8.clock.getTime()
                    # a response ends the routine
                    continueRoutine = False
            
            # check if all components have finished
            if not continueRoutine:  # a component has requested a forced-end of Routine
                break
            continueRoutine = False  # will revert to True if at least one component still running
            for thisComponent in trial_2Components:
                if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
                    continueRoutine = True
                    break  # at least one component has not yet finished
            
            # check for quit (the Esc key)
            if endExpNow or event.getKeys(keyList=["escape"]):
                core.quit()
            
            # refresh the screen
            if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
                win.flip()
        
        # -------Ending Routine "trial_2"-------
        for thisComponent in trial_2Components:
            if hasattr(thisComponent, "setAutoDraw"):
                thisComponent.setAutoDraw(False)
        sound_4.stop()  # ensure sound has stopped at end of routine
        # check responses
        if key_resp_8.keys in ['', [], None]:  # No response was made
            key_resp_8.keys=None
        trials_6.addData('key_resp_8.keys',key_resp_8.keys)
        if key_resp_8.keys != None:  # we had a response
            trials_6.addData('key_resp_8.rt', key_resp_8.rt)
        # the Routine "trial_2" was not non-slip safe, so reset the non-slip timer
        routineTimer.reset()
        thisExp.nextEntry()
        
    # completed 5 repeats of 'trials_6'
    
    thisExp.nextEntry()
    
# completed int(expInfo['participant'][-3:]) % 2 == 0 repeats of 'trials_4'



# these shouldn't be strictly necessary (should auto-save)
thisExp.saveAsWideText(filename+'.csv')
thisExp.saveAsPickle(filename)
# make sure everything is closed down
thisExp.abort()  # or data files will save again on exit
win.close()
core.quit()
