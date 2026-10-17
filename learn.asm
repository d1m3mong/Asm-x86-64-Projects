default rel

section .data
    value dq 100

section .text
    global main

main:
    lea rax, [value]    ; Adresse von value
    mov rbx, [rax]      ; Wert laden (100)

    xor eax, eax        ; return 0
    ret
