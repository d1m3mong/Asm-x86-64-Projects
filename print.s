.intel_syntax noprefix

.section .rdata
  input: .asciz "%d %d"
  output: .asciz "Ergebnis: %d\n"

.data
  number1: .long 0
  number2: .long 0

.extern printf
.extern scanf
.text
.globl main

main:
  sub rsp, 40
  
  lea rcx, [rip + input]
  lea rdx, [rip + number1]
  lea r8, [rip + number2]

  xor eax, eax
  call scanf

  lea rcx, [rip + output]

  xor eax, eax

  mov edx, DWORD PTR [rip + number1]
  mov r8d, DWORD PTR [rip + number2]

  call add

  mov edx, eax

  xor eax, eax

  call printf

  add rsp, 40
  xor eax, eax

  ret

add:
  mov eax, edx
  add eax, r8d
  ret
