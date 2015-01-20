    .global _start
    .text

    # Given a null-terminated string address at %rdi, print the string at stdout
    # and return the length of string

print:

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

    mov     %rax, %rdx              # number of bytes
    mov     %rdi, %rsi              # address of string to output
    mov     $1, %rax                # system call 1 is write
    mov     $1, %rdi                # file handle 1 is stdout
    syscall                         # invoke operating system to do the write

    ret


_start:

    mov     16(%rsp), %rdi          # %rsp = argc, then argv for each word
    call    print

    mov     %rax, %rdi              # string length is pass as exit code
    mov     $60, %rax               # system call 60 is exit
    syscall                         # invoke kernel to exit
