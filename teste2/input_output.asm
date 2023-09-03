.386
.model small, stdcall

option casemap :none

include \masm32\include\kernel32.inc
include \masm32\include\masm32.inc
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\masm32.lib

inputMaxSize equ 10

.data?
    val1str db inputMaxSize dup(?)
    val2str db inputMaxSize dup(?)

.data
    inMsg1 db "Digite o primeiro valor: ", 0
    inMsg2 db "Digite o segundo valor: ", 0
    strbuffer db 14 dup(0)

.code
; ponteiro para inicio da string em eax
; resultado armazenado em eax
_toint proc uses ebx ecx edx esi edi     ; uses - call convention
    mov esi, eax                        ; salva ponteiro da string
    xor eax, eax                        ; zera eax
    mov ecx, 10                         ; base

    next:                               ; label para loop
        xor edx, edx                    ; zera edx
        mov dl, byte ptr [esi]          ; pega um byte (char)
        inc esi                         ; move ponteiro para o proximo byte

        cmp dl, '0'                     ; menor que zero?
        jl done                         ; return
        cmp dl, '9'                     ; maior que nove?
        jg done                         ; return
        
        imul eax, ecx                   ; valor atual x 10

        sub dl, '0'                     ; subtrai caracter '0', transformando o caracter em decimal
        add eax, edx                    ; adiciona tal valor ao eax
        jmp next                        ; próxima iteração

    done:                               ; ideal para término
    ret                                 ; return
_toint endp

_tostr proc uses ecx edx edi
; valor armazenado em eax
; ponteiro apontando para resultado em eax
    mov ecx, 10                         ; divisor
    mov edi, offset strbuffer + 14      ;ponteiro para buffer

    next:                               ; label para loop
        dec edi                         ; move ponteiro para próximo byte
        xor edx, edx                    ; zera edx
        div ecx                         ; divide eax por 10, resto é armazenado em edx
        add dl, '0'                     ; adiciona caracter '0' ao resto da divisão, transformando o valor decimal em caracter ASCII
        mov byte ptr [edi], dl          ; move caracter para o buffer
        cmp eax, 0                      ; eax é diferente de 0?
        jne next                        ; próxima iteração

    mov eax, edi                        ; move o ponteiro do buffer para eax
    ret                                 ; return
_tostr endp

_product proc uses ebx ecx
    mov ebx, eax
    xor eax, eax
    mov ecx, edx

    next:
        add eax, ebx

        dec ecx
        jne next
    ret
_product endp

main:
    invoke StdOut, offset inMsg1
    invoke StdIn, offset val1str, inputMaxSize

    invoke StdOut, offset inMsg2
    invoke StdIn, offset val2str, inputMaxSize

    mov eax, offset val1str
    call _toint
    push eax

    mov eax, offset val2str
    call _toint
    
    pop edx
    add eax, edx

    invoke _tostr
    invoke StdOut, eax

    invoke ExitProcess, 0
end main
