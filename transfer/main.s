.intel_syntax noprefix

.section .rdata
  input: .asciz "%d %c"
  calculation_result: .asciz "%lld"
  end_output: .asciz "\nended!"

.bss
  number: .zero 4
  mode: .zero 1
  result: .zero 8

.text
.globl main
.extern printf
.extern scanf

main:
  push rbx
  sub rsp, 48

  lea rcx, [rip + input]
  lea rdx, [rip + number]
  lea r8, [rip + mode]
  call scanf

  movzx ebx, BYTE PTR [rip + mode]
  cmp bl, 'd'
  jne end

  mov eax, DWORD PTR [rip + number]
  xor r9, r9
  mov r10, 1
  mov r11d, 10

loop_decimal:
  test eax, eax
  jz print_result

  xor edx, edx
  div r11d
  test edx, edx
  jz skip
  add r9, r10
skip:
  shl r10, 1
  jmp loop_decimal

print_result:
  lea rcx, [rip + calculation_result]
  mov rdx, r9
  call printf

end:
  lea rcx, [rip + end_output]
  call printf

  xor eax, eax
  add rsp, 48
  pop rbx
  ret
