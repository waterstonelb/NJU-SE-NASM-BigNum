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
 
 
;------------------------------------------
; void sprintLF(String message)
; String printing with line feed function
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

; add:
;     inc     esi
;     inc     edi
;     mov     eax, 0
;     cmp     byte [str1], 43
;     je     .addloop
;     mov     byte [edx], 45
;     inc     edx
;     ;判断加法循环是否应该结束
; .addloop:
;     mov     ebx, 0
;     mov     ecx, 0
;     push    eax
;     mov     eax, esi
;     sub     eax, str1
;     cmp     eax, 49
;     pop     eax
;     je      finish
;     mov     bl, byte [esi]
;     mov     cl, byte [edi]
;     add     bl, al
;     add     bl, cl
;     mov     eax, ebx
;     mov     ecx, 10
;     push    edx
;     mov     edx, 0
;     div     ecx
;     mov     eax, edx
;     pop     edx
;     mov     byte [edx], al
;     inc     esi
;     inc     edi
;     inc     edx
;     mov     eax, 0
;     cmp     bl, 9
;     jl      .addloop
;     mov     eax, 1
;     jmp     .addloop