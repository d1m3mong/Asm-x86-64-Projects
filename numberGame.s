.intel_syntax noprefix

.section .rdata
  initialText: .asciz "Guess a number(1-100) \n"

  input: .asciz "%d"
  output: .asciz "You guessed Correct the answer was: %d !\n"

  higherT: .asciz "Your guess: %d is too high! \n"
  lowerT: .asciz "Your guess: %d is too low! \n"

  try: .asciz "Try: %d\n"

  quitT: .asciz "Aborted, the answer was: %d \n"

.data
  guess: .long 0
  secret: .long 0
  tries: .long 0

.extern printf
.extern scanf
.text
.globl main
.extern time
.extern rand
.extern srand

main:
  sub rsp, 40

  xor ecx, ecx

  call time

  mov ecx, eax

  call srand

  call rand

  cdq

  mov ecx, 100

  idiv ecx
  inc edx

  mov DWORD PTR secret[rip], edx

  lea rcx, [rip + initialText]
  call printf
  
 loop_start:
  inc DWORD PTR tries[rip]

  mov edx, DWORD PTR tries[rip]
  lea rcx, [rip + try]

  call printf

  lea rcx, [rip + input]
  lea rdx, [rip + guess]

  call scanf

  mov edx, DWORD PTR guess[rip]
  cmp edx, -1
  je quit

  cmp edx, DWORD PTR secret[rip]

  je end
  jg higher


lower:
  lea rcx, [rip + lowerT]

  call printf

  jmp loop_start

higher:
  lea rcx, [rip + higherT]

  call printf
  jmp loop_start

end:
  lea rcx, [rip + output]

  call printf

  xor eax, eax
  add rsp, 40

  ret
quit:
  lea rcx, [rip + quitT]

  mov edx, DWORD PTR secret[rip]

  call printf

  xor eax, eax
  add rsp, 40 

  ret
