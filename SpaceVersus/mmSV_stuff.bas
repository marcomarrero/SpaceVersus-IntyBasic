'mmSV_stuff

DebounceKey: PROCEDURE
DebounceX:
	WAIT
	IF CONT.BUTTON OR CONT.KEY<>12 THEN GOTO DebounceX
	RETURN
END

'Process Pad, gamepad horizontal/vertical. IN SPACE VERSUS CONTROLS ARE SWAPPED
VDISK: PROCEDURE
	IF GamePad1 THEN
		P1Left=CONT2.DOWN:P1Right=CONT2.UP:P1Up=CONT2.LEFT:P1Down=CONT2.RIGHT		
	ELSE
		P1Left=CONT2.LEFT:P1Right=CONT2.RIGHT:P1Up=CONT2.UP:P1Down=CONT2.DOWN
	END IF
	
	IF GamePad2 THEN
		P2Left=CONT1.DOWN:P2Right=CONT1.UP:P2Up=CONT1.LEFT:P2Down=CONT1.RIGHT
	ELSE
		P2Left=CONT1.LEFT:P2Right=CONT1.RIGHT:P2Up=CONT1.UP:P2Down=CONT1.DOWN
	END IF	
	RETURN	
END

'Check/set autofire setting on countdown and press-any-key
'CheckAutoFire: PROCEDURE
'	IF Players=1 OR Players=2 THEN
'		IF CONT2.KEY>0 THEN 
'			IF CONT2.KEY=1 THEN P1AutoFire=1 ELSE IF CONT2.KEY=2 THEN P1AutoFire=0 ELSE IF CONT2.KEY=3 THEN P1AutoFire=3
'		END IF 'AutoFire: 1=full auto, 2=off, 3=selective
'		IF Players=2 THEN
'			IF CONT1.KEY>0 THEN 
'				IF CONT1.KEY=1 THEN P2AutoFire=1 ELSE IF CONT1.KEY=2 THEN P2AutoFire=0 ELSE IF CONT1.KEY=3 THEN P2AutoFire=3
'			END IF
'		END IF
'	END IF
'	RETURN
'END
	
DrawBar1: PROCEDURE
	PRINT AT x COLOR GUICOLOR,"\280\280\280\280\280"	'bar
	RETURN
END
DrawBar2: PROCEDURE
	PRINT AT x COLOR #DrawColor+0
	FOR x=0 TO 6:PRINT "\280\280":NEXT
	RETURN
END
DrawBar3: PROCEDURE
	FOR x=0 TO 9:PRINT "\280\280":NEXT
	RETURN
END

'Nice colored billboards
DrawBillboard1: PROCEDURE
	PRINT AT ScreenPos(DrawX,Y) COLOR #DrawColor+0, "\257\257\257\257\257\257" 'solid
	'PRINT AT ScreenPos(DrawX,Y) COLOR #DrawColor+0, "\256\257\256\257\256\257" 'checker
	RETURN
END

Sleep: PROCEDURE
	for y=1 to x:WAIT:next y
	RETURN
END

ResetMusic: PROCEDURE
	PLAY NONE:SOUND 0, 1, 0:SOUND 1, 1, 0:SOUND 2, 1, 0:SOUND 4, 1, &00011100
	RETURN
END

'Usage: WAIT:CALL CreateShips(A)
'Reads SourceMOV ---> Create 2 enemy ships: ShieldMOV, italicMOV
'Most source code pillaged from: http://atariage.com/forums/topic/249202-intybasic-a-more-colourful-font/page-2
'Destroys r0,r1,r2,r4,r5, returns nothing
ASM CREATESHIPS: PROC
	asm pshr r5				; Stack return address.
	asm 						; Convert 1st parameter into an offset in GRAM.
	asm sll r0, 2
	asm sll r0, 1			; A=A*8
	asm addi #$3800, r0		; r0+=$3800 (GRAM)

	asm movr r0,r4			; r4=r0 (r4=source)
	
	asm movr	r0,r2			; r2=r0
	asm addi #8,r2			; r2=r2+8 (shield:next sprite)
		
	asm movr	r2,r5			; r5=r2
	asm addi #8,r5			; r5=r5+8 (italic:next next sprite)

	asm				;----1------ 
	asm mvi@ r4, r0			; r0=[r4++]		
	asm mvii #$7C,r1			; [r1]=$7C	shield:just draw a big thing .xxxxx..
	asm mvo@ r1, r2			; [r2]=r1	italic:just copy	
	asm incr	r2				; r2++
	asm mvo@ r0, r5			; [r5++]=r0	italic:just copy

	asm				;----2------ 
	asm mvi@ r4, r0			; r0=[r4++]		
	asm mvii #$C6,r1			; [r1]=$c6	shield: just draw another big thing. xx...xx.
	asm mvo@ r1, r2			; [r2]=r1	italic:just copy
	asm incr	r2				; r2++
	asm mvo@ r0, r5			; [r5++]=r0	italic: just copy
	
	asm repeat 2		;--- 3,4----
	asm mvi@ r4, r0			; r0=[r4++]
	asm mvo@ r0, r2			; [r2]=r0	shield:just copy
	asm incr r2				; r2++
	asm slr r0, 1			; shift 1	italic:shift 1
	asm mvo@ r0, r5			; [r5++]=r0
	asm	endr

	asm repeat 2		;----5,6-----
	asm mvi@ r4, r0			; r0=[r4++]	
	asm mvo@ r0, r2			; [r2]=r0	shield:just copy
	asm incr r2				; r2++	
	asm slr r0, 2			; shift 2	italic:shift 2
	asm mvo@ r0, r5			; [r5++]=r0
	asm	endr
	
	asm repeat 2		;----7,8------
	asm mvi@ r4, r0			; r0=[r4++]	
	asm mvo@ r0, r2			; [r2]=r0	shield:just copy
	asm incr r2				; r2++	
	asm slr r0, 1			; shift 1
	asm slr r0, 2			; shift 2	;shift 3
	asm mvo@ r0, r5			; [r5++]=r0
	asm	endr
	
	asm pulr pc	;return
asm ENDP