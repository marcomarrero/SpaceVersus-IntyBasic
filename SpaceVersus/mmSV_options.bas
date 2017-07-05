'-----mmSV - Options -----------------------------
CONST PADDELAY=12
CONST MINP1MENU=1:CONST MAXP1MENU=5
CONST MINP2MENU=5:CONST MAXP2MENU=10

'--print common options----
OptionPrintGamePadX:PROCEDURE
	GOSUB OptionIcon:PRINT "PadSidewys:":RETURN
END
OptionPrintEnergyXX:PROCEDURE
	GOSUB OptionIcon:PRINT "Energy    :":RETURN
END
OptionPrintAutoFire: PROCEDURE
	GOSUB OptionIcon:PRINT "Auto Fire :":RETURN
END
'---------------------------------------
OptionScreen: PROCEDURE
	CLS	
	GOSUB ResetMusic
	SPRITE 1,0
	P1Held=MINP1MENU
	P2Held=MINP2MENU+3	'initial menu position 2p=auto fire
	SOUND 3, 4500, &0011	'Envelope duration, shape. [continue b3][attack b2][alt b1][hold b0] 1001=\__________________________________
	SOUND 4, 53, &00011100
			
	P1Shoot=1:P2Shoot=1	'0=option change, reset to 1 when pad centers
	Counter=0:Counter1=0		
	ContKeyClear=0	'1=Key has cleared
	
	PRINT COLOR CS_WHITE,"-Options-----9=Exit-" 'Enter is read as right... GEEZ!!
	PRINT AT 20 COLOR CS_BLUE: GOSUB DrawBar3:PRINT AT 26, "Player2"
	PRINT AT 100 COLOR CS_RED: GOSUB DrawBar3:PRINT AT 108, "vs"
	PRINT AT 140 COLOR CS_DARKGREEN:GOSUB DrawBar3:PRINT AT 146,"Player1"

OptionScreenLoop:
	WAIT	
	IF CONT.KEY=9 AND ContKeyClear THEN RETURN
	IF CONT.KEY=12 THEN ContKeyClear=1	
	GOSUB VDISK
	
	y=20:by3a=0
	GOSUB OptionIconMove
	GOSUB OptionPrintAutoFire: x=P1AutoFire: GOSUB OptionAuto: P1AutoFire=x	'40:1:AutoFire
	GOSUB OptionPrintEnergyXX:x=Player1Energy:GOSUB OptionEnergy:Player1Energy=x:PRINT <.3>x			'60:2:Energy
	GOSUB OptionPrintGamePadX:x=GamePad1:GOSUB OptionPad:GamePad1=x			'80:3:Gamepad
	GOSUB OptionIcon':PRINT COLOR CS_BLUE,"-------VS--------"					'4
	GOSUB OptionIcon:PRINT "UFO Attack:": GOSUB OptionUFO					'5:UFO <--- SHARED BETWEEN 2 players!		
	
	GOSUB OptionIcon':PRINT COLOR CS_BLUE,"----Player 1-----"					'6
	GOSUB OptionIcon:PRINT "Difficulty:": GOSUB OptionDifficulty				'7:Difficulty
	GOSUB OptionPrintAutoFire: x=P2AutoFire: GOSUB OptionAuto: P2AutoFire=x	'8:AutoFire
	GOSUB OptionPrintEnergyXX:x=Player2Energy:GOSUB OptionEnergy:Player2Energy=x:PRINT <.3>x		'9:Energy
	GOSUB OptionPrintGamePadX:x=GamePad2:GOSUB OptionPad:GamePad2=x			'10:GamePad
	
	'cursor
	SPRITE 0, 8 + VISIBLE, (P1Held+2)*8 + 2 + FLIPY, SPR_SHIP1
	SPRITE 2, 16 + VISIBLE, (P2Held+2)*8 + 2, SPR_SHIP2

	GOTO OptionScreenLoop
END

'-----------cursors------------
OptionIcon: PROCEDURE	
	y=y+20
	by3a=by3a+1			'IF P1Held=by3a THEN PRINT AT y COLOR CS_LIGHTBLUE,"\281" ELSE PRINT AT y COLOR CS_TAN," "
	PRINT AT y+3 COLOR CS_TAN
RETURN
END

OptionIconMove: PROCEDURE
	Svol2=0 'make sound	
	IF CONT2=$FF00 THEN P1SHoot=0
	IF P1Shoot THEN
		P1Shoot=P1Shoot-1
	ELSE
		IF P1Down THEN 
			P1Shoot=PADDELAY
			IF P1Held<MAXP1MENU THEN P1Held=P1Held+1:Svol2=1
		ELSEIF P1Up THEN 
			P1Shoot=PADDELAY
			IF P1Held>MINP1MENU THEN P1Held=P1Held-1:Svol2=1
		END IF		
	END IF	
	
	IF CONT1=$FF00 THEN P2Shoot=0
	IF P2Shoot THEN
		P2Shoot=P2Shoot-1
	ELSE
		IF P2Down THEN 
			P2Shoot=PADDELAY
			IF P2Held<MAXP2MENU THEN P2Held=P2Held+1:Svol2=Svol2+2
		ELSEIF P2Up THEN 
			P2Shoot=PADDELAY
			IF P2Held>MINP2MENU THEN P2Held=P2Held-1:Svol2=Svol2+2
		END IF
	END IF
	
	'Play note on movement.. Doesn't work..	'IF Svol2=1 THEN	'	PLAY P1Ping	'ELSEIF Svol2=2 THEN	'	PLAY P2Ping	'ELSE 	'	PLAY P3Ping	'END IF
	IF Svol2 THEN
		'ContKeyClear=0
		SOUND 3, 800, &1001
		IF SVol2=1 THEN 
			SOUND 1, 200,48:SOUND 0, 0,0
		ELSEIF SVol2=2 THEN 
			SOUND 0, 160,48:SOUND 1, 0,0 
		ELSE
			SOUND 0, 160,48:SOUND 1, 200,48
		END IF		
	END IF
RETURN
END

OptionReadPads: PROCEDURE
	Svol2=0
	IF P1Held=by3a THEN 
		IF P1Shoot=0 THEN			
			IF P1Right THEN P1Shoot=PADDELAY:Svol2=1
			IF P1Left THEN  P1Shoot=PADDELAY:Svol2=2
		END IF
	END IF		
	
	IF P2Held=by3a THEN
		IF P2Shoot=0 THEN
			IF P2Right THEN P2Shoot=PADDELAY:Svol2=1
			IF P2Left THEN  P2Shoot=PADDELAY:Svol2=2
		END IF
	END IF
	IF Svol2<>0 THEN ContKeyClear=0
RETURN
END

'-----------OPTIONS------------
OptionYesNO: PROCEDURE
	PRINT COLOR CS_YELLOW
	IF x=0 THEN PRINT "No  " ELSE IF x=1 THEN PRINT "Yes " ELSE PRINT "Auto"
RETURN
END

OptionEnergy: PROCEDURE
	GOSUB OptionReadPads
	IF sVol2=1 THEN 
		IF x<125 THEN x=x+5
	ELSEIF sVol2=2 THEN 
		IF x>75 THEN x=x-5
	ELSE
		'
	END IF
RETURN
END

OptionAuto: PROCEDURE	
	GOSUB OptionReadPads
	IF sVol2=1 THEN 
		x=x+1:IF x>2 THEN x=0
	ELSEIF sVol2=2 THEN 
		IF x<>0 THEN x=x-1
	END IF
	GOSUB OptionYesNO	
RETURN
END

OptionDifficulty: PROCEDURE
	GOSUB OptionReadPads
	IF sVol2=1 THEN 
		Difficulty=Difficulty+1:IF Difficulty=3 THEN Difficulty=0
	ELSEIF sVol2=2 THEN 
		IF x<>0 THEN Difficulty=Difficulty-1 ELSE Difficulty=2
	END IF
	PRINT COLOR CS_YELLOW
	IF Difficulty=0 THEN PRINT "Normal" ELSE IF Difficulty=1 THEN PRINT "Hard  " ELSE PRINT "Insane"
RETURN
END

OptionPad: PROCEDURE	
	GOSUB OptionReadPads
	IF sVol2 THEN x=x XOR 1
	GOSUB OptionYesNO
RETURN
END

OptionUFO: PROCEDURE	
	x=UFO:Gosub OptionAuto:UFO=x
RETURN
END



