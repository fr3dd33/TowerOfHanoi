; 12/13/2017 11:26 PM

msg_welcome	db	10, 10, 10, 10, 10, 10, 10
			db	'                  WELCOME TO GAME TOWER OF HANOI! =) LETS PLAY!    ',10
			db	'                     INSTRUCTION:   USE ARROW KEYS TO MOVE         ',10
			db	10
			db	'                          PRESS ANY KEY TO CONTINUE...             '

msg_end		db	10, 'CONGRATULATIONS! YOU DID IT! Press "N" to continue...'

TOH			db	'              _____ _____ _ _ _ _____ _____            _____ _____ ', 10
			db	'             |_   _|     | | | |   __| __  |          |     |   __|', 10
			db	'               | | |  |  | | | |   __|    -|          |  |  |   __|', 10
			db	'               |_| |_____|_____|_____|__|__|          |_____|__|   ', 10       
			db	'                         _____ _____ _____ _____ _____             ', 10
			db	'                        |  |  |  _  |   | |     |     |            ', 10 
			db 	'                        |     |     | | | |  |  |-   -|            ', 10 
			db	'                        |__|__|__|__|_|___|_____|_____|            ', 10
			db	10, 'LEVEL:   '

index_up	db	'          ', 30, '         '
index_down	db	'          ', 31, '         '
spaces		db	'                    '
	
tower_1		db	'      (------)      '

tower_2		db	'     (--------)     '

tower_3		db	'    (----------)    '

tower_4		db	'   (------------)   '

tower_5		db	'  (--------------)  '

tower_6		db	' (----------------) '

tower_7		db	'(------------------)'

tower_8		db	'         ||         '

char_enter	db	10
char_space	db	' '

tower_9		db	'         ||         '




