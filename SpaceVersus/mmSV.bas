' ====================================================
'                   Space Versus
' 			(c) 2015 Marco A. Marrero
' =====================================================
	SOUND 5,0,0			'ECS off. cont3/cont4
	DEFINE 0,16,Graphics0	'Load permanent cards
	BORDER 2
	WAIT
	
	INCLUDE "constants.bas"	
	INCLUDE "mmSV_const.bas"	

	'2nd set
	DEFINE 16,10,Graphics1
	BORDER 1
	WAIT:Call CREATESHIPS(25)	'get sprite 25, generate 26 and 27
	DEFINE 28,1,HiScore		'get more cards ("hi"score)
		
	'Intellivision memory map: $5000-$6fff, $d000-$dfff and $f000-$ffff 
	
	'---sound----	
	DIM #Slabel(2)		'Sound data address (0,1,2)
	DIM Svolume(2)		'Sound volume (1-15)
	P1AutoFire=0:P2AutoFire=0	
	Player1Energy = 100
	Player2Energy = 100
	UFO=2			'Auto
	Difficulty =0	'easy
	#Score = 0		'P1 score
	#HiScore = 1000	'Power-on High Score
	HiStage = 5		'Power-on Last stage
	ScoreUpdate=0		'just a flag, only update score when needed
	
reboot:	
	DebugX=0:InkeyOff=0
	scorep1=0:scorep2 = 0	
	P1Closer=0		'default, I'll set it up later when game begins
	#x3=MAXX/2		'UFO	initial position
	
	'---Play--
	Players = 0:Round = 1:CPUround = 1:CPUplayer = 1
	
	'--- Energy
	e1=Player1Energy:e2=Player2Energy
	Continue=3		'3 continues per play
		
	GOSUB ResetPlayers
	GOSUB DrawPlayField	
	PRINT AT 220 COLOR CS_Blue, "v1.60229"
	PRINT AT 180 COLOR CS_DARKGREEN, "Copyright 2016"
	SPRITE 1, 80 + VISIBLE, 80 + FLIPX + ZOOMY2 ,  SPR02 + SPR_DARKGREEN	'(C)
	PRINT AT 201 COLOR CS_GREEN, "Marco Marrero"
	
	y=20:counter=1:counter1=1:x=0	
	p2Right=0:p2Left=0
	
	'--- wait until attract mode ends--
	#Sfreq=800		'#Sfreq=9 'to quickly test

	PLAY FULL:PLAY TitleMusic	
TitleScreen:
	WAIT	
	counter1=counter1-1	
	if counter1=0 then 
		counter1=10
		PRINT AT y-20 COLOR counter,"Space   Versus"
		IF y<120 THEN 
			y=y+20 
		ELSE 
			IF x<100 THEN 				
				PRINT AT x,"              " 'erase
				x=x+20				
			ELSE
				IF x<140 THEN
					PRINT AT 4 COLOR CS_DARKGREEN,"Press"
					PRINT AT 20 COLOR CS_YELLOW,"1"
					PRINT COLOR CS_GREEN," or "
					PRINT COLOR CS_YELLOW,"2 "
					PRINT COLOR CS_GREEN,	"Players"
					PRINT AT 40 COLOR CS_GREEN,"Enter"
					PRINT COLOR CS_DARKGREEN,"=Options"
					PRINT COLOR CS_BLUE
					FOR x=0 to 6						
						PRINT AT 80+x*2,"\280\280"
						PRINT AT 140+x*2,"\280\280"						
					NEXT x
					x=150
				END IF
			END IF
		END IF		
		counter=counter+1
		if counter=8 then counter=1
		
		PRINT AT y COLOR counter,"Space   Versus"
	end if
	
	Inkey=CONT.KEY	
	IF InkeyOff=1 THEN
		IF Inkey=2 THEN 
			Players=2:CPURound=0:Goto StartAgain	
		ELSEIF Inkey=1 THEN
			Players=1:#Score=0:Goto StartAgain			
		'ELSEIF Inkey=5 THEN 'Denied!!
		'	DebugX=DebugX+1	
		'	IF DebugX>14 THEN DebugX=5
		'	IF DebugX>4 THEN PRINT AT 10,"\264",<>DebugX-5," "
		ELSEIF Inkey=11 THEN 
			GOSUB OptionScreen:GOTO Reboot
		END IF		
	END IF
	IF Inkey=12 THEN InkeyOff=1 ELSE InkeyOff=0
	
	'Activate attract mode, #SFreq. 
	#Sfreq=#Sfreq-1:IF #Sfreq=0 then Players=3:CPUround=1:Goto StartAgain	
	GOTO TitleScreen
	
StartAgain:				
	e1=Player1Energy:IF Players<>2 AND e1<>100 THEN e1=100			'CPU can't have less energy!
	e2=Player2Energy
	IF Difficulty=2 AND Players=1 AND P1Closer=0 THEN P1Closer=16		'Insane difficulty
	
	GOSUB ResetMusic	
	GOSUB ResetPlayers
	GOSUB DrawPlayField
	
	INCLUDE "mmSV_Debug.bas"	'<---- debug override
		
'=====================================VS Screen/Countdown=======================================
	IF Players=3 THEN Attract=5:GOTO StartGameNow	'Attract=5:Duration (cycles)
	Attract=0
	PLAY FULL
	PLAY RoundStart
	
	GOSUB Player2Name			'CPU name
	PRINT AT 220 COLOR FG_GREEN,"Player 1\206\206\206"

	RESTORE Draw5		
	DrawCard=95		'194	209	212 95 116 
	
	IF Players=2 THEN Counter=0:Counter1=0 ELSE Counter=1:Counter1=20	'+1=lower billboard, +3/+4=y position number
	
'---Draw Countdown------
	for x=5 to 0 STEP -1			
		DrawX=4
		PRINT AT 180+DrawX+Counter1 COLOR x AND 1, "Ready!"
		
		#DrawColor=CS_DARKGREEN:y=2+Counter:GOSUB DrawBillboard1:y=8+Counter:GOSUB DrawBillboard1
		y=5+Counter:GOSUB DrawBillboard1
		#DrawColor=CS_GREEN:y=3+Counter:GOSUB DrawBillboard1:y=7+Counter:GOSUB DrawBillboard1
		#DrawColor=CS_YELLOWGREEN:	y=4+Counter:GOSUB DrawBillboard1:y=6+Counter:GOSUB DrawBillboard1		
		#DrawColor=FG_WHITE
		'if x AND 1 then #DrawColor=FG_BLACK ELSE #DrawColor=FG_RED
		DrawX=DrawX+1:DrawY=3+Counter:DrawCmd=x:GOSUB DrawCmdGo	'DrawY is 3 or 4
		
		FOR y=0 to 25
			WAIT	':GOSUB CheckAutoFire
		NEXT y
	next x
	
'----Title1------
StartGameNow:
	PLAY NONE:SOUND 0, 1, 0:SOUND 1, 1, 0:SOUND 2, 1, 0:SOUND 4, 1, &00011100	
	GOSUB ResetPlayers			
	GOSUB DrawPlayField
	
'===star field====
	IF Players<>3 THEN
		GOSUB DrawStarField
	ELSE	 'Attract mode screen	
		'GOSUB Player2Name			'Show enemy data
		PRINT AT STAGETEXT+20 COLOR CS_TAN,"Demo "
				
		PRINT AT 41 COLOR CS_BLUE,"Start:"		
		PRINT AT 120 COLOR CS_BLUE,"How to play:"	
		
		#DrawColor=CS_LIGHTBLUE
		x=20:GOSUB DrawBar2
		
		#DrawColor=CS_GREEN
		x=60:GOSUB DrawBar2
		#DrawColor=CS_YELLOWGREEN
		x=100:GOSUB DrawBar2
		
		#DrawColor=CS_PURPLE
		x=140:GOSUB DrawBar2
		#DrawColor=CS_PINK
		x=200:GOSUB DrawBar2		
		#x2=#x2-8		
	END IF
	counter=0
	counter1=1
	#DrawColor=0	'I'll use this for attract mode
'====Init sound=======	
	PLAY NONE:SOUND 0, 1, 0:SOUND 1, 1, 0:SOUND 2, 1, 0:SOUND 4, 1, &00011100	
	#Sfreq = 0			'Freq	
	FOR x=0 to 1:#Slabel(x)=0:Svolume(x)=0:next X		
	
	'SMusic = 1						'0=sound/1=music
	#Slabel(2)=VARPTR SP_Backgr(0)		'background music
	Svolume(2)=BgSoundVol
	SMusicWait = (e1+e2)/2			'music speed
	Svol2=BgSoundVolDelay
	IF Players=1 THEN ScoreUpdate=1

'***************************************************MAIN****************************************************

MainLoop:		
	counter = counter + 1		'just an fps counter	
	counter1 = counter1 XOR 1	'odd/even
	
'====================================Player 1==
'===NOTE=== Player1 = Top(CPU), Player2 = Bottom(player). On-screen it's the opposite.
	#P1sprite = #CPU_Spr_Move
	#P1flipX = 0
		
	IF Players<>2 THEN GOSUB Player1CPU:GOTO Player1Ok	'---CPU instead of Player 2?
	
	'---Player2 in VS mode '--keypad---	
	IF Cont1KeyClear=0 THEN Cont1KeyClear=(CONT2.Key=12)
	IF CONT2 AND Cont1KeyClear THEN
		IF CONT2.KEY<12 THEN
			IF CONT2.KEY=1 THEN 
				P1AutoFire=1 
			ELSEIF CONT2.KEY=2 THEN 
				P1AutoFire=0 
			ELSEIF CONT2.KEY=3 THEN 
				P1AutoFire=2
			ELSEIF CONT2.KEY=8 THEN	'8=taunt,replenish
				P1Shield=2
			END IF
			Cont1KeyClear=0
		END IF
	END IF 'AutoFire: 1=full auto, 2=off, 3=selective
	IF P1AutoFire=1 THEN 
		P1shoot= Counter1				'toggles 1 and 0
	ELSEIF P1AutoFire=2 THEN
		IF CONT2.B0 THEN P1shoot= Counter1	'toggles button when pressed
	ELSE
		P1shoot = CONT2.B0			'just checks button
	END IF	
	IF (CONT2.B1 + CONT2.B2) <>0 THEN P1shield=1
	
	IF GamePad1 THEN	'--DISK--- My P1 and P2 are inverted, P1=CPU/2nd, P2=Player1
		P1Left=CONT2.DOWN:P1Right=CONT2.UP
	ELSE
		P1Left=CONT2.LEFT:P1Right=CONT2.RIGHT
	END IF
	
Player1Ok:	
	'if player held/frozen, don't move!
	if P1Held THEN
		P1Held=P1Held-1
		#P1sprite= #CPU_Spr_Held
		GOTO POneBulletEND
	end if
	
	IF p1Left THEN 
		IF #t1<>#TURNL THEN #t1=#t1-1:#P1sprite=#CPU_Spr_Turn:#P1flipX=FLIPX:#x1=#x1-#dx1H ELSE #x1=#x1-#dx1
		IF #x1<MINX THEN #x1=MINX
		GOTO POneBullet
	END IF
	
	IF p1Right THEN 
		IF #t1<>#TURNR THEN #t1=#t1+1:#P1sprite=#CPU_Spr_Turn:#P1flipX=0:#x1=#x1+#dx1H ELSE #x1=#x1+#dx1
		if #x1>MAXX THEN #x1=MAXX	
		GOTO POneBullet
	END IF
	#t1=0			'if stopped, turn will be less paused

POneBullet:
	'If not flying, fly bullet =ELSE= it's held down		
	IF P1shoot THEN	
		IF #bx1 OR P1ShootHeld THEN P1ShootHeld=P1ShootHeld+1:GOTO POneBulletEND		
		#bx1=#x1-1:#by1=8+P1Closer:#p1bZoom=ZOOMY2+FLIPY:p1bSpeed=P1BulletSpeed:P1Damage=PBulletDamage 
		#Slabel(0)=VARPTR SP1_Shoot(0):Svolume(0)=15
	ELSE 'Button released, check supershot
		IF P1ShootHeld<PLaserDelay THEN P1ShootHeld=0:GOTO POneBulletEND
		P1ShootHeld=0:#bx1=#x1:#by1=0:#p1bZoom=ZOOMY8+FLIPY:p1bSpeed=P1LaserSpeed:P1Damage=PLaserDamage 'Laser!		
		#Slabel(0)=VARPTR SP1_Laser(0):Svolume(0)=15
	END IF	
POneBulletEND:
	IF #bx1 THEN #by1=#by1+p1bSpeed:IF #by1>=p1BulletEnd THEN #bx1=0:p1bSprite=0	'bullet1 only flies when bx2!=0

'222222222222222222222222======= Player 2======2222222222222222222222222222222222222
'Next time I'll use a subroutine or an array. Almost same code as above

'---P2-Ship. 
	#P2sprite = #PL2_Spr_Move
	#P2flipX = 0
	'--keypad---
	IF Cont2KeyClear=0 THEN Cont2KeyClear=(CONT1.Key=12)
	if Players<>3 THEN
		IF CONT1 AND Cont2KeyClear THEN
			IF CONT1.KEY<12 THEN
				IF CONT1.KEY=1 THEN 
					P2AutoFire=1 
				ELSEIF CONT1.KEY=2 THEN 
					P2AutoFire=0 
				ELSEIF CONT1.KEY=3 THEN 
					P2AutoFire=2 
				ELSEIF CONT1.KEY=9 AND NukeCPU THEN 
					GOTO PlayerOneLose	
				ELSEIF CONT1.KEY=8 THEN		'taunt,replenish
					P2Shield=2
				END IF
				Cont2KeyClear=0
			END IF
		END IF		
		
		IF P2AutoFire=1 THEN 
			P2shoot= Counter1					'toggles 1 and 0
		ELSEIF P2AutoFire=2 THEN
			IF CONT1.B0 THEN P2shoot=Counter1	'toggles button when pressed
		ELSE
			P2shoot = CONT1.B0				'just checks button
		END IF		
		IF (CONT1.B1 + CONT1.B2)<>0 then P2shield=1

		IF GamePad2 THEN	'--DISK--- P2 is inverted, P2=Player1, Cont1
			P2Left=CONT1.DOWN:P2Right=CONT1.UP
		ELSE
			P2Left=CONT1.LEFT:P2Right=CONT1.RIGHT
		END IF
					
	Else		
		GOSUB AttractMode		
		Inkey=CONT.KEY	'Attract mode, 1=1player, 2=2player
		IF Inkey=12 THEN InkeyOff=1 
		IF Inkey=10 AND InkeyOff=1 THEN Goto Reboot	
		IF Inkey=2 AND InkeyOff=1 THEN Players=2:Goto StartAgain	
		IF Inkey=1 AND InkeyOff=1 THEN Players=1:Goto StartAgain		
	End IF
		
	if P2Held THEN
		P2Held=P2Held-1
		#P2sprite= #PL2_Spr_Held
		GOTO PTwoBEnd
	end if
	
	IF p2Left THEN 
		IF #t2<>#TURNL THEN #t2=#t2-1:#P2sprite=#PL2_Spr_Turn:#P2flipX=0:#x2=#x2-#dx2H ELSE #x2=#x2-#dx2
		IF #x2<MINX THEN #x2=MINX
		GOTO PTwoBullet
	END IF
	
	IF p2Right THEN 
		IF #t2<>#TURNR THEN #t2=#t2+1:#P2sprite=#PL2_Spr_Turn:#P2flipX=FLIPX:#x2=#x2+#dx2H ELSE #x2=#x2+#dx2
		IF #x2>MAXX THEN #x2=MAXX
		GOTO PTwoBullet
	END IF	
	#t2=0			'if it's still, turn will be less paused
		
PTwoBullet:
	'if not flying, fly bullet! ==ELSE== it's held down
	IF P2shoot THEN
		IF #bx2 OR P2ShootHeld THEN P2ShootHeld=P2ShootHeld+1:GOTO PTwoBEnd	'IF P2AutoFire<>1 THEN 
		#bx2=#x2:#by2=98:#p2bZoom=FLIPXZOOMY2:p2bSpeed=PBulletSpeed:P2Damage=PBulletDamage
		#Slabel(1)=VARPTR SP2_Shoot(0):Svolume(1)=15
	ELSE	 'Button released, check supershot	
		IF P2ShootHeld<PLaserDelay THEN P2ShootHeld=0: GOTO PTwoBEnd
		P2ShootHeld=0:#bx2=#x2:#by2=82:#p2bZoom=FLIPXZOOMY8:p2bSpeed=PLaserSpeed:P2Damage=PLaserDamage  'Laser!
		#Slabel(1)=VARPTR SP2_Laser(0):Svolume(1)=15
	END IF

PTwoBEnd: 	
	'bullet2 only flies when bx2!=0
	IF #bx2 THEN #by2=#by2-p2bSpeed:IF #by2<=p2BulletEnd THEN #bx2=0:p2bSprite=0
	
'=====UFO===============================UFO=========================================UFO
	#x3=#x3+#dx3:IF #x3<MINX OR #x3>MAXX THEN #dx3=-#dx3:#x3=#x3+#dx3	
	UFOFlipC=UFOFlipC-1: IF UFOFlipC=0 THEN UFOFlipC=5:IF #UFOFlip=0 THEN #UFOFlip=FLIPX ELSE #UFOFlip=0
	IF UFO>0 THEN 'Will UFO shoot?
		IF #by3>106 THEN 
			#bx3=#x3:#by3=54
			IF CPUplayer<>3 THEN		
				IF UFO=2 THEN
					ShootPlayer1=1	'always shoot both
					ShootPlayer2=1		
				ELSE
					ShootPlayer1=1	'shoot winning player
					ShootPlayer2=1				
					IF (e1> e2) THEN 
						IF (e1-e2 > 20) THEN ShootPlayer2=0 
					ELSE 
						IF P1Closer OR (e2-e1 > 20)  THEN ShootPlayer1=0
					END IF
				END IF
			END IF
		END IF
	END IF
	#by3=#by3+P3BSPEED
	
'===== Explosion ==================Explosion==============================Explosion=========
	boomCount=0
	IF #boomX1 THEN
		boomCount=boomCount+1
		boomC1 = boomC1 + 1
		if boomC1>17 THEN 
			#boomX1=0:boomC1=0:boomSprite1=0
		ELSE
			IF counter1 THEN boomY1=boomY1+1:IF (boomy1 AND 1) THEN POKE $31,boomC1 AND 1
		END IF
		boomSprite1 = boomSprite1 + 2:if boomSprite1>29 then boomSprite1=24
	END IF		
	IF #boomX2 THEN
		boomCount=boomCount+1
		boomC2 = boomC2 + 1
		if boomC2>17 THEN 
			#boomX2=0:boomC2=0:boomSprite2=0	
		ELSE
			IF counter1 THEN boomY2=boomY2-1:IF (boomy2 AND 1) THEN POKE $31,boomC2 AND 1
		END IF
		boomSprite2 = boomSprite2 + 2: If boomSprite2>29 then boomSprite2=24
	END IF	
	
'SOUND=================================== SOUND ========================SOUND====
'The original sound player used 8-bit data values, odd values to decrease volume
IF Players=3 THEN GOTO NoSoundInAttract
	IF #Slabel(0) THEN
		#Sfreq=PEEK(#Slabel(0)):#Slabel(0)=#Slabel(0)+2
		IF #Sfreq=0 THEN #Slabel(0)=0:SOUND 0,1,0:GOTO Channel1	'0,0=end
		IF #SLabel(1)=0 THEN SOUND 0, #Sfreq, 12 ELSE IF counter1=0 THEN SOUND 0, #Sfreq, 12
	END IF
	
Channel1:
	IF #Slabel(1) THEN
		#Sfreq=PEEK(#Slabel(1)):#Slabel(1)=#Slabel(1)+2
		IF #Sfreq=0 THEN #Slabel(1)=0:SOUND 0,1,0:GOTO ChannelX
		IF #SLabel(0)=0 THEN SOUND 0, #Sfreq, 12 ELSE IF counter1 THEN SOUND 0, #Sfreq, 12
	END IF

ChannelX:
	IF #SLabel(0)+#SLabel(1)=0 THEN SOUND 0,1,0	
	SMusicWait=SMusicWait-1
	IF SMusicWait=0 THEN	
		if e1<e2 then SMusicWait = e1+10 ELSE SMusicWait = e2+10
		#Sfreq2= PEEK(#Slabel(2)):#Slabel(2)=#Slabel(2)+2
				
		IF SMusicWait>32 THEN 
			Svolume(2)=BgSoundMin 			
			IF #Sfreq2=0 THEN #Slabel(2)=VARPTR SP_Backgr(0)
		ELSE		
			Svolume(2)=BgSoundMin+4			
			IF #Sfreq2=0 THEN #Slabel(2)=VARPTR SP_Backgr2(0)
		END IF				
	END IF
	Svol2=Svol2-1:IF Svol2=0 THEN Svol2=BgSoundVolDelay:IF Svolume(2)<BgSoundVol THEN Svolume(2)=Svolume(2)+1		
	SOUND 1, #Sfreq2, Svolume(2)	

NoSoundInAttract:
'=======SHIELD/TAUNT=======================================================
IF P1ShieldX THEN
	P1ShieldX=P1ShieldX-1:IF P1ShieldX=PlayerShieldOFF THEN P1ShieldON=0:#P1flipY=FLIPY:P1shield=0
	IF P1ShieldON THEN		
		IF Counter1 THEN P1ShieldColor=(P1ShieldColor - 1) AND 7
		IF #Slabel(0)=0 THEN #Slabel(0)=VARPTR ShieldSound(0):Svolume(0)=15
	END IF
ELSE 
	IF P1shield=1 THEN 
		P1ShieldON=P1ShieldON+1
		P1ShieldColor=7:P1ShieldX=PlayerShield:	P1Held=PlayerShieldFreeze
		#Slabel(0)=VARPTR ShieldSound(0):Svolume(0)=15
	ELSEIF P1shield=2 THEN	
		P1ShieldX=PlayerShieldFreeze:P1Held=PlayerShieldFreeze	
		#Slabel(0)=VARPTR TauntSound(0):Svolume(0)=15
		#P1flipY=0
		e1=e1+PTauntEnergy:IF e1>150 then e1=150
		PRINT AT P1Score COLOR CS_BLUE,<3>e1
	END IF
END IF

IF P2ShieldX THEN
	P2ShieldX=P2ShieldX-1:IF P2ShieldX=PlayerShieldOFF THEN P2ShieldON=0:#P2flipY=0:P2shield=0
	IF P2ShieldON THEN
		IF Counter1 THEN P2ShieldColor=(P2ShieldColor - 1) AND 7
		IF #Slabel(1)=0 THEN #Slabel(1)=VARPTR ShieldSound(0):Svolume(1)=15
	END IF
ELSE 
	IF P2shield=1 THEN 
		P2ShieldON=P2ShieldON+1
		P2ShieldColor=7:P2ShieldX=PlayerShield:P2Held=PlayerShieldFreeze
		#Slabel(1)=VARPTR ShieldSound(0):Svolume(1)=15		
	ELSEIF P2shield=2 THEN
		P2ShieldX=PlayerShieldFreeze:P2Held=PlayerShieldFreeze
		#Slabel(1)=VARPTR TauntSound(0):Svolume(1)=15
		#P2flipY=FLIPY
		e2=e2+PTauntEnergy:IF e2>150 then e2=150
		PRINT AT P2Score COLOR CS_GREEN,<3>e2
	END IF
END IF

'==================================== MOVE SPRITES=============================================
	by3a=105-#by3				'equxx
	
'--------- DRAW ------------------ DRAW -------------	
'---Player1/CPU------
	SPRITE 0, #x1 + VISIBLEHIT, (10 + P1Closer) + #P1flipY + #P1flipX, #P1sprite		'1	'P1 (top)	
	
	'Bullet or shield		
	IF p1ShieldON THEN
		SPRITE 1, #x1 + VISIBLEHIT - 4 + ZOOMX2, ZOOMY2 + 8 + P1Closer,  SPR02 + P1ShieldColor	'SPR02=Copyright
	ELSE
		SPRITE 1, #bx1 + VISIBLEHIT, #by1 + #P1bZoom,  SPR_SHOT1	+ p1bSprite		'2	'Goes DOWN
	END IF
		
'---Player2-----------------------------
	SPRITE 2, #x2 + VISIBLEHIT, 98 + #P2flipY + #P2flipX, #P2sprite					'4	'P2 (bottom)
	
	IF p2ShieldON THEN
		SPRITE 3, #x2 + VISIBLEHIT - 4 + ZOOMX2, ZOOMY2 + 96, SPR02 + P2ShieldColor
	ELSE
		SPRITE 3, #bx2 + VISIBLEHIT, #by2 + #P2bZoom, SPR_SHOT2 + p2bSprite	'8	'Goes UP
	END IF
	
	'---EQUXX Saucer and bullet	
	IF ShootPlayer1 THEN SPRITE 6, #bx3 + VISIBLEHIT, by3a + ZOOMY2, SPR_BALL2			'64	'Goes UP
	IF ShootPlayer2 THEN SPRITE 5, #bx3 + VISIBLEHIT, #by3 + FLIPXZOOMY2, SPR_BALL1 		'32	'Goes DOWN

	'---EquXX
	SPRITE 4, #x3 + VISIBLEHIT , EQUXXY+#UFOFlip, SPR_EQUXX

	'---Explosion, if applicable
	IF boomCount=2 THEN 
		if counter1 THEN 
			SPRITE 7, #boomX1, boomY1, SPR_DEAD2 + boomSprite1
		ELSE
			SPRITE 7, #boomX2, boomY2, SPR_DEAD2 + boomSprite2
		END IF	
	ELSE
		IF #boomX1 THEN 
			SPRITE 7, #boomX1, boomY1, SPR_DEAD2 + boomSprite1 
		ELSE 
			SPRITE 7, #boomX2, boomY2, SPR_DEAD2 + boomSprite2
		END IF
	END IF
	
'=======================COLLISION=================================	
WAIT	
	'scroll effect when player is hit
	if boomC1 OR boomC2 THEN POKE $31,counter1	'$30=x, $31=y

	'P1 hit
	p1ColBullet = COL0 AND HIT_SPRITE3
	p1ColBullet2 = COL0 AND HIT_SPRITE6
	
	'P2 hit
	P2ColBullet = COL2 AND HIT_SPRITE1
	P2ColBullet2 = COL2 AND HIT_SPRITE5

	'EQUXX hit by bullet
	P3ColP1 = COL4 AND HIT_SPRITE1
	P3ColP2 = COL4 AND HIT_SPRITE3
	
	P1HitNow = 0
	IF p1ColBullet AND P1bDeflect>PDeflect THEN
		IF P1ShieldON THEN 
			P3ColP2=1
			IF Players=1 THEN #Score=#Score+SCORE_SHIELD:ScoreUpdate=1
			GOTO P1HitSkip	'Deflect if Shielded
		END IF
		
		#by2=p2BulletEnd:resetsprite(3)
		P1HitNow=1:P1HitSound=40
		IF P2Damage=PLaserDamage THEN 
			#boomX1=#x1 - 4 + ZOOMX2VISIBLE 			
			SOUND 3, 6000,&0011
			IF Players=1 THEN #Score=#Score+SCORE_LASER:ScoreUpdate=1
		ELSE 
			#boomX1=#x1 + VISIBLE
			SOUND 3, 3500,&0011
			IF Players=1 THEN #Score=#Score+SCORE_HIT:ScoreUpdate=1
		END IF
	ELSE 
		IF p1ColBullet2 THEN  
			#bx3=0:P1Held=30 '-----Froze!
			SOUND 3, 3000, &1111	
			SOUND 2, 3550, 48
			SOUND 4, 53, &00011100
		END IF
	END IF	
	IF P1HitNow=1 THEN	
		e1 = e1 - P2Damage:if e1>160 then e1=0
		SOUND 2, 100, 48				
		SOUND 4, P1HitSound, &00011100	'0=On, 1=off, iox2 + noisex3 + tonex3
		boomY1=10+P1Closer:boomC1=0
		PRINT AT P1Score COLOR CS_BLUE,<3>e1	
		if p1dying=0 AND e1<26 THEN
			p1dying=p1dying+1
			#CPU_Spr_Move= CPU_SHIP0 + SPR_RED
			#CPU_Spr_Turn= CPU_TURN0 + SPR_RED
			#CPU_Spr_Held= CPU_SHIP0H + SPR_RED
		end if
	END IF	
	
P1HitSkip:
'--p2 hit---
	P2HitNow = 0
	IF P2ColBullet AND P2bDeflect>PDeflect THEN 
		IF P2ShieldON THEN P3ColP1=1:GOTO P2HitSkip  'Deflect if Shielded
		#by1=p1BulletEnd:resetsprite(1)
		P2HitNow=1:P2HitSound=45		
		IF P1Damage=PLaserDamage THEN 
			#boomX2=#x2 - 4 + ZOOMX2VISIBLE 
			SOUND 3, 6000,&0011
		ELSE 
			#boomX2=#x2 + VISIBLE
			SOUND 3, 3500,&0011
		END IF
	ELSE 		
		IF P2ColBullet2 THEN 
			#bx3=0:P2Held=30 '-----Froze!
			SOUND 3, 3000, &1111
			SOUND 2, 3550, 48
			SOUND 4, 63, &00011100	
		END IF
	END IF
	IF P2HitNow=1 THEN	
		e2 = e2 - P1Damage: if e2>160 then e2=0
		SOUND 2, 100, 48		
		SOUND 4, P2HitSound, &00011100	'0=On, 1=off, iox2 + noisex3 + tonex3
		boomY2=100:boomC2=0
		PRINT AT P2Score COLOR CS_GREEN,<3>e2
		if p2dying=0 AND e2<26 THEN
			p2dying=p2dying+1
			#PL2_Spr_Move= PL2_SHIP0 + SPR_RED
			#PL2_Spr_Turn= PL2_TURN0 + SPR_RED
			#PL2_Spr_Held= PL2_SHIP0H + SPR_RED
		end if
	END IF
P2HitSkip:
	
	IF P1HitNow OR P2HitNow THEN
		if e1=0 AND e2=0 then GOTO PlayersFail				
		if e1=0 THEN GOTO PlayerOneLose ELSE if e2=0 THEN GOTO PlayerTwoLose
	END IF
	
'-----P1 Bullet HIT EQUXX---- Deflect --> P1
	IF P1bDeflect<=PDeflect THEN
		P1bDeflect=P1bDeflect-1
		#bx1=#bx1+2
		#by1=#by1-3
		p1bSprite=p1bSprite+1
	ELSEIF P1bDeflect=255 THEN
		P1bDeflect=P1bDeflect-1
		#by1=p1BulletEnd:resetsprite(1)
	ELSE
		IF P3ColP1 Then			
			p1bSprite=SPR_DEBRI1
			p1bSpeed=0
			P1bDeflect=PDeflect
			#Slabel(0)=VARPTR SP_Deflect(0):Svolume(0)=15
		END IF
	END IF
	
	'EQUXX Bullet HIT ----> P2
	IF P2bDeflect<=PDeflect THEN
		P2bDeflect=P2bDeflect-1
		#bx2=#bx2-2
		#by2=#by2+3
		p2bSprite=p2bSprite+1
	ELSEIF P2bDeflect=255 THEN
		P2bDeflect=P2bDeflect-1
		#by2=p2BulletEnd:resetsprite(3)
	ELSE
		IF P3ColP2 Then			
			p2bSprite=SPR_DEBRI2
			p2bSpeed=0
			P2bDeflect=PDeflect
			#Slabel(1)=VARPTR SP_Deflect(0):Svolume(1)=15
			IF Players=1 THEN #Score=#Score+SCORE_UFO:ScoreUpdate=1
		END IF
	END IF
	
	IF ScoreUpdate THEN ScoreUpdate=0:PRINT AT SCORE_AT2 COLOR CS_TAN,<5>#Score
	GOTO MainLoop

'================================================== LOSE/WIN ================================================
PlayerOneLose:	
	e1=0:scorep2=scorep2+1	
	'GOSUB DrawPlayField	
	PRINT AT P1Score2 COLOR CS_RED,">Lose"		
	PRINT AT P1Score4-Players, "\272"
	IF Players=2 THEN PRINT AT P2Score2 COLOR CS_WHITE,">Win!"
	'===Mega explosion====
	#bx1=#x1:#by1=10+FLIPY+P1Closer
	#bx2=0
	IF Players=1 THEN IF Difficulty=0 THEN #Score=#Score+SCORE_KILL+e2 ELSE #Score=#Score+SCORE_KILL2+e2
	GOTO GameOver

PlayerTwoLose:
	e2=0:scorep1=scorep1+1	
	'GOSUB DrawPlayField
	IF Players=2 THEN PRINT AT P2Score2 COLOR CS_RED,">Lose"		
	PRINT AT P2Score4-Players, "\272"
	PRINT AT P1Score2 COLOR CS_WHITE,">Win!"
	
	#bx2=#x2:#by2=99
	#bx1=0	
	GOTO GameOver

PlayersFail:
	scorep1=scorep1+1:scorep2=scorep2+1
	e2=0:e1=0	
	'GOSUB DrawPlayField
	PRINT AT P1Score2 COLOR CS_RED,"Draw!"
	IF Players=2 THEN PRINT AT P2Score2,"Draw!"
	#bx1=#x1:#by1=10+FLIPY+P1Closer
	#bx2=#x2:#by2=99
	IF Players=1 THEN IF Difficulty=0 THEN #Score=#Score+SCORE_KILL ELSE #Score=#Score+SCORE_KILL2
	GOTO GameOver
						
GameOver:
	GOSUB Score_Update
	'1 Player game settings
		IF Players=1 THEN			
			IF CPURound>1 THEN
				IF scorep2>scorep1 THEN					
					CPURound=0:scorep1=0:scorep2=0
					GOSUB Player1CPUlevel					
				END IF
				IF scorep1>scorep2 THEN
					scorep1=0:scorep2=0:Players=0 'Game over man, game over!
				END IF
			END IF			
			CPUround=CPUround+1
		ELSE
			Round=Round+1		'P2 Stage advance
		END IF

		SOUND 0, 1, 0:SOUND 1, 1, 0
		y=30
		
		'Kaboom
		SOUND 2, 100, 48
		SOUND 3, 9500, &0011	'Envelope duration		
		SOUND 4, y,&00011100	'0=On, 1=off, iox2 + noisex3 + tonex3
		counter=0:counter2=0
		boomC1=0
		bx3=0		
		x=1
		#Sfreq=SPR_DEAD+2
		BoomColor=0
		'#x1 available
GameOver2:		
		bx3=bx3+1
		counter=counter+1			':if counter>30 then counter=5		
		counter1=counter1 AND 1
		
		'===========big boom, multiplex sprites if necessary ==========
		IF #bx1 THEN
			boomY2=0		'#by1=#by1+1:
			IF #bx2=0 THEN boomY2=boomY2+1 ELSE if Counter1 THEN boomY2=boomY2+1
			IF boomY2 THEN
				SPRITE 7, #bx1 + VISIBLE+ZOOMX2, #by1+boomC1+ZOOMY2, #Sfreq
				SPRITE 5, #bx1+counter + VISIBLE +ZOOMX2, P1Closer+5+FLIPX+ZOOMY2,#Sfreq
				SPRITE 6, #bx1-counter + VISIBLE +ZOOMX2, P1Closer+5+FLIPY+ZOOMY2, #Sfreq
			END IF			
			SPRITE 0, #bx1+counter + VISIBLE +ZOOMX2, P1Closer+boomC1+FLIPX+ZOOMY2, #Sfreq
			SPRITE 1, #bx1-counter + VISIBLE +ZOOMX2, P1Closer+boomC1+FLIPY+ZOOMY2, #Sfreq
		END IF
		
		IF #bx2 THEN
			boomY2=0 	'#by2=#by2-1:
			if #bx1=0 THEN boomY2=boomY2+1 ELSE if Counter1=0 THEN boomY2=boomY2+1 
			IF boomY2 THEN 	
				SPRITE 7,#bx2 + VISIBLE + ZOOMX2 , #by2+ZOOMY2-boomC1, #Sfreq
				SPRITE 5, #bx2+counter + VISIBLE+ZOOMX2 , 99+FLIPX+ZOOMY2, #Sfreq
				SPRITE 6, #bx2-counter + VISIBLE+ZOOMX2 , 99+FLIPY+ZOOMY2, #Sfreq
			END IF				
			SPRITE 2, #bx2+counter + VISIBLE+ZOOMX2 , 99-boomC1+FLIPX+ZOOMY2, #Sfreq
			SPRITE 3, #bx2-counter + VISIBLE+ZOOMX2 , 99-boomC1+FLIPY+ZOOMY2, #Sfreq
		END IF
		
		WAIT
		counter2=counter2+1
		if counter2=2 THEN 
			counter2=0
			boomC1=boomC1+1
			POKE $31,boomC1 AND 1
			#Sfreq=#SFreq+2
			if #Sfreq>=SPR_DEADEND THEN #Sfreq=SPR_DEADLOOP			
		end if
		
		IF counter1 THEN BoomColor=BoomColor+1:IF BoomColor>12 THEN BoomColor=0
	
		y=y+1:if y>63 then y=30
		SOUND 4, y,&00011100
		
		IF counter>56 THEN Goto GameOver3						
		GOTO GameOver2
		
GameOver3:
		'Exit to title if it's in Attract mode.
		IF Players=3 THEN GOTO Reboot
		
		resetsprite(5):resetsprite(6):resetsprite(6)
		IF #bx1 THEN resetsprite(0):resetsprite(1)
		IF #bx2 THEN resetsprite(2):resetsprite(3)
				
		#DrawColor=CS_BLUE:x=80: GOSUB DrawBar2:x=140: GOSUB DrawBar2
		
		PRINT AT 100 color CS_BLUE, "Clr = reset or"
		PRINT at 120 color CS_GREEN,"Hit any button"
		
		IF Players=0 THEN			
			IF Continue>0 THEN
				PRINT AT 120, "1 = Continue:":PRINT COLOR CS_YELLOW,<>Continue	'Overwrite "hit any button"
			ELSE
				PRINT at 120,"Enter to exit."
			END IF
			PRINT AT 63 color CS_YELLOW,"Game Over"
			PLAY FULL:PLAY GameOverMusic		
		ELSEIF Players=1 THEN
			IF CPURound>1 THEN 
				PRINT at 63 color CS_WHITE,"You"
				PRINT at 68
				IF e2=0 THEN	PRINT "Lost"	ELSE PRINT "Win!"
			ELSE
				PRINT at 61 color CS_TAN,"CPU Defeated!"
				Round=Round+1		'Player1 Round advance
			END IF
		END IF
		x=0:GOSUB DebounceKey 
		
GameOver4:	
		WAIT:POKE $31,0		
		
		IF CONT.KEY=12 THEN 
			x=x+1					'keys clear
		ELSEIF CONT.KEY=10 AND x THEN 
			GOTO Reboot				'clear to reboot
		ELSEIF CONT.KEY=11 AND x THEN 
			GOTO ContinueOrReset		'enter to continue/exit/reset
		ELSEIF CONT2.KEY=1 THEN		'1 does it too..
			 GOTO ContinueOrReset
		END IF
									
		IF Players THEN 	'if not asking continue, "any button" can exit
			IF CONT.B0+CONT.B1+CONT.B2 THEN GOTO StartAgain
		END IF		
		GOTO GameOver4
		
ContinueOrReset:
	IF Players=0 THEN		
		IF Continue THEN
			Continue=Continue-1
			scorep1=0:scorep2=0
			CPUround=1:Players=1  '<---these two were modified, get them back	
			#Score=0
			GOTO StartAgain
		ELSE
			GOSUB ResetMusic:CLS
			x=10:GOSUB SLEEP:	GOTO Reboot 
		END IF
	ELSE 
		GOTO StartAgain
	END IF


'=================================================================================================		
asm org $d000
INCLUDE "mmSV_pCPU.bas"
INCLUDE "mmSV_stuff.bas"
INCLUDE "mmSV_options.bas"

'Gets card. DrawX=0:DrawY=0:DrawCard=0:#DrawColor=0:DrawCmd=0:GOSUB DrawCmdGo
DrawCmdGo: PROCEDURE
	DrawBlank=1
	IF DrawCmd=0 THEN RESTORE Draw0
	IF DrawCmd=1 THEN RESTORE Draw1
	IF DrawCmd=2 THEN RESTORE Draw2
	IF DrawCmd=3 THEN RESTORE Draw3
	IF DrawCmd=4 THEN RESTORE Draw4
	IF DrawCmd=5 THEN RESTORE Draw5
	IF DrawCmd=6 THEN RESTORE Draw6
	IF DrawCmd=7 THEN RESTORE Draw7
	IF DrawCmd=8 THEN RESTORE Draw8
	IF DrawCmd=9 THEN RESTORE Draw9
		
DrawAgain:
	READ DrawCmd:IF DrawCmd=0 THEN RETURN			
	IF DrawCmd="B" THEN DrawBlank=0:GOTO DrawAgain	
	READ DrawEx:IF DrawEx<1 then DrawEx=1
	
	IF DrawCmd="C" THEN #DrawColor=DrawEx:GOTO DrawAgain
	IF DrawCmd="X" THEN	DrawX=DrawEx:GOTO DrawAgain
	IF DrawCmd="Y" THEN	DrawY=DrawEx:GOTO DrawAgain		
	
	IF DrawCmd="E" THEN	DrawXA=1:DrawYA=2:GOTO DrawPrint
	IF DrawCmd="F" THEN	DrawXA=1:DrawYA=1:GOTO DrawPrint
	IF DrawCmd="G" THEN	DrawXA=2:DrawYA=1:GOTO DrawPrint
	IF DrawCmd="H" THEN	DrawXA=2:DrawYA=2:GOTO DrawPrint
	IF DrawCmd="R" THEN	DrawXA=1:DrawYA=0:GOTO DrawPrint
	IF DrawCmd="L" THEN	DrawXA=2:DrawYA=0:GOTO DrawPrint
	IF DrawCmd="U" THEN	DrawXA=0:DrawYA=2:GOTO DrawPrint
	IF DrawCmd="D" THEN	DrawXA=0:DrawYA=1:GOTO DrawPrint
	GOTO DrawAgain	
DrawPrint:
	IF DrawBlank THEN PRINT AT screenpos(DrawX, DrawY), (DrawCard*8)+#DrawColor
	IF DrawXA=1 THEN DrawX=DrawX+1 ELSE IF DrawXA=2 THEN DrawX=DrawX-1
	IF DrawYA=1 THEN DrawY=DrawY+1 ELSE IF DrawYA=2 THEN DrawY=DrawY-1
	DrawEx=DrawEx-1
	IF DrawEx THEN GOTO DrawPrint	
	DrawBlank=1
	GOTO DrawAgain
END
	
INCLUDE "mmSV_Data.bas"	
INCLUDE "mmSV_Pic.bas"
