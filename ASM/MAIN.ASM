; 12/14/2017 12:18 AM

; =========================================================
; The Tower Of Hanoi game
; Copyright (C) 2017 Dee Talipoff
; 
; Most of this fucntions use BIOS interrupts. Thats why
; game runs under 16 BITS only. Use MASM or TASM compiler 
; to generate binary file
; For MASM:
; 		> ml.exe /c main.asm
;		> link16.exe main.obj
;==========================================================


.286
.model TINY
.code
org 100h

Start:
    jmp Begin
      
	include DISPLAY.ASM
	include TOWEROFHANOI.ASM
	include MESSAGES.ASM
	include DATA.ASM
	
Begin:
	
	call VideoCheck
	call HideCursor
	call ClearScreen
	
	mov cx, 211
	mov si, offset msg_welcome
	call Print
	
	mov ah, 10h
	int 16h
	
	call NextLevel
	call WaitKey
	
	int 20h
	
END Start
