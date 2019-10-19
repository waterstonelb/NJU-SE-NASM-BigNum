
SECTION .data
msg1   db    'Please enter x and y: ', 0Ah      ; message string asking user for input
input  times 100 db 0
str1   times 50  db 0
str2   times 50  db 0
stres  times 100 db 0

mul1   times 50  db 0
mul2   times 50  db 0
mulres times 100 db 0



SECTION .bss


SECTION .text
global  _start
 
_start:
    mov     eax, msg1
    call    sprint
    mov     edx, 255        
    mov     ecx, input      
    mov     ebx, 0          
    mov     eax, 3          
    int     80h
    mov     eax, 0
    push    eax
    mov     eax, input
    mov     ebx, str1
    inc     ebx
    mov     edx, str1
    mov     byte [edx], 43

split:
    cmp     byte [eax], 10
    je      .poploop

.pushloop:
    movzx   ecx, byte [eax]     
    push    ecx
    inc     eax
    jmp     split
.poploop:
    pop     ecx
    cmp     ecx, 0
    je      judge                       ;判断进行加法还是减法
    cmp     ecx, 45
    jne     .nextcmp
    mov     byte[edx], 45
    jmp     .poploop
.nextcmp:
    cmp     ecx, 32
    jne     .next
    mov     ebx, str2
    inc     ebx
    mov     edx, str2
    mov     byte [edx], 43
    pop     ecx
.next:
    sub     cl, 48
    mov     byte [ebx], cl
    inc     ebx
    jmp     .poploop

judge:
    mov     al, byte [str1]
    add     al, byte [str2]
    cmp     al, 88
    jne     toadd
    cmp     byte [str1], 45
    je      .change
    mov     esi, str1
    mov     edi, str2
    jmp     tosub
.change:
    mov     esi, str2
    mov     edi, str1
    jmp     tosub

toadd:
    mov     esi, str1
    mov     edi, str2
    mov     edx, stres
    call    add
    jmp     addfinish
add:
    pusha
    mov     eax, 0
    mov     ebx, 0
    mov     ch, 0
    mov     byte [edx], 43
    cmp     byte [esi], 43
    je     .addloop
    mov     byte [edx], 45
    ;判断加法循环是否应该结束
.addloop:
    inc     esi
    inc     edi
    inc     edx
    mov     bl, 0
    inc     ch
    cmp     ch, 49
    jg      .finished
    mov     bl, byte [esi]
    mov     cl, byte [edi]
    add     bl, al
    add     bl, cl
    mov     eax, ebx
    push    ebx
    mov     ebx, 10
    push    edx
    mov     edx, 0
    div     ebx
    mov     eax, edx
    pop     edx
    mov     byte [edx], al
    mov     al, 0
    pop     ebx

    cmp     bl, 9
    jle     .addloop
    mov     al, 1
    jmp     .addloop
.finished:
    popa
    ret
tosub:
    mov     edx, stres
    mov     byte [edx], 43
    mov     ebx, 0
    mov     ecx, 0 
    inc     edx
    inc     esi
    inc     edi
    mov     eax, 0
.subloop:
    inc     ah
    cmp     ah, 49
    je      .subfinish
    mov     bl, byte [esi]
    mov     cl, byte [edi]
    sub     bl, cl
    sub     bl, al
    mov     al, 0
    cmp     bl, 0
    jge     .store
    mov     al, 1
    add     bl, 10
.store:
    mov     byte [edx], bl
    inc     edx
    inc     esi
    inc     edi
    jmp     .subloop

.subfinish:
    cmp     al, 1
    jne     addfinish
    mov     eax, 1
    mov     cl, 0
    mov     esi, stres
    inc     esi
.reserve:
    inc     cl
    cmp     cl, 49
    je      .addsign    
    mov     edx, 9
    sub     dl, byte [esi]
    add     edx, eax
    mov     eax, edx
    mov     ebx, 10
    mov     edx, 0
    div     ebx
    mov     byte [esi], dl
    inc     esi
    jmp     .reserve
.addsign:
    mov     byte [stres], 45
addfinish:    

tomul:
    mov     edx, mulres
    mov     byte[mul1], 43
    mov     byte[mul2], 43
    mov     eax, 0
    mov     ebx, 0
    mov     ecx, 0
.mulloop:
    cmp     ch, 20
    jge     .finish
    cmp     cl, 20
    jl     .mul
    inc     ch
    mov     cl, 0
.mul:
    push    edx
    push    ecx
    movzx   eax, cl
    movzx   eax, byte[str1+eax+1]
    push    ebx
    movzx   ebx, ch
    mul     byte[str2+ebx+1]
    pop     ebx
    mov     edx, 0
    mov     ecx,10
    div     ecx
    pop     ecx
    push    ecx
    add     cl, ch
    movzx   ecx, cl
    mov     byte [mul1+ecx+1],dl
    mov     byte [mul1+ecx+1+1],al
    pop     ecx
    mov     esi, mul1
    mov     edi, mul2
    pop     edx
    call    add
    mov     esi, mulres
    mov     edi, mul2
    call    strcpy
    inc     cl
    jmp     .mulloop

.finish:
    jmp     return
strcpy:
    pusha
    mov     eax, 0
.cpyloop:
    cmp     eax, 49
    je      .cpyfinish
    mov     bl, byte[esi+eax]
    mov     byte[edi+eax], bl
    mov     byte[esi+eax], 0
    mov     byte[mul1+eax+1], 0
    inc     eax
    jmp     .cpyloop
.cpyfinish:
    popa
    ret
format:
    pusha
    mov     eax, 1
    mov     ecx, 0
    inc     esi
.pushloop:
    cmp     eax, ebx
    je      .popjudge
    mov     cl, byte[esi+eax-1]
    push    ecx
    inc     eax
    jmp     .pushloop
.popjudge:
    cmp     eax, 1
    je      .pluszero
    pop     ecx
    dec     eax
    cmp     ecx, 0
    je      .popjudge
    jmp     .poploop
.poploop:
    add     ecx, 48
    mov     byte[esi], cl
    dec     eax
    cmp     eax, 0
    je      .matfinish
    pop     ecx

    inc     esi
    jmp     .poploop
.pluszero:
    mov     byte[esi],48
.matfinish:
    popa
    ret

return:
    mov     esi, stres
    mov     ebx, 50
    call    format
    mov     eax, stres
    cmp     byte[eax],43
    jne     .snext
    inc     eax
.snext:
    call    sprint
    call    sprintLF
    mov     esi, mul2
    mov     ebx, 100
    call    format
    mov     al, byte[str1]
    add     al, byte[str2]
    cmp     al, 88
    jne      .print
    mov     byte[mul2], 45
.print:
    mov     eax, mul2
    cmp     byte[eax],43
    jne     .pnext
    inc     eax
.pnext:
    call    sprint
    ;call    sprintLF
    call    quit
;---------------------------
;工具函数
slen:
    push    ebx
    mov     ebx, eax
 
nextchar:
    cmp     byte [eax], 0
    jz      finished
    inc     eax
    jmp     nextchar
 
finished:
    sub     eax, ebx
    pop     ebx
    ret
 
 
 ;------------------------------------------
sprint:
    push    edx
    push    ecx
    push    ebx
    push    eax
    call    slen
    mov     edx, eax
    mov     ecx, [esp]
    mov     ebx, 1
    mov     eax, 4
    int     80h
    pop     eax
    pop     ebx
    pop     ecx
    pop     edx
    ret
 
 

sprintLF: 
    push    eax
    mov     eax, 0AH
    push    eax
    mov     eax, esp
    call    sprint
    pop     eax
    pop     eax
    ret
 
quit:
    mov     ebx, 0
    mov     eax, 1
    int     80h
    ret