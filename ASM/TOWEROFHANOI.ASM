; 12/14/2017 12:15 AM

;--------------------NEXT_LEVEL PROC-----------------------
NextLevel proc
	
	cmp TowerSize, 10
	jne check_level

	mov cx, 53
	mov si, offset msg_end
	call Print
	ret
	
check_level:
	mov count, 1

	mov cx, TowerSize
	mov bp, offset Tower

check_loop_1:
	push cx
	mov cx, 3

check_loop_2:
	push cx
	mov ax, [bp]
	cmp cx, 3
	je count_pp
	
	mov word ptr [bp], 0
	jmp check_done
	
count_pp:
	mov ax, count
	mov word ptr [bp], ax
	inc count
	
check_done:
	inc bp
	inc bp
	pop cx
	loop check_loop_2
	
	pop cx
	loop check_loop_1

	inc level
	call Draw
	call TowerOfHanoi
	
	ret

NextLevel endp
;----------------------------------------------------------



;--------------------CHECK PROC----------------------------
Check proc
	
	mov checkRight, 1
	mov checkMiddle, 1
	
	mov cx, TowerSize
	mov bp, offset Tower
	mov si, 2
	mov di, 4
check_towers:
	
	mov ax, [bp+si]
	cmp ax, checkMiddle
	jne check_right
	
	inc checkMiddle
	
check_right:	
	mov ax, [bp+di]
	cmp ax, checkRight
	jne checking_done
	
	inc checkRight
	
checking_done:
	add si, 6
	add di, 6
	loop check_towers
	
	mov ax, checkRight
	dec ax
	cmp ax, TowerSize
	je isTrue
	
	mov ax, checkMiddle
	dec ax
	cmp ax, TowerSize
	je isTrue
	
	mov bool, 0
	ret
	
isTrue:
	mov bool, 1
	ret
	
Check endp
;----------------------------------------------------------



;--------------------TOWER_OF_HANOI PROC-------------------
TowerOfHanoi proc
	
	mov changed, 0
	mov win, 0
	
while_loop:

	; commented code is used for initial logic
	; reading chars from keyboard
	
	; call Scan
	; dec n
	; dec m

	; code in lines 127, 128 and 129 is used for arrow keys

	call GetArrowPosition
	cmp move, 1
	jne while_continue
	mov si, 0
	mov di, 0
	mov j, 0
	mov k, 0
	
	mov cx, TowerSize
	mov bp, offset Tower
	
TOH_loop_1:
	push cx
	
	mov ax, 03h
	mul j
	add ax, n
	shl ax, 1
	mov si, ax
	
	mov ax, [bp+si]
	cmp ax, 0
	je break_if_changed
	
	mov cx, TowerSize
	mov k, cx
	dec k
TOH_loop_2:
	push cx
	
	mov ax, 03h
	mul k
	add ax, m
	shl ax, 1
	mov di, ax
	
	cmp si, di				; this line of code 
	je si_di_equal			; need for case "1 1", "2 2", "3 3"
	
	mov ax, [bp+di]
	cmp ax, 0
	jne if_greater
	
	mov ax, [bp+si]
	mov word ptr [bp+di], ax
	mov ax, 0
	mov word ptr [bp+si], ax
	mov changed, 1
	jmp if_changed
	
if_greater:	
	mov ax, [bp+si]
	cmp ax, [bp+di]
	jng if_changed
	
si_di_equal:	
	mov changed, 1
	
if_changed:
	cmp changed, 1
	jne TOH_loop_2_continue
	pop cx
	mov cx, 1
	jmp break_loop_2
	
TOH_loop_2_continue:	
	pop cx
	dec k
	
break_loop_2:
	dec cx
	cmp cx, 0
	jne TOH_loop_2
	
break_if_changed:	
	cmp changed, 1
	jne TOH_loop_1_continue
	pop cx
	mov cx, 1
	jmp break_loop_1
	
TOH_loop_1_continue:
	pop cx
	inc j
break_loop_1:
	dec cx
	cmp cx, 0
	jne TOH_loop_1
	
while_continue:	
	mov changed, 0
	call Check
	call Draw
	
	cmp bool, 1
	jne while_loop
	
	mov ax, 0E07h
	xor bx, bx
	int 10h
	
	mov cx, 54
	mov si, offset msg_end
	call Print
	
	mov ah, 10h
	int 16h
	
	cmp al, 6Eh
	je continue_game
	
	cmp al, 4Eh
	jne exit
	
continue_game:
	inc TowerSize
	call NextLevel

exit:
	ret
	
TowerOfHanoi endp
;----------------------------------------------------------
