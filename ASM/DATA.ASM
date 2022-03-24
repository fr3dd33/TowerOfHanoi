; 12/17/2017 12:13 AM

; Variables for move disk
IndexArray				dw		1, 0, 0
index_position			dw		0
move					db		0
up_arrow_pressed		db		0

; Array of Tower[9][3]
Tower     				dw		27 dup(0)

;Tower size
TowerSize 				dw     	3

; counter
count     				dw     	0	

; level
level     				db     	'0'

; variable for move disk from
n         				dw	   	0

; variable for move disk to
m         				dw    	0

; j and k for loop iteration
j						dw		0
k						dw		0

; Used in Check proc to check
; middle and right columns			
checkRight				dw		?
checkMiddle				dw		?

; 
bool					dw		0

; bool to check for was disk moved?
changed 				dw		0

; bool to check win
win						dw		0

; attribute number for text and background color
attr_num  				db    	7h

num_160					db 		160

; this two variables save current position of cursor
cur_pos_row				dw		0
cur_pos_col				dw		0

