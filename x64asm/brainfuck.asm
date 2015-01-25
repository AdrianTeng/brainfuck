    .section .data

    .equ    O_RDONLY, 0
    .equ    EOF, 0


    .section .bss
    .equ    BUFFER_SIZE, 1000
    .lcomm  BUFFER_DATA, BUFFER_SIZE


    .global _start
    .section .text

    # Given a null-terminated string address at %rdi, print the string at stdout
    # and return the length of string

print:

    call    strlen

    mov     %rax, %rdx              # number of bytes
    mov     %rdi, %rsi              # address of string to output
    mov     $1, %rax                # system call 1 is write
    mov     $1, %rdi                # file handle 1 is stdout
    syscall                         # invoke operating system to do the write

    ret

    # Given a null-terminated string address at %rdi, return the length of the string at %rax

strlen:
    mov     $0, %rax                # rax as counter to find the null at the end of the string

_strlen_loop:

    mov     %rdi, %rbx              # Use %rbx to address the i-th character (i is stored in %rax)
    add     %rax, %rbx
    movzbl  (%rbx), %ebx            # Copy the character we want to %bl and pad with zeros
    cmp     $0, %rbx                # TODO: Is this slower than "test %bl %bl"?
    je      _strlen_loop_end        # Found a null character
    inc     %rax
    jmp     _strlen_loop

_strlen_loop_end:
    ret


    # Given a null-terminated file name address at %rdi, return a pointer?

read_file:

    mov     $2, %rax
    mov     $O_RDONLY, %rsi
    mov     $0, %rdx
    syscall


read_loop_begin:
    mov     %rax, %rdi              # file descripter is in %rax from previous syscall
    mov     $0, %rax
    mov     $BUFFER_DATA, %rsi
    mov     $BUFFER_SIZE, %rdx
    syscall

    ## cmp     $EOF, $rax
    ## jg


    ret

_start:

    mov     16(%rsp), %rdi          # %rsp = argc, then argv for each word
    call    print

    mov     16(%rsp), %rdi
    call    read_file

    mov     $BUFFER_DATA, %rdi
    call    print

    mov     %rax, %rdi              # string length is pass as exit code
    mov     $60, %rax               # system call 60 is exit
    syscall                         # invoke kernel to exit
