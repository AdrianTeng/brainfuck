    .section .data

    .equ    O_RDONLY, 0
    .equ    EOF, 0
    .equ    SEEK_SET, 0
    .equ    SEEK_END, 2


    .equ    SYS_READ, 0
    .equ    SYS_OPEN, 2
    .equ    SYS_LSEEK, 8
    .equ    SYS_BRK, 12

    .global _start
    .section .text


    ##############################################################################
    # Given a null-terminated string address at %rdi, print the string at stdout #
    # and return the length of string                                            #
    ##############################################################################

print:

    call    strlen

    mov     %rax, %rdx              # number of bytes
    mov     %rdi, %rsi              # address of string to output
    mov     $1, %rax                # system call 1 is write
    mov     $1, %rdi                # file handle 1 is stdout
    syscall                         # invoke operating system to do the write

    ret


    ###########################################################################################
    # Given a null-terminated string address at %rdi, return the length of the string at %rax #
    ###########################################################################################

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



    #########################################################################################################
    # Given a null-terminated file name address at %rdi, return an address to copied file content in memory #
    #########################################################################################################

read_file:

    mov     $SYS_OPEN, %rax
    mov     $O_RDONLY, %rsi
    mov     $0, %rdx
    syscall

    mov     %rax, %r15              # Keep file descripter in %r15

_find_file_size:

    mov     %rax, %rdi
    mov     $SYS_LSEEK, %rax
    mov     $0, %rsi
    mov     $SEEK_END, %rdx
    syscall

    mov     %rax, %r14              # Keep file size in %r14

    mov     $SYS_LSEEK, %rax
    mov     $0, %rsi
    mov     $SEEK_SET, %rdx
    syscall                         # Move the file cursor back to start

_alloc_mem:
    mov     %r14, %rax
    call    malloc

    push    %rax                    # Keeping allocated memory location in stack to return later


_read_file_content:

    mov     %r15, %rdi              # File descripter previously stored in %r15
    mov     %rax, %rsi
    mov     $0, %rax
    mov     %r14, %rdx
    syscall


    pop     %rax                    # Return address of copied file content


    #######################################################################################################
    # Given an int stored in %rdi, allocate that amount of memory in heap and return the starting address #
    #######################################################################################################

malloc:

    push    %rdi

    mov     $0, %rdi                # First call of BRK to get address of end of .data
    mov     $SYS_BRK, %rax
    syscall

    pop     %rdi
    push    %rax
    add     %rax, %rdi              # Total mem required = old_size + file size
    mov     $SYS_BRK, %rax          # Second call to do the actual memory allocation
    syscall

    pop     %rax                    # Return original mem end address, which is now the starting
                                    # address of the allocated memory
    ret

_start:

    mov     16(%rsp), %rdi          # %rsp = argc, then argv for each word
    call    print

    mov     16(%rsp), %rdi
    call    read_file

    mov     %rax, %rdi
    call    print

    mov     %rax, %rdi              # string length is pass as exit code
    mov     $60, %rax               # system call 60 is exit
    syscall                         # invoke kernel to exit
