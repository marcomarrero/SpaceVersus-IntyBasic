'---- Graphics. 
'sprite# --------------- tile ----------
Graphics0:
'0:  Border1              256
	BITMAP "mmm mm m"
	BITMAP "mmm mm m"	
	BITMAP "mmm mm m"
	BITMAP "mmm mm m"	
	BITMAP "mmm mm m"
	BITMAP "mmm mm m"	
	BITMAP "mmm mm m"
	BITMAP "mmm mm m"	

'1: Score Tile Back		257
	BITMAP "m m m m "
	BITMAP " m m m m"	
	BITMAP "m m m m "
	BITMAP " m m m m"	
	BITMAP "m m m m "
	BITMAP " m m m m"	
	BITMAP "m m m m "
	BITMAP " m m m m"	
	
'2: Copyright/Shield/Round  258
	BITMAP "  xxxx  "	
	BITMAP " xx  xx "	
	BITMAP "xx xx xx"
	BITMAP "x    x x"	
	BITMAP "x    x x"	
	BITMAP "xx xx xx"	
	BITMAP " xx  xx "	
	BITMAP "  xxxx  "	

'3: Ship1				259
	BITMAP "   M    "	
	BITMAP "m MMM m "
	BITMAP "m M M m "
	BITMAP "m MMM m "
	BITMAP "mMM MMm "
	BITMAP "MM   MM "
	BITMAP "MMMMMMM "
	BITMAP "M MMM M "
	
'4: Bullet				260. SPR_SHOT1/SPR_SHOT_2
	BITMAP "  mmmmm "	
	BITMAP " mmmmmmm"	
	BITMAP " mmm mmm"	
	BITMAP " mm   mm"	
	BITMAP " m  m  m"	
	BITMAP " m     m"	
	BITMAP "    m   "
	BITMAP " m     m"
	
'5: ShipHeld
	BITMAP " MMMMMM "	'261
	BITMAP "MM    MM"
	BITMAP "MM MM MM"
	BITMAP "M MMMM M"
	BITMAP "M MMMM M"
	BITMAP " MM  MM "
	BITMAP " MMMMMM "
	BITMAP "MM MM MM"	
	
'6: Judge bullet
	BITMAP "        "	'262
	BITMAP "        "	
	BITMAP "   xx   "
	BITMAP "  xxxx  "	
	BITMAP "  xxxx  "	
	BITMAP "   xx   "	
	BITMAP "        "	
	BITMAP "        "	

'7: Ship turn, handicap, turns are slower  '263
	BITMAP "  M     "	
	BITMAP "m MM m  "	
	BITMAP "m MMM m "	
	BITMAP " MMMMMm "	
	BITMAP " MMM Mm "	
	BITMAP " MMM  M "	
	BITMAP "  MMMMMm"	
	BITMAP "  M M M "	

'8: UFO / Explosion1	'264
	BITMAP "M   M M "	
	BITMAP " M MM M "
	BITMAP "  MMMM  "
	BITMAP " MM  MMM"
	BITMAP "MMM  MM "
	BITMAP "  MMMM  "
	BITMAP " M MM M "
	BITMAP " M  M  M"
	
'9: Explosion 2			'265
	BITMAP "        "
	BITMAP "  M  M  "
	BITMAP " M M  M "
	BITMAP "M MMM  M"
	BITMAP "  MMM   "
	BITMAP "M  M  M "
	BITMAP "  M  M  "
	BITMAP "        "	

'10: Starfield2/Explosion 3 '266
	BITMAP "   x    "	
	BITMAP "        "
	BITMAP "   x    "
	BITMAP "x x x x "
	BITMAP "   x    "
	BITMAP "        "
	BITMAP "   x    "
	BITMAP "        "	
	
'11: Explosion 4
	BITMAP "M  M    "	'267
	BITMAP "      M "
	BITMAP "   M    "
	BITMAP "M   M   "
	BITMAP "  M  M M"
	BITMAP "  M     "
	BITMAP "     M  "
	BITMAP "M  M   M"
	
'12: Explosion 5
	BITMAP " M   M  "	'268
	BITMAP "M   M   "
	BITMAP "  M    M"
	BITMAP "M    M  "
	BITMAP "        "
	BITMAP "  M  M  "
	BITMAP " M     M"
	BITMAP "M   M   "	

'13:starfield	, also used as particle '269
	BITMAP "        "
	BITMAP "   x    "
	BITMAP "        "
	BITMAP " x x x  "
	BITMAP "        "
	BITMAP "   x    "
	BITMAP "        "
	BITMAP "        "	
'14:270			was24:280.9
	BITMAP "      x "
	BITMAP "x       "
	BITMAP "        "
	BITMAP "   x    "
	BITMAP "        "
	BITMAP " x      "
	BITMAP "     x  "
	BITMAP "        "	

'15:					 '271 Energy
	BITMAP "        "	
	BITMAP "        "		
	BITMAP " XXXXX  "	
	BITMAP " XX     "	
	BITMAP " XXXXX  "	
	BITMAP " XXX    "	
	BITMAP " XXXXXX "	
	BITMAP "        "	

'======2nd set of cards=============================
Graphics1:
'16					'272.1 Lose/X
	BITMAP "        "	
	BITMAP "xx    xx"
	BITMAP " xx  xx "
	BITMAP "  xxxx  "
	BITMAP "   xx   "	
	BITMAP "  xxxx  "	
	BITMAP " xx  xx "	
	BITMAP "xx    xx"

'17	
	BITMAP "        "	'273.2 'ST AG GE
	BITMAP "        "	
	BITMAP " mmm mmm"
	BITMAP "m     m "
	BITMAP " mm   m "
	BITMAP "   m  m "
	BITMAP "mmm   m "
	BITMAP "        "	
'18					
	BITMAP "        "	'274.3
	BITMAP "        "	
	BITMAP "  mm   m"
	BITMAP " m  m m "
	BITMAP " mmmm m "
	BITMAP " m  m m "
	BITMAP " m  m  m"
	BITMAP "        "
'19	
	BITMAP "        "	'275.4
	BITMAP "        "
	BITMAP "mm mmm  "
	BITMAP "   m    "
	BITMAP "mm mmm  "
	BITMAP " m m    "
	BITMAP "mm mmm  "
	BITMAP "        "	
	
'20
	BITMAP "        "	'276.5  RO OUN ND
	BITMAP "        "
	BITMAP "xxx   xx"
	BITMAP "x  x x  "
	BITMAP "xxx  x  "
	BITMAP "x  x x  "
	BITMAP "x  x  xx"
	BITMAP "        "	
'21	
	BITMAP "        "	'277.6
	BITMAP "        "
	BITMAP "  x x x "
	BITMAP "x x x xx"
	BITMAP "x x x x "
	BITMAP "x x x x "
	BITMAP "   x  x "
	BITMAP "        "	
'22
	BITMAP "        "	'278.7
	BITMAP "        "
	BITMAP " x xx   "
	BITMAP " x x x  "
	BITMAP "xx x x  "
	BITMAP " x x x  "
	BITMAP " x xx   "
	BITMAP "        "
'23	: 				279.8 : Bullet2 (not used yet)
	BITMAP "  mmmmm "	
	BITMAP " mmmmm  "	
	BITMAP "mmmmm   "	
	BITMAP " mmmmm  "	
	BITMAP "  mmmmm "	
	BITMAP "   mmmmm"	
	BITMAP "  mmmmm "
	BITMAP "  mmmmm "
	
'24					'280.9      
	BITMAP "        "	
	BITMAP "        "	
	BITMAP "        "	
	BITMAP "1 1 1 1 "	
	BITMAP "        "	
	BITMAP "        "	
	BITMAP "        "	
	BITMAP "        "	
	
'=======Bad guys====================================	
BadGuy1:
'25 					'281.10
	BITMAP "m     m "	
	BITMAP "m  m  m "
	BITMAP "m mmm m "
	BITMAP "m mmm m "
	BITMAP "mm m mm "
	BITMAP "m m m m "
	BITMAP "mmmmmmm "
	BITMAP "mm m mm "
	
'26:282 AND 27:283 are for the Bad guy!!
'The ASM function "CREATESHIPS" will create the "shielded" and italic shapes

BadGuy2:
	BITMAP " m m m  "	 '281.10
	BITMAP "  mmm   "
	BITMAP "  mmm   "
	BITMAP " mm mm  "
	BITMAP "mm m mm "
	BITMAP "m mmm m "
	BITMAP "mmmmmmm "
	BITMAP "mm m mm "

BadGuy3:
	BITMAP "  m m   "	 '281.10
	BITMAP " mm mm  "
	BITMAP "mmm mmm "
	BITMAP "m mmm m "
	BITMAP " mmmmm  "
	BITMAP "mm   mm "
	BITMAP "mmmmmmm "
	BITMAP "mm m mm "

BadGuy4:				'281.10
	BITMAP "  M M   "	 
	BITMAP "  M M   "
	BITMAP " MM MM  "
	BITMAP " MM MM  "
	BITMAP "MMM MMM "
	BITMAP "M M M M "
	BITMAP "MMMMMMM "
	BITMAP "MMMMMMM "

BadGuy5:				'281.10
	BITMAP "M     M "	 
	BITMAP "MMMMMMM "	
	BITMAP "  M M   "	
	BITMAP " MMMMM  "	
	BITMAP "MM M MM "	
	BITMAP "MMMMMMM "	
	BITMAP "MMM MMM "	
	BITMAP "MM   MM "	
	
BadGuy6:				'281.10
	BITMAP "M  M  M "	
	BITMAP "MM M MM "
	BITMAP "MMMMMMM "
	BITMAP "M  M  M "
	BITMAP "  MMM   "
	BITMAP " MM MM  "
	BITMAP "MM M MM "
	BITMAP " MMMMM  "


BadGuy7:				'281.10
	BITMAP "   M    "	
	BITMAP "  MMM   "	
	BITMAP " MM MM  "	
	BITMAP " M M M  "	
	BITMAP "MMMMMMM "	
	BITMAP "MM M MM "	
	BITMAP "MM M MM "	
	BITMAP " M M M  "	

BadGuy8:				'281.10
	BITMAP "M  M  M "	
	BITMAP "M MMM M "	
	BITMAP "M  M  M "	
	BITMAP "MM M MM "	
	BITMAP "MMMMMMM "	
	BITMAP "MMMMMMM "	
	BITMAP "MMM MMM "	
	BITMAP " M   M  "	

BadGuy9:				'281.10
	BITMAP "M  M  M "	
	BITMAP "MM M MM "	
	BITMAP "M MMM M "	
	BITMAP "MMMMMMM "	
	BITMAP "M MMM M "	
	BITMAP "  MMM   "	
	BITMAP "MMM MMM "	
	BITMAP "M M M M "	

BadGuy10:			'281.10
	BITMAP "  MMM   "	
	BITMAP " MM MM  "	
	BITMAP "MMMMMMM "	
	BITMAP "MM M MM "	
	BITMAP "   M    "	
	BITMAP "M MMM M "	
	BITMAP "MMMMMMM "	
	BITMAP "M MMM M "	
'=====================================
HiScore:
	BITMAP "        "	 '28:284
	BITMAP "        "
	BITMAP "        "
	BITMAP "X  X XXX"
	BITMAP "X  X  X "
	BITMAP "XXXX  X "
	BITMAP "X  X  X "
	BITMAP "X  X XXX"

	