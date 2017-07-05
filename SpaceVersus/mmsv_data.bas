'------- DATA / MUSIC ----------------
'Draw routine has a bug drawing 1st element, I couldnt prototype in GWBASIC

Draw0:	
	DATA "B","R",1,"R",1,"F",1,"D",2,"G",1,"L",1,"H",1,"U",3,0
Draw1:
	DATA "B","R",2,"D",1,"L",1,"R",1,"D",3,"L",1,"R",3,0
Draw2:
	DATA "R",2,"F",1,"G",1,"L",1,"G",1,"D",1,"R",4,0	
Draw3:
	DATA "R",2,"F",1,"G",1,"L",1,"R",1,"F",1,"G",1,"L",3,0	
Draw4:
	DATA "D",2,"R",3,"L",1,"U",2,"D",5,0
Draw5:
	DATA "R",4,"B","L",4,"D",2,"R",2,"F",1,"G",1,"L",3,0	
Draw6: 
	DATA "B","D",1,"E",1,"R",3,"B","L",4,"B","D",1,"D",2,"F",1,"R",1,"E",1,"H",1,"L",2,0	
Draw7:
	DATA "D",0,"U",0,"R",3,"D",1,"G",2,"D",2,0
Draw8:
	DATA "B","D",1,"E",1,"R",1,"F",1,"G",1,"L",1,"G",1,"F",1,"R",1,"E",1,"H",1,0
Draw9:
	DATA "B","D",1,"E",1,"R",1,"F",1,"D",1,"L",2,"R",2,"D",1,"G",1,"L",2,0	
	
'SOUND data=======================

SP1_Shoot:	
	DATA $0040,$0100,$0080,$0040,$0200,$0100,$0080,$0400,$0200,$0800,$0400,$0200,$0800,0,0
	
SP1_Laser:	
	DATA $0050,$0080,$00A0,$00E0,$0120,$0130,$0140,$0160,$0180,$01C0,$0320,$03C0,$0470,$04A0,$04C0,0,0
	
SP2_Shoot:	
	DATA $00B0,$0150,$01F0,$0290,$0330,$03D0,$0470,$0510,$05B0,$0650,$06F0,0,0
	
SP2_Laser:		
	DATA $0050,$0060,$0070,$0080,$0120,$0130,$0140,$01E0,$01F0,$0200,$0210,$0320,$0330,$0340,$03C0,0,0
	
SP_Backgr:		
	DATA $0C80,$0B40,$0AA0,0,0
	
SP_Backgr2:		
	DATA $0C80,$0B40,$0AA0,$0B40,0,0
	
SP_Deflect:		
	'DATA $03C0,$03D0,$03F0,$0440,$0490,$5500,$6F00,0,0
	DATA $0050, $0055, $0060,$0070,$0040,$0050,$0030,0,0

ShieldSound:
	DATA $0800,$0600,$0400, $0700,$0500,$0300, $0600,$0400,$0200,0,0

TauntSound:
	DATA $0801, $0601, $0501, $00401, $0301, $0201, $0101, $0050,$00400, $0300, $0200, $0100, $0050,0,0
	
TitleMusic: 
	DATA 14
	MUSIC C3,E3,G3,M1
	MUSIC S,G2,S
	
	MUSIC C3,E3,A3,M1
	MUSIC S,G2,S
	
	MUSIC C3,E3,B3,M3
	MUSIC S,G2,S
'-	
	MUSIC C3,F3,A3,M1
	MUSIC S,F2,S
	
	MUSIC C3,F3,B3,M1
	MUSIC S,F2,S
	
	MUSIC C3,F3,C4,M3
	MUSIC S,F2,S
'-	
	MUSIC D3,G3,B3,M1
	MUSIC S,B2,S
	
	MUSIC D3,G3,C4,M1
	MUSIC S,B2,S
	
	MUSIC D3,G3,D4,M1
	MUSIC S,B2,S
'-	
	MUSIC C3,F3,C4,M1
	MUSIC S,F2,S
	
	MUSIC C3,F3,B3,M1
	MUSIC S,F2,S
	
	MUSIC C3,F3,A3,M1
	MUSIC S,F2,S
'-
	MUSIC REPEAT

'RoundStart2: 
'	DATA 16
'	MUSIC d3,g2,d4
'	MUSIC S,S,g3
'	MUSIC S,S,b3	
'	MUSIC S,S,d4
'	MUSIC S,S,S
'	MUSIC S,S,S
'	MUSIC STOP
	

RoundStart: 
	DATA 16
	MUSIC b2,e2,b3
	MUSIC S,S,e3
	MUSIC S,S,g3
	MUSIC S,S,b3
	MUSIC S,S,S
	MUSIC S,S,S
	MUSIC STOP

'EXPLOSION COLORS=========================
'BoomData: 
'0-7
'DATA SPR_WHITE, SPR_BLUE, SPR_LIGHTBLUE, SPR_CYAN, SPR_WHITE, SPR_CYAN, SPR_LIGHTBLUE, SPR_BLUE
'DATA SPR_RED, SPR_ORANGE, SPR_YELLOW, SPR_ORANGE, SPR_BLUE
'8-12 
'DATA SPR_BROWN, SPR_WHITE, SPR_RED, SPR_GREY, SPR_RED
'13-16

GameOverMusic: 
	DATA 14
	MUSIC	g4, c2,c3
	MUSIC	e4, S,S
	MUSIC	c4, S,S
	
	MUSIC	g4, S,c3
	MUSIC	e4, S,S
	MUSIC	c4, S,S

	MUSIC	g4, c2,S
	MUSIC	e4, S,S
	MUSIC	c4, S,S

	MUSIC	g4, S,c3
	MUSIC	e4, S,S
	MUSIC	c4, S,S
'---	
	MUSIC	g4, g2,S
	MUSIC	d4, S,S
	MUSIC	b3, S,S
	
	MUSIC	g4, S,g3
	MUSIC	d4, S,S
	MUSIC	b3, S,S

	MUSIC	g4, g2,S
	MUSIC	d4, S,S
	MUSIC	b3, S,S

	MUSIC	g4, g2,g3
	MUSIC	d4, S,S
	MUSIC	b3, S,S
'--------------------------------			
	MUSIC	g4, c2,g5
	MUSIC	e4, S,s
	MUSIC	c4, S,e5
	
	MUSIC	g4, c3,s
	MUSIC	e4, S,c5
	MUSIC	c4, S,s

	MUSIC	g4, c2,e5
	MUSIC	e4, S,s
	MUSIC	c4, S,c5
	
	MUSIC	g4, c3,s
	MUSIC	e4, S,e5
	MUSIC	c4, S,S
'---	
	MUSIC	g4, g2,g5
	MUSIC	d4, S,s
	MUSIC	b3, S,d5
	
	MUSIC	g4, g3,s
	MUSIC	d4, S,b4
	MUSIC	b3, S,s

	MUSIC	g4, g2,d5
	MUSIC	d4, S,s
	MUSIC	b3, S,b4

	MUSIC	g4, g3,S
	MUSIC	d4, S,d5
	MUSIC	b3, S,S	
'--------------------------
	MUSIC	g4, c2,g5
	MUSIC	e4, S,s
	MUSIC	c4, S,e5
	
	MUSIC	g4, c3,s
	MUSIC	e4, S,c5
	MUSIC	c4, S,s

	MUSIC	g4, c2,e5
	MUSIC	e4, S,s
	MUSIC	c4, S,c5
	
	MUSIC	g4, c3,s
	MUSIC	e4, S,e5
	MUSIC	c4, S,S
'---	
	MUSIC	g4, g2,g5
	MUSIC	d4, S,s
	MUSIC	b3, S,d5
	
	MUSIC	g4, g3,s
	MUSIC	d4, S,b4
	MUSIC	b3, S,s

	MUSIC	g4, g2,d5
	MUSIC	d4, S,s
	MUSIC	b3, S,b4

	MUSIC	g4, g3,S
	MUSIC	d4, S,d5
	MUSIC	b3, S,S		
'--------------------------
	MUSIC REPEAT

