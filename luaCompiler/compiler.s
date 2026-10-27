.intel_syntax noprefix

.section .rdata
  input_path: .asciz "input.lua"
  output_path: .asciz "output.s"
  read_mode: .asciz "r"
  write_mode: .asciz "w"
  open_error: .asciz "Error while opening the File!"
  open_success: .asciz "Successfuly opened the File!"

  number: .asciz " Number: %d"

.data
  has_lookahead: .byte 0
  lookahead_char: .byte 0

  token_buffer: .zero 64
  token_length: .long 0
  token_index: .long 0

.text
.globl main

.extern fopen
.extern fclose
.extern printf
.extern fgetc
.extern fputc

main:
  sub rsp, 56

  lea rcx, [rip + input_path]
  lea rdx, [rip + read_mode]
  call fopen

  test rax, rax
  jz err

  mov [rsp + 32], rax

  xor rax, rax

  lea rcx, [rip + output_path]
  lea rdx, [rip + write_mode]

  call fopen

  test rax, rax
  jz err

  mov [rsp + 40], rax
success:
  xor eax, eax

  lea rcx, [rip + open_success]
  call printf

  xor eax, eax
  jmp loop_start
err:
  xor eax, eax
  lea rcx, [rip + open_error]

  call printf
  xor eax, eax

  add rsp, 56
  ret
end:
  xor eax, eax

  mov rcx, [rsp + 32]
  call fclose

  mov rcx, [rsp + 40]
  call fclose

  xor eax, eax

  add rsp, 56
  ret
loop_start:
  cmp BYTE PTR [rip + has_lookahead], 0
  jne lookahead_check

  mov rcx, [rsp + 32]
  call fgetc

  jmp classify_char
lookahead_check:
  movzx eax, BYTE PTR [rip + lookahead_char]
  mov BYTE PTR [rip + has_lookahead], 0
classify_char:
  cmp eax, -1
  je end

  cmp al, 9
  je tab

  cmp al, 10
  je newline

  cmp al, 32
  je whitespace

  cmp al, '0'
  jb non_digit

  cmp al, '9'
  jbe digit

  cmp al, 'A'
  jb non_digit

  cmp al, 'Z'
  jbe letter

  cmp al, 'a'
  jb non_digit

  cmp al, 'z'
  jbe letter
non_digit:
  mov ecx, eax
  mov rdx, [rsp + 40]

  call fputc

  jmp loop_start
digit:
  mov ecx, eax
  mov rdx, [rsp + 40]

  call fputc

  jmp loop_start
whitespace:
  mov ecx, eax
  mov rdx, [rsp + 40]

  call fputc

  jmp loop_start
tab:
  mov ecx, eax
  mov rdx, [rsp + 40]

  call fputc

  jmp loop_start
newline:
  mov ecx, eax
  mov rdx, [rsp + 40]

  call fputc

  jmp loop_start
letter:
  lea r10, [rip + token_buffer]
  mov BYTE PTR [r10], al
  mov DWORD PTR [rip + token_length], 1
  mov DWORD PTR [rip + token_index], 0

  mov rcx, [rsp + 32]
  call fgetc
  jmp identifier_continue

identifier_continue:
  cmp eax, -1
  je write_token

  cmp al, '0'
  jb check_uppercase

  cmp al, '9'
  jbe append_char
check_lowercase:
  cmp al, 'a'
  jb check_uppercase

  cmp al, 'z'
  jbe append_char
check_uppercase:
  cmp al, 'A'
  jb save

  cmp al, 'Z'
  jbe append_char

  jmp save
save:
  mov BYTE PTR [rip + lookahead_char], al
  mov BYTE PTR [rip + has_lookahead], 1

  jmp write_token
write_token:
  mov eax, DWORD PTR [rip + token_index]
  cmp eax, DWORD PTR [rip + token_length]

  jae token_written

  lea r10, [rip + token_buffer]

  movzx ecx, BYTE PTR [r10 + rax]
  mov rdx, [rsp + 40]
  call fputc

  inc DWORD PTR [rip + token_index]
  jmp write_token
token_written:
  mov DWORD PTR [rip + token_length], 0
  mov DWORD PTR [rip + token_index], 0
  jmp loop_start
append_char:
  mov ecx, DWORD PTR [rip + token_length]
  cmp ecx, 63
  jae save

  lea r10, [rip + token_buffer]
  add r10, rcx

  mov BYTE PTR [r10], al

  inc DWORD PTR [rip + token_length]

  mov rcx, [rsp + 32]
  call fgetc
  jmp identifier_continue
