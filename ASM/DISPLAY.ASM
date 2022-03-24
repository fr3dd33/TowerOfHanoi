; 12/17/2017 12:15 AM

;--------------------VIDEO_CHECK PROC----------------------
; On initial state function tests video mode weather is it
; in text mode. If not sets text mode 80x25.

VideoCheck proc
    mov ah, 0Fh
    int 10h
    cmp al, 3
    je video_ok

    mov ax, 3
    int 10h

video_ok:
    or bh, bh
    jz vidoe_page_ok

    mov ax, 0500h
    int 10h

vidoe_page_ok:
    ret

VideoCheck endp
;----------------------------------------------------------



;--------------------HIDE_CURSOR PROC----------------------
; ...
HideCursor proc

	mov ah, 01h
	mov ch, 32h
	mov cl, 0Ah
	int 10h
	
	ret

HideCursor endp
;----------------------------------------------------------



;--------------------DRAW PROC-----------------------------
; This proc works directly with video buffer address at 0B800h.

Draw proc

	call ClearScreen
	
	mov cx, 554
	mov si, offset TOH
	call Print
	
	mov cx, 1
	mov si, offset level
	call Print
	
	call NextLine
	call NextLine
	
	mov cx, 3
	mov bp, offset IndexArray
	
draw_index_loop:
	push cx
	mov ax, [bp]
	
	cmp ax, 0
	je draw_spaces
	
	cmp ax, 1
	je draw_down_arrow
	
	cmp ax, 2
	je draw_up_arrow

draw_spaces:
	mov cx, 20
	mov si, offset spaces
	call Print
	jmp draw_index_done
	
draw_down_arrow:	
	mov cx, 20
	mov si, offset index_down
	call Print
	jmp draw_index_done
	
draw_up_arrow:
	mov cx, 20
	mov si, offset index_up
	call Print
	
draw_index_done:
	inc bp
	inc bp
	pop cx
	loop draw_index_loop
	
	call NextLine
	call NextLine
	
	mov cx, TowerSize
	mov bp, offset Tower
	
draw_loop_1:	
	push cx
	mov cx, 3
	
draw_loop_2:
	push cx
	mov cx, 20
	mov ax, [bp]
	cmp ax, 0
	je draw_column
	
	cmp ax, 1
	je draw_tower_1 
	
	cmp ax, 2
	je draw_tower_2
	
	cmp ax, 3
	je draw_tower_3
	
	cmp ax, 4
	je draw_tower_4
	
	cmp ax, 5
	je draw_tower_5
	
	cmp ax, 6
	je draw_tower_6
	
	cmp ax, 7
	je draw_tower_7
	
draw_column:
    mov si, offset tower_8
	call Print	
	jmp draw_done
	
draw_tower_1:
    mov si, offset tower_1
    call Print
	jmp draw_done

draw_tower_2:
    mov si, offset tower_2
    call Print
	jmp draw_done

draw_tower_3:
    mov si, offset tower_3
    call Print
	jmp draw_done
	
draw_tower_4:
	mov si, offset tower_4
	call Print
	jmp draw_done
	
draw_tower_5:
	mov si, offset tower_5
	call Print
	jmp draw_done
	
draw_tower_6:
	mov si, offset tower_6
	call Print
	jmp draw_done
	
draw_tower_7:
	mov si, offset tower_7
	call Print
	
draw_done:
	inc bp
	inc bp
	pop cx
	loop draw_loop_2
	
	call NextLine
	pop cx
	loop draw_loop_1
	
	;mov cx, 23
	;mov si, offset msg_enter
	;call Print
	
    ret
Draw endp
;----------------------------------------------------------



;--------------------PRINT PROC----------------------------
; Function uses cx and si registers. And this could be
; analogue interrupt int 21 func 09h in DOS
; cx - string length
; si - string offset
; 10 - next line character

Print proc
	push es
	push di
	
	push 0B800h
	pop es
	
	mov di, cur_pos_col
	
print_char:

	mov ah, attr_num
	mov al, byte ptr [si]
	cmp al, 10
	jne print_if_not_enter
	
	add cur_pos_row, 160
	mov di, cur_pos_row
	jmp print_next_line
	
print_if_not_enter:
	stosw
	
print_next_line:
	inc si
	
	mov ax, di
	div num_160
	mov dh, al
	shr ah, 1
	mov dl, ah

	mov ah, 02h
	int 10h
	
	loop print_char
	
	mov cur_pos_col, di
	
	pop di
	pop es
	
	ret
	
Print endp
;----------------------------------------------------------



;--------------------NEXT_LINE PROC------------------------
; Just call this func to move next line.

NextLine proc

	mov cx, 1
	mov si, offset char_enter
	call Print
	
	ret
NextLine endp
;----------------------------------------------------------




;--------------------WAIT_KEY PROC-------------------------
; Waits any key press
WaitKey proc

	mov ah, 10h
	int 16h
	ret

WaitKey endp
;----------------------------------------------------------



;--------------------GET_ARROW_POSITION PROC---------------
GetArrowPosition proc

	mov cx, 3
	mov bp, offset IndexArray
	mov si, 0
	
;
; loop for getting current position of arrow in array
;
get_index:
	push cx
	mov ax, word ptr [bp+si]
	cmp ax, 1
	je get
	cmp ax, 2
	jne get_index_done
	
get:
	pop cx
	mov cx, 1
	mov index_position, si
	jmp get_index_loop_done
	
	
get_index_done:
	inc si
	inc si
	pop cx

get_index_loop_done:
	loop get_index
	
	mov ah, 10h
	int 16h
	
	mov si, index_position	; get current position of 
							; arrow indicator
	
	cmp ax, 4BE0h 			; left arrow key code 
	je move_left
	
	cmp ax, 48E0h 			; up arrow key code 
	je move_up
	
	cmp ax, 4DE0h 			; right arrow key code 
	je move_right
	
	cmp ax, 50E0h			; down arrow key code
	je move_down
	
	jmp move_done
	
move_left:
	cmp index_position, 0
	je move_abort
	
	mov word ptr [bp+si], 0
	dec si 
	dec si
	cmp up_arrow_pressed, 1
	je move_2
	mov word ptr [bp+si], 1
	jmp move_abort
	
move_up:
	mov word ptr [bp+si], 2
	mov ax, index_position
	shr ax, 1
	mov n, ax 
	mov up_arrow_pressed, 1
	jmp move_abort

move_right:
	cmp index_position, 4
	je move_abort
	
	mov word ptr [bp+si], 0
	inc si
	inc si
	cmp up_arrow_pressed, 1
	je move_2
	mov word ptr [bp+si], 1
	jmp move_abort

move_down:
	;cmp up_arrow_pressed, 1
	;jne move_abort
	
	mov word ptr [bp+si], 1
	mov ax, index_position
	shr ax, 1
	mov m, ax
	mov move, 1
	mov up_arrow_pressed, 0
	jmp move_done
	
move_2:
	mov word ptr [bp+si], 2
	
move_abort:
	mov move, 0
	
move_done:	
	ret

GetArrowPosition endp
;----------------------------------------------------------



;--------------------CLEAR_SCREEN PROC---------------------
; This function clears video buffer at address 0B800h

ClearScreen proc

	push es
	push di
	
	push 0B800h
	pop es
	
	xor di, di

	mov cx, 2000
	mov ah, attr_num
	mov al, ' '
	rep stosw

	mov cur_pos_row, 0
	mov cur_pos_col, 0
	
	pop di
	pop es
	
	ret

ClearScreen endp
;----------------------------------------------------------



;--------------------SCAN PROC-----------------------------
; Scan proc is used for initial logic, reading chars 
; from keyboard directly,
; e.g. 3 <space> 2 means from 3rd column move to 2nd
; 
Scan proc

enter_again:
	mov ah, 10h
	int 16h

	cmp al, 0Dh
	je enter_again
	cmp al, 31h
	jb enter_again
	cmp al, 33h
	jg enter_again
	mov byte ptr [n], al
	mov cx, 1
	mov si, offset n
	call Print
	sub n, 30h

	mov ah, 10h
	int 16h

	mov cx, 1
	mov si, offset char_space
	call Print

enter_again_2:
	mov ah, 10h
	int 16h

	cmp al, 0Dh
	je enter_again_2
	cmp al, 31h
	jb enter_again_2
	cmp al, 33h
	jg enter_again_2
	mov byte ptr [m], al
	mov cx, 1
	mov si, offset m
	call Print
	sub m, 30h

	mov ah, 10h
	int 16h

	ret

Scan endp
;----------------------------------------------------------


