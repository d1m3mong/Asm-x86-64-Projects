.intel_syntax noprefix

.section .rdata
    format: .asciz "Value: %lld\n"

.data
    value: .quad 100

.text
.globl main
main:
    sub rsp, 40

    lea rcx, [rip + format]
    mov rdx, QWORD PTR [rip + value]
    call printf

    xor eax, eax
    add rsp, 40
    ret
