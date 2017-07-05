'CPU routines, general functions (redraw, reset vars at level start, etc)

Player1CPU: PROCEDURE 
	'P1shoot, P1Held (frozen), p1Left, p1Right, P1ShootHeld '#x1 (MINX,MAXX)	
	
	CONST CMAXX = MAXX-4	'No corners
	CONST CMINX = MINX+4
		
	counter2=counter2+1
	ON CPUplayer GOTO CPU1, CPU1, CPU2, CPU3, CPU4, CPU5, CPU6, CPU7, CPU8, CPU9, CPU10
	
'"Colossus"	follows player ocassionally. Turns invisible
CPU1:	
	P1shoot=1: P1ShootHeld=0
	if CPUstat=0 THEN p1Right=1:p1Left=0 ELSE p1Right=0:p1Left=1
	if #x1<=CMINX then CPUstat=0 ELSE if #x1>=CMAXX THEN CPUstat=1
	'random turn	
	if counter2=64 then counter2=0	
	if counter2=12 THEN
		counter2=0
		if #x1<#x2 THEN CPUstat=0 ELSE CPUstat=1
	END IF
	
	'2nd colossus will be invisible!
	'IF P1Closer THEN
		IF Counter=0 THEN 			
			#CPU_Spr_Move= CPU_SHIP0 + counter3
			'#CPU_Spr_Held= CPU_SHIP0H + counter3
			#CPU_Spr_Turn= CPU_TURN0 + counter3	
			counter3=counter3 XOR 1
		END IF
	'END IF
	
	RETURN

'"Jochua" switches from left/right to killer mode.wavy shot
CPU2:
	P1shoot=1: P1ShootHeld=0:P1shield=0
	if CPUstat=0 THEN p1Right=1:p1Left=0 ELSE p1Right=0:p1Left=1
	if #x1<CMINX then #x1=CMINX:CPUstat=0 ELSE if #x1>CMAXX THEN #x1=CMAXX:CPUstat=1

	'switch from good to bad
	IF counter2=0 THEN 		
		P1ShootHeld=99	
		P1shoot=0		
		if e1>25 THEN
			#CPU_Spr_Move= CPU_SHIP0 + SPR_CYAN + counter3
			#CPU_Spr_Held= CPU_SHIP0H + SPR_CYAN + counter3
			#CPU_Spr_Turn= CPU_TURN0 + SPR_CYAN + counter3			
		end if
		counter3=counter3 XOR 1
	END IF
	
	IF counter3 then 'attack!!				
		IF RAND<50 THEN IF #x1<#x2 THEN CPUstat=0 ELSE CPUstat=1	 'get close!
		IF #boomX1 THEN p1shield=1	'shield!
		waveshoot=waveshoot+1
		IF #bx1 THEN 
			IF waveshoot<4 THEN
				#bx1 = #bx1 - 2
			ELSE
				#bx1 = #bx1 + 2
				if waveshoot>8 then waveshoot=0
			END IF
		END IF
		
	ELSE		'good!		
		IF counter=0 THEN 
			CPUstat=CPUstat XOR 1 
		ELSEIF counter=100 then 
			CPUstat=CPUstat XOR 1
		END IF
	END IF
	RETURN

	 
'"Mastercon" shoots laser! shoots at corners too. 
'basic left/right pattern. Trick is to shoot ahead
CPU3:
	P1shoot=1: IF P1ShootHeld<127 THEN P1ShootHeld=P1ShootHeld+20
	if CPUstat=0 THEN p1Right=1:p1Left=0 ELSE p1Right=0:p1Left=1
	if #x1<=CMINX then 
		CPUstat=0:p1shoot=0 :#x1=#x1+2
	ELSEIF #x1>=CMAXX THEN 
		CPUstat=1:p1shoot=0:#x1=#x1-2
	ELSE	'random turn
		if counter2=35 THEN
			counter2=0
			if #bx1=0 THEN p1shoot=0	'don't double shoot...
			if #x1<#x2 THEN CPUstat=0 ELSE CPUstat=1
		END IF
	END IF
	
	IF P1Closer THEN
		IF Counter=0 THEN 			
			#CPU_Spr_Move= CPU_SHIP0 + counter3
			'#CPU_Spr_Held= CPU_SHIP0H + counter3
			#CPU_Spr_Turn= CPU_TURN0 + CS_BLUE	
			counter3=counter3 XOR 1
		END IF
	END IF
	
	RETURN

'NetSky. Will shield on 1st laser, keep shielding if p2 holds button
'
CPU4:
	P1shoot=1: P1ShootHeld=0:p1shield=0
	if CPUstat=0 THEN p1Right=1:p1Left=0 ELSE p1Right=0:p1Left=1
	if #x1=CMINX then CPUstat=0 ELSE if #x1=CMAXX THEN CPUstat=1
	
	'random turn, towards player
	if counter2=10 THEN
		counter2=0
		if #x1<#x2 THEN CPUstat=0 ELSE CPUstat=1
	END IF
	
	
	
	IF ABS(#x1-#x2)>5 THEN 
		IF P2Damage=PLaserDamage THEN P1Shield=1 ELSE P1shoot=0	'Shield if P2 shot laser close	
	END IF
	RETURN

'"BoroTron" follows player ocassionally, only shoots when close, will shield from laser
CPU5:
	P1shoot=1: P1ShootHeld=0:p1shield=0
	if CPUstat=0 THEN p1Right=1:p1Left=0 ELSE p1Right=0:p1Left=1
	if #x1=CMINX then CPUstat=0 ELSE if #x1=CMAXX THEN CPUstat=1
	'Always follow player
	if counter2=4 THEN
		counter2=0
		if #x1<#x2 THEN CPUstat=0 ELSE CPUstat=1
	END IF
	
	'Maybe Shield if P2 shot laser nearby
	IF ABS(#x1-#x2)<8 THEN 
		IF P2Damage=PLaserDamage THEN IF Counter<20 THEN P1Shield=1 ELSE P1shoot=0	
	END IF
	RETURN

'Viky: dissappears, always shield from laser!
CPU6:
	P1shoot=1: P1ShootHeld=0:P1Shield=0	
	
	'turn at corners, turn if hit
	if #x1<=CMINX then 
		CPUstat=0
	ELSEIF #x1>=CMAXX THEN 
		CPUstat=1
	ELSEIF #boomX1 THEN 
		CPUstat=CPUstat XOR 1	'turn if hit
	ELSE
		'random turn
		if counter2=40 THEN
			counter2=0
			if #x1<#x2 THEN CPUstat=0 ELSE CPUstat=1	':IF P1Closer<32 THEN P1Closer=P1Closer+1		
		END IF
	END IF		
	if CPUstat=0 THEN p1Right=1:p1Left=0 ELSE p1Right=0:p1Left=1
	
	'dissappear, except when red
	IF Counter=0 AND e1>26 THEN 			
		#CPU_Spr_Move= CPU_SHIP0 + counter3
		#CPU_Spr_Turn= CPU_TURN0 + CS_BLUE	
		counter3=counter3 XOR 1
	END IF
	IF ABS(#x1-#x2)<5 THEN 
		IF P2Damage=PLaserDamage THEN P1Shield=1 ELSE P1shoot=0	'Shield if P2 shot laser	
	END IF
	RETURN	
	
'"Negabyte" shields randomly, always close
CPU7:
	P1shoot=1: P1ShootHeld=0:P1Shield=0	
	if CPUstat=0 THEN p1Right=1:p1Left=0 ELSE p1Right=0:p1Left=1
	if #x1=CMINX then CPUstat=0 ELSE if #x1=CMAXX THEN CPUstat=1
	'turn towards player each 10 ticks
	if counter2=10 THEN
		counter2=0
		if #x1<#x2 THEN CPUstat=0 ELSE CPUstat=1
	END IF
	
	'if it's about to be hit, randomly turn on shield
	IF #by2<20 THEN
		IF ABS(#bx2-#x1) < 4 THEN	
			IF Counter1 THEN 'Only allow 20 shields
				IF Counter3<20 THEN Counter3=Counter3+1:P1Shield=1
			END IF
		END IF
	END IF
	
	RETURN

'"HK 46.5": Harder, dodges shots
CPU8:
	P1shoot=1
		
	Counter3=ABS(#x1-#x2)<6 

	'check
	if counter2=13 THEN
		counter2=0
		IF Counter3 THEN 
			IF #x1<#x2 THEN CPUstat=1 ELSE CPUstat=0			
		END IF
		IF #bx2 then if counter1 THEN IF #x1<#x2 THEN CPUstat=1 ELSE CPUstat=0
	END IF	
	if Counter3 THEN P1shoot=0
	if #x1<=CMINX then CPUstat=0 ELSE if #x1>=CMAXX THEN CPUstat=1
	
	if CPUstat=0 THEN p1Right=1:p1Left=0 ELSE p1Right=0:p1Left=1
	RETURN

'Hal 2K1: Lasers, shoots at corners
CPU9: 	
	P1shoot=1: P1ShootHeld=P1ShootHeld+4	
	if CPUstat=0 THEN p1Right=1:p1Left=0 ELSE p1Right=0:p1Left=1
	if #x1<=CMINX then 
		CPUstat=0:P1shoot=0 	'shoot in corner always
	ELSEIF #x1>=CMAXX THEN 
		CPUstat=1:P1shoot=0 
	END IF
	'random turn
	if counter2=10 THEN
		counter2=0
		if #x1<#x2 THEN CPUstat=0 ELSE CPUstat=1
		if ABS(#x1-#x2)<6 THEN P1shoot=0 ELSE IF #bx2 then if #x1<#x2 THEN CPUstat=1 ELSE CPUstat=0
	END IF	
	RETURN

'CP1610. Shadow
CPU10:		
	P1shoot=1: P1ShootHeld=0:ShootPlayer1=0:ShootPlayer2=1	
	#DrawColor=(MAXX + 8 - #x1)
	SPRITE 6, #DrawColor + VISIBLE, (10 + P1Closer + FLIPY) + #P1flipX, #P1sprite
	
	'shoot myself...
	IF #bx1=0 THEN
		counter3=counter3 XOR 1
		IF counter3 THEN #bx1=#x1-1 ELSE #bx1=#DrawColor
		
		#by1=P1Closer:#p1bZoom=ZOOMY2+FLIPY:p1bSpeed=PBulletSpeed:P1Damage=PBulletDamage+2 
		#Slabel(0)=VARPTR SP1_Shoot(0):Svolume(0)=15
	END IF
		
	if CPUstat=0 THEN p1Right=1:p1Left=0 ELSE p1Right=0:p1Left=1
	IF counter=0 then CPUstat=CPUstat XOR 1 
	if #x1<=MINX then CPUstat=0 ELSE if #x1>=MAXX THEN CPUstat=1
	
	RETURN	
END	
'=======================================
	
Player2Name: PROCEDURE 
	PRINT COLOR FG_BLUE	
	IF P1Closer=0 THEN 
		PRINT AT 3,"\206\206"
	ELSE	
		PRINT AT 21, "\134\135"	
		PRINT AT 1,"\189\188  "
	END IF	
	IF Players=2 THEN 
		PRINT "Player 2"
		RETURN
	END IF	
	
	counter2=3	
	IF CPUplayer<2 THEN 
		PRINT COLOR FG_WHITE, "Colossus":DEFINE 25,1,BadGuy2
		GOSUB CPU_Follow:GOSUB CPU_Cloak
		
	ELSEIF CPUplayer=2 THEN 
		PRINT COLOR FG_YELLOW,"Jochua":DEFINE 25,1,BadGuy1
		GOSUB CPU_Follow:GOSUB CPU_Moves
		
	ELSEIF CPUplayer=3 THEN 
		PRINT COLOR FG_TAN,   "Master":DEFINE 25,1,BadGuy3
		GOSUB CPU_Lsr:GOSUB CPU_Cloak
		
	ELSEIF CPUplayer=4 THEN 
		PRINT COLOR FG_WHITE, "NetSky":DEFINE 25,1,BadGuy4
		GOSUB CPU_LShield ':GOSUB 
		
	ELSEIF CPUplayer=5 THEN 
		PRINT COLOR FG_YELLOW,"BoroTron":DEFINE 25,1,BadGuy5
		GOSUB CPU_PShield:GOSUB CPU_LShield
		
	ELSEIF CPUplayer=6 THEN 
		PRINT COLOR FG_TAN,   "V.i.k.y":DEFINE 25,1,BadGuy6
		GOSUB CPU_Cloak:GOSUB CPU_LShield
		
	ELSEIF CPUplayer=7 THEN 
		PRINT COLOR FG_YELLOW,"Negabyte":DEFINE 25,1,BadGuy7
		GOSUB CPU_NShield:GOSUB CPU_Follow
		
	ELSEIF CPUplayer=8 THEN 
		PRINT COLOR FG_WHITE, "HK 46.5":DEFINE 25,1,BadGuy8
		GOSUB CPU_Prox:GOSUB CPU_AntiAuto
		
	ELSEIF CPUplayer=9 THEN 
		PRINT COLOR FG_YELLOW,"Hal 2K1":DEFINE 25,1,BadGuy9
		GOSUB CPU_Lsr:GOSUB CPU_AntiAuto
		
	ELSEIF CPUplayer=10 THEN 
		PRINT COLOR FG_RED,  "CP1610":DEFINE 25,1,BadGuy10
		GOSUB CPU_Mirror
		
	END IF
		
	counter2=0
	counter3=1
	'----- Create shielded and slanted enemy ships: SPRITE 25 to 26 and 27-------
	WAIT:Call CREATESHIPS(25)
	RETURN
END
CPU_Preprint: PROCEDURE
	IF counter2<20 THEN IF Difficulty THEN PRINT "\272"			'Add an X on 2nd CPU/Hard difficulty
	counter2=counter2+20:PRINT AT counter2 COLOR CS_BROWN,"\262"	'Bullet list
	PRINT COLOR CS_TAN
RETURN
END

CPU_Follow: PROCEDURE
	GOSUB CPU_Preprint:PRINT "Follows":RETURN
END
CPU_Cloak: PROCEDURE
	GOSUB CPU_Preprint:PRINT "Cloaking":RETURN
END
CPU_Lsr: PROCEDURE
	GOSUB CPU_Preprint:PRINT "Laser Fire":RETURN
END
CPU_Moves: PROCEDURE
	GOSUB CPU_Preprint:PRINT "Moves L/R":RETURN
END
CPU_LShield: PROCEDURE
	GOSUB CPU_Preprint:PRINT "Shield Lsr":RETURN
END
CPU_NShield: PROCEDURE
	GOSUB CPU_Preprint:PRINT "ShieldNear":RETURN
END
CPU_PShield: PROCEDURE
	GOSUB CPU_Preprint:PRINT "Shield Pwr":RETURN
END
CPU_Prox: PROCEDURE
	GOSUB CPU_Preprint:PRINT "Proximity":RETURN
END
CPU_AntiAuto: PROCEDURE
	GOSUB CPU_Preprint:PRINT "NoAutoFire":RETURN	
END
CPU_Mirror: PROCEDURE
	GOSUB CPU_Preprint:PRINT "Mirroring":RETURN
	GOSUB CPU_Preprint:PRINT " not 100%":RETURN
END
	'------------------------"xxxxxxxxxx"


'============================================== PLAYFIELD =======================================
DrawPlayField: PROCEDURE
	CLS	

 '=================> DEBUG <==============================
	'Debug: 5-15:Skip level, 16-25:Infinite (test)
	IF DebugX>4 THEN 
		If DebugX<15 THEN CPUplayer=DebugX-4:DebugX=0 ELSE CPUplayer=DebugX-14		
		Round=CPUplayer
	END IF
	
	'Vertical bar
	y=14
	FOR x=0 TO 11
		PRINT AT y COLOR 	GUICOLOR, "\256": y=y+20
	NEXT x

	if scoreP1>99 then scoreP1=99
	if scoreP2>99 then scoreP2=99
	if Round>99 then Round=1
		
	PRINT AT P1Score - 1 COLOR FG_WHITE,"\271"	'E
	PRINT COLOR CS_BLUE,<3>e1	
			
	x=P1Score3 + 38:GOSUB DrawBar1
	
	PRINT AT P2Score - 1 COLOR FG_WHITE,"\271" 'E
	PRINT COLOR CS_DARKGREEN,<3>e2
	
	x=P2Score3 - 42: GOSUB DrawBar1
	
	'---stage
	PRINT AT STAGETEXT COLOR CS_ORANGE,"\273\274\275"
	IF Players=1 OR Players=2 THEN 
		PRINT COLOR CS_TAN,<.2>Round 'Stage 1
	ELSE
		PRINT COLOR CS_TAN,<.2>HiStage 'Stage high score
	END IF
	
	IF Players=1 THEN				
		PRINT AT ROUNDTEXT COLOR CS_LIGHTBLUE,"\276\277\278"
		PRINT COLOR CS_WHITE,<.2>CPURound 'Round
		
		'scoreP1
		PRINT AT P1Score3
		IF CPURound<3 AND scoreP1>=ScoreP2 THEN PRINT COLOR CS_LIGHTBLUE,"\281" ELSE PRINT COLOR CS_RED, "\272" 'X
		PRINT COLOR CS_LIGHTBLUE, "\281"
		
		'scoreP2
		PRINT AT P2Score3
		IF CPURound<3 AND scoreP2>=ScoreP1 THEN PRINT COLOR CS_YELLOWGREEN,"\259" ELSE PRINT COLOR CS_RED, "\272" 'X
		PRINT COLOR CS_YELLOWGREEN, "\259"
		x=0	
	ELSE				
		PRINT AT P1Score3 COLOR CS_LIGHTBLUE, "\281":PRINT COLOR CS_BLUE,<2>scoreP1		
		PRINT AT P2Score3 COLOR CS_YELLOWGREEN, "\259":PRINT COLOR CS_DARKGREEN, <2>scoreP2		
		x=20
	END IF
	
	IF Players=3 THEN x=0 ELSE x=P1Closer
	SPRITE 0, #x1 + VISIBLE, (10 + x + FLIPY) + #P1flipX, #P1sprite	'1	'P1 (top)	
	SPRITE 2, #x2 + VISIBLE, 98 + #P2flipX, #P2sprite			'4	'P2 (bottom)
	SPRITE 4, #x3 + VISIBLE, EQUXXY, SPR_EQUXX + BEHIND		
		
	GOSUB Score_Update
	RETURN
END

Score_Update: PROCEDURE
	IF Players<>2 THEN 		
		PRINT AT SCORE_AT+40 COLOR CS_TAN,<5>#Score
	END IF
	IF #Score>=#HiScore THEN #HiScore=#Score:HiStage=Round
	PRINT AT SCORE_AT-18 COLOR CS_GREEN,"\284"
	PRINT AT SCORE_AT COLOR CS_DARKGREEN,<5>#HiScore
	
	RETURN
END

DrawStarField: PROCEDURE
	x=20
	DO
		GOSUB RandomStarColor:PRINT "\266"	'starfield1
		GOSUB RandomStarColor:PRINT "\269"	'starfield2
		GOSUB RandomStarColor:PRINT "\270"	'starfield3
		GOSUB RandomStarColor:PRINT "\267"	'starfield3
		x=x+20
	LOOP UNTIL x>200
	RETURN
END

RandomStarColor: PROCEDURE
	PRINT AT RANDOM(14) + x
	IF RANDOM(2)=0 THEN 
		PRINT COLOR CS_BLUE
	ELSE
		PRINT COLOR CS_PURPLE
	END IF
	RETURN
END

'=============================== RESET =================================

ResetPlayers: PROCEDURE
	resetsprite(1):resetsprite(3):resetsprite(5):resetsprite(6):resetsprite(7)	

'---Player1---	
	IF Players=2 OR CPUplayer=0 THEN
		#CPU_Spr_Move=SPR_SHIP1
		#CPU_Spr_Turn=SPR_TURN1
		#CPU_Spr_Held=SPR_SHIP1H			
	ELSE
		x=CPUplayer: if x>8 then x=8
		#Sfreq = x + $FFF
		#CPU_Spr_Move=CPU_SHIP0 + #Sfreq
		#CPU_Spr_Turn=CPU_TURN0 + #Sfreq
		#CPU_Spr_Held=CPU_SHIP0H + #Sfreq
	END IF
	#P1sprite = #CPU_Spr_Move

	P1ShieldON=0
	P1ShieldX=0	
	P1Held = 0						'P1 Held
	P1Dying = 0 
	P1bDeflect=PDeflect+1
	'P1Closer=0
	P1speed = 2:#dx1=0:#dx1=P1SPEED:#dx1H=#dx1/2	'movement
	P1bSpeed = 3
	
	IF Difficulty OR Players=2 THEN	'Hard	
		P1BulletSpeed=5
		P1LaserSpeed=8
		P1Damage = 2					'Bullet damage, laser x 2
	ELSE					'Easy
		P1Damage = 2					'Bullet damage, laser x 2
		P1BulletSpeed=4
		P1LaserSpeed=	5	
	END IF

	#P1bZoom = FLIPY+ZOOMY2			'Bullet size
	P1Shoot = 0						'button press
	P1ShootHeld = 0					'button held (supershot)
	#x1=STARTP1						'x
	#t1=0						'turning, will become - or + number when changing direction
	#bx1=0						'bullet x
	#by1=0						'bullet y
	
	#P1flipX = 0					'Player 1 spite flip
	#P1flipY = FLIPY				'Facing down
	
'---Player2---
	#PL2_Spr_Move= SPR_SHIP2
	#PL2_Spr_Turn= SPR_TURN2
	#PL2_Spr_Held= SPR_SHIP2H		
	#P2sprite = SPR_SHIP2
	
	P2speed = 2
	P2bSpeed = 3
	P2Damage = 2
	P2Held	= 0						'P2Heldf
	P2Dying = 0 
	#P2bZoom = FLIPXZOOMY2  		'bullet size + adjust
	P2ShootHeld = 0					'button held (supershot)
	#x2=STARTP2:#x2=MAXX-#x2		'x
	P2bDeflect=PDeflect+1
	P2ShieldON=0
	P2ShieldX=0
		
	#dx2=0:#dx2=P2SPEED		'movex
	#dx2H=#dx2/2				'half movex
	#t2=0						'turning, will become - or + number when changing direction
	#bx2=0					'bullet x
	#by2=0					'bullet y	
	#P2flipX = 0				'Player 2 spite flip
	#P2flipY = 0
	
'---Player3 - Equxx---
	P3BSPEED = 1 '+ (Round AND 1)	'1 or 2

	#dx3=(Round / 4)
	if #dx3=0 THEN #dx3=1
	if #dx3>3 THEN #dx3=3	'dx3old=120+#x3/8 ELSE x3old=255	'Speed.	
	#bx3=0
	#by3=127
	#UFOFlip=FLIPX
	UFOFlipC=5	'Flippy counter
		
'Handicap
	'#TURNL = (-Round)-4: IF #TURNL <-8 then #TURNL=-8
	'#TURNR = Round+4: IF #TURNR >8 then #TURNR=8
	#TURNL = -6
	#TURNR = 6
	
'--- CPU
	CPUstat=0	
		
'---Explosion---		
	#boomX1=0:#boomX2=0:boomC1=0:boomC2=0
	boomSprite1=0:boomSprite2=0
	
	RETURN
END

Player1CPUlevel: PROCEDURE		'----increase CPU Player level
	CPUplayer=CPUplayer+1
	IF CPUplayer>10 THEN 
		CPUplayer=1
		IF Difficulty THEN P1Closer=P1Closer+16 ELSE Difficulty=1
		IF P1Closer>32 then P1Closer=32
	END IF
	RETURN
END

'================================================ ATTRACT =============================================
CONST ATTRACT_1 = 1
CONST ATTRACT_2 = 5
CONST ATTRACT_3 = 120
CONST ATTRACT_4 = 121
CONST ATTRACT_5 = 150
CONST ATTRACT_5A = 200
CONST ATTRACT_6 = 210
CONST ATTRACT_7 = 300
CONST ATTRACT_8 = 400

AttractMode: PROCEDURE
	#DrawColor=#DrawColor+1
	'Make CPU less deadly
		Counter=1
		Counter2=Counter
		
		IF #DrawColor=ATTRACT_1 THEN 
			PRINT AT 81 COLOR SPR_RED," Game  Over "
			PRINT AT 160 COLOR CS_DARKGREEN,"Upper = Fire  "
			PRINT AT 180 COLOR CS_GREEN,"Lower = Shield"
			P2shield=0
			P2shoot=0					
			P1BulletSpeed=4
			
		ELSEIF #DrawColor=ATTRACT_2 THEN
			PRINT AT 220 COLOR CS_YELLOW,"\197 Upper"
			PRINT AT 47 COLOR CS_WHITE,"1 "
			PRINT COLOR SPR_DARKGREEN, "or "
			PRINT COLOR CS_YELLOW, "2 "

		ELSEIF #DrawColor=ATTRACT_4 THEN
			PRINT AT 81 COLOR CS_BLUE,"Insert  coin"
			PRINT AT 160 COLOR CS_TAN,"Hold "
			PRINT COLOR CS_WHITE, "Upper "
			PRINT COLOR CS_TAN, "for"
			PRINT AT 180,"powerful Laser"
			PRINT AT 220 COLOR CS_TAN,"\197 Hold!"
			P2ShootHeld=PLaserDelay+1
			P2shoot=1
			
		ELSEIF #DrawColor=ATTRACT_5 THEN				
			P2shoot=0
		
		ELSEIF #DrawColor=ATTRACT_5A THEN
			PRINT AT 81 COLOR CS_RED,"Space Versus"
			
		ELSEIF #DrawColor=ATTRACT_6 THEN			
			PRINT AT 160 COLOR CS_GREEN,"Press "
			PRINT COLOR CS_YELLOW,"Lower "
			PRINT COLOR CS_GREEN,"to"
			PRINT AT 180,"raise shields "
			PRINT AT 220 COLOR CS_GREEN,"\199 Lower"
			PRINT AT 47 COLOR CS_TAN,"Players"
			P2shield=1
			P2shoot=0
			
		ELSEIF #DrawColor=ATTRACT_7 THEN
			P2shield=1
			P2shoot=0
			PRINT AT 81 COLOR  CS_RED, "AutoFire:"
			PRINT COLOR CS_TAN,"1-3"
			PRINT AT 160 COLOR CS_YELLOW,"Press 8"
			PRINT COLOR CS_GREEN,":Taunt "
			PRINT AT 180,"and replenish!"	
			PRINT AT 220 COLOR CS_DARKGREEN,"8:Taunt"			
			P2Shield=2
			
		ELSEIF #DrawColor>ATTRACT_8 THEN 
			'---- REBOOT when attract mode is over.
			#DrawColor=1
			Attract=Attract-1:IF Attract=0 THEN GOTO Reboot		

		ELSE
			IF #DrawColor<ATTRACT_3 THEN P2shoot=Counter1
		END IF
	RETURN
END

