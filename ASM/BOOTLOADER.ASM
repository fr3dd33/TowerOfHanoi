.286
.model TINY
.code
org 07c00h

main:

  jmp bootloader_init
  nop

bootloader_init:
  mov ax, 07C0h			  ; Set up 4K of stack space above buffer
  add ax, 544			    ; 8k buffer = 512 paragraphs + 32 paragraphs (loader)
  cli				          ; Disable interrupts while changing stack
  mov ss, ax
  mov sp, 4096
  sti				          ; Restore interrupts

  mov ax, 07C0h			  ; Set data segment to where we're loaded
  mov ds, ax

  mov ax, 1301h
  mov bx, 0007h
  xor dx, dx
  mov cx, msg_boot_len
  mov bp, offset msg_boot
  int 10h

  mov ah, 10h
  int 16h


; DATA Segment
msg_boot        db 'Loading game...', 0
msg_boot_len    equ $ - msg_boot

  db 510 - ($ - main) dup (0)
  dw  0AA55h

END main
