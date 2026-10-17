.intel_syntax noprefix

.section .rdata
  input: .asciz "%d %d %c"
  output: .asciz "Result: %d\n"
  argn: .asciz "args: %d\n"

.data
  number1: .long 0
  number2: .long 0
  operator: .byte 0

.extern printf
.extern scanf
.text
.globl main


main:
  sub rsp, 40
  
  lea rcx, [rip + input]
  lea rdx, [rip + number1]
  lea r8, [rip + number2]
  lea r9, [rip + operator]

  xor eax, eax

  call scanf

  lea rcx, [rip + argn]
  mov edx, eax

  call printf

  xor eax, eax

  mov al, byte PTR [rip + operator]

  cmp al, '+'
  je add

  cmp al, '-'
  je sub

  cmp al, '*'
  je mul

  cmp al, '/'
  je div

  jmp done


add:
  mov eax, DWORD PTR [rip + number1]
  add eax, DWORD PTR [rip + number2]

  mov edx, eax

  jmp chosen
sub: 
  mov eax, DWORD PTR [rip + number1]
  sub eax, DWORD PTR [rip + number2]

  mov edx, eax

  jmp chosen
mul:
  mov eax, DWORD PTR [rip + number1]
  imul eax, DWORD PTR [rip + number2]
  
  mov edx, eax

  jmp chosen
div:
  mov eax, DWORD PTR [rip + number1]
  cdq
  mov ecx, DWORD PTR [rip + number2]
  idiv ecx

  mov edx, eax

  jmp chosen


chosen:
  lea rcx, [rip + output] 

  call printf

done:
  add rsp, 40
  xor eax, eax
  ret
