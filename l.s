.intel_syntax noprefix

.text
.globl main

#; 1 addition
#; 2 subtraction
#; 3 multiplication
#; 4 division

main:
  sub rsp, 40

  mov eax, 1

  mov ecx, 10
  mov edx, 20

  cmp eax, 1
  je add

  cmp eax, 2
  je sub

  cmp eax, 3
  je mul

  cmp eax, 4
  je div

  jmp invalid

  end:

  add rsp, 40

  ret
   
add:
  lea eax, [rcx + rdx]
  jmp end 
sub:
  mov eax, ecx
  sub eax, edx
  jmp end
mul:
  mov eax, ecx
  imul eax, edx
  jmp end
div: 
  mov r8d, edx
  mov eax, ecx
  cdq
  idiv r8d
  jmp end

invalid:
  mov eax, 0
  jmp end

