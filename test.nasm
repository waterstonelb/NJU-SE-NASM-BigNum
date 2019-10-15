%include        'func.nasm'
SECTION .data
msg1  db    'Please enter: ', 0Ah      ; message string asking user for input
input times 100 db 0
SECTION .text
global  _start
 
_start:
    mov     edx, 255        ; number of bytes to read
    mov     ecx, input      ; reserved space to store our input (known as a buffer)
    mov     ebx, 0          ; write to the STDIN file
    mov     eax, 3          ; invoke SYS_READ (kernel opcode 3)
    int     80h
    mov     edx, 0
    mov     al, byte [input]
    sub     al, 48
    mov     bl, 10
    div     ebx
    mov     ecx, 48
    add     edx, ecx
    push    edx
    mov     eax, esp
    call    sprint
    call    quit