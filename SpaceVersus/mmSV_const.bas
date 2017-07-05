'----- Constants. 

'-- Scoreboard
CONST P1Score = 16			'E00
CONST P1Score3 = 37			'W0
CONST P1Score4 = P1Score3+2	'ww
CONST P1Score2 = P1Score+39

CONST GUICOLOR = CS_BLUE
CONST STAGETEXT = 95
CONST ROUNDTEXT = 115

CONST P2Score = 236			'E 00
CONST P2Score3 = 217			'w 00
CONST P2Score4 = P2Score3+2
CONST P2Score2 = P2Score-41	'Win!/Lose text position

CONST MAXX = 113
CONST MINX = 8	
CONST EQUXXY = 54

'--start position	
CONST STARTP1 = 16
CONST STARTP2 = 10
	
CONST PBulletSpeed = 5			'Bullet speed

CONST PLaserDelay = 50			'Button held (frames) to activate laser
CONST PLaserSpeed = 8			'Laser speed

CONST PlayerShield = 50		'Shield counter
CONST PlayerShieldFreeze = 40	'Freeze player...
CONST PlayerShieldOFF = 20		'Shield off, cool down

CONST PBulletDamage = 5			'Bullet damage 
CONST PLaserDamage = 10			'Damage caused by laser 
CONST PDeflect = 4
CONST PTauntEnergy = 2			'Taunt energy+

CONST	P1BulletEnd = 108			'bullet offscreen
CONST	P2BulletEnd = -4			'bullet offscreen

'---Sprite definitions ----	

'---Player1/CPU-----
CONST CPU_SHIP0 = SPR25
CONST CPU_SHIP0H = SPR26
CONST CPU_TURN0 = SPR27

CONST SPR_SHIP1 = CPU_SHIP0 + SPR_LIGHTBLUE		'Player 1
CONST SPR_SHIP1H = CPU_SHIP0H + SPR_LIGHTBLUE	'Player 1 HELD!
CONST SPR_TURN1 = CPU_TURN0 + SPR_LIGHTBLUE		'Player 1 turning	
CONST SPR_SHOT1 = SPR04 + SPR_CYAN				'Bullet 1
CONST SPR_DEBRI1 = (SPR12 - SPR04) + 1			'Debris1 (SPR13)

'-------- player2/HUMAN----
CONST PL2_SHIP0 = SPR03
CONST PL2_SHIP0H = SPR05
CONST PL2_TURN0 = SPR07

CONST SPR_SHIP2 = PL2_SHIP0 + SPR_YELLOWGREEN	'Player 2
CONST SPR_SHIP2H = PL2_SHIP0H + SPR_YELLOWGREEN	'Player 2 HELD!
CONST SPR_TURN2 = PL2_TURN0 + SPR_YELLOWGREEN	'Player 2 turning	
CONST SPR_SHOT2 = SPR04 + SPR_YELLOWGREEN		'Bullet 2
CONST SPR_DEBRI2 = (SPR12 - SPR04) + 1			'Debris2 (SPR13)

'---UFO/equxx/equalizer-----
CONST SPR_EQUXX = SPR08 + SPR_PINK			'Equalizer 
CONST SPR_BALL1 = SPR06 + SPR_RED			'Equalizer bullet 1
CONST SPR_BALL2 = SPR06 + SPR_ORANGE		'Equalizer bullet 2

'---explosions----
CONST SPR_DEAD = SPR08						'Boom spites.. 8,9,10,11,12
CONST SPR_DEAD2 = SPR09 + SPR_GREY
CONST SPR_DEADEND = SPR15						'last sprite explosion
CONST SPR_DEADLOOP = SPR11					

'---other constants----
CONST FLIPXZOOMY2 = FLIPX + ZOOMY2			
CONST FLIPXZOOMY4 = FLIPX + ZOOMY4
CONST FLIPXZOOMY8 = FLIPX + ZOOMY8
CONST VISIBLEHIT = VISIBLE + HIT
CONST VISIBLEHITX2 = VISIBLE + ZOOMX2 + HIT
CONST ZOOMX2VISIBLE = VISIBLE + ZOOMX2 
	
'MUSIC/SOUND
CONST BgSoundVolDelay = 4
CONST BgSoundVol = 9
CONST BgSoundMin = 3

'Scoring
CONST SCORE_UFO = 1			'point shooting UFO
CONST SCORE_SHIELD = 1		'points to hit shield
CONST SCORE_HIT   = 2			'points per hit
CONST SCORE_LASER = 10		'per laser
CONST SCORE_KILL = 200		'per kill (Easy)
CONST SCORE_KILL2 = 500		'per kill (Hard)

CONST SCORE_AT = 155			'position... Hiscore
CONST SCORE_AT2= SCORE_AT+40	'position... score