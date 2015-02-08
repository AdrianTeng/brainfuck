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
    mov     %r14, %rdi
    call    malloc

    push    %rax                    # Keeping allocated memory location in stack to return later


_read_file_content:

    mov     %r15, %rdi              # File descripter previously stored in %r15
    mov     %rax, %rsi
    mov     $0, %rax
    mov     %r14, %rdx
    syscall


    pop     %rax                    # Return address of copied file content
    ret


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


    #######################################
    # %rdi: address to the source in heap #
    #######################################

gen_bracket_map:

    # count number of '[' in
    mov     $0, %rax
    mov     $0, %rcx                # %rcx to count number of '['

_count_bracket_loop:

    mov     %rdi, %rbx              # Use %rbx to address the i-th character (i is stored in %rax)
    add     %rax, %rbx
    movzbl  (%rbx), %ebx            # Copy the character we want to %bl and pad with zeros
    cmp     $EOF, %rbx              # end loop if EOF found
    je      _end_count_bracket_loop

    inc     %rax
    cmp     $91, %rbx               # increment %rcx if we have a '[' character (=91 in ascii)
    je      _is_bracket
    jmp     _count_bracket_loop


_is_bracket:
    inc     %rcx
    jmp     _count_bracket_loop

_end_count_bracket_loop:
    push    %rdi                    # Keep the address to the source code in stack for now
    mov     %rcx, %rdi              # We now have number of '[' in %rcx, lets malloc that amount of memory

    call    malloc

    pop     %rdi
    mov     %rax, %r10              # allocaed memory address now in %r10
    mov     %rax, %r11              # Store an extra copy (not modifying) in %r11
    mov     $0, %rax

_build_bracket_map:

    mov     %rdi, %rbx              # Use %rbx to address the i-th character (i is stored in %rax)
    add     %rax, %rbx
    movzbl  (%rbx), %ebx            # Copy the character we want to %bl and pad with zeros
    cmp     $EOF, %rbx              # end loop if EOF found
    je      _end_build_bracket_map

    inc     %rax
    cmp     $91, %rbx               # if we have '[', push the location to stack
    je      _push_bracket
    cmp     $93, %rbx               # if we have ']', pop the matching '[' from stack and store both in heap
    je      _pop_bracket
    jmp     _build_bracket_map

_push_bracket:

    push    %rax
    jmp     _build_bracket_map

_pop_bracket:                       # Given a pair of matched bracket positions (each as 32 bit int), combine
                                    # them as a 64 bits and store in heap (where %r10 is pointing)
                                    # Due to x64 being little-endian, the pair would be other way around in memory

    mov     %eax, %edx              # move the position of ']' into lower 32 bits of %rdx
    pop     %rcx
    shl     $8, %rcx                # now shift the position of '[' to higher 32 bits and combine them into %rdx
    or      %rcx, %rdx

    mov     %rdx, (%r10)
    add     $2, %r10

    jmp     _build_bracket_map

_end_build_bracket_map:

    mov     %r11, %rax
    ret


interpret:

    push    %rdi

    mov     $150, %rdi
    call    malloc

    mov     $0, %rax

    mov     $0, %r15

    # %r15 - data pointer, %rax - instruction pointer, %rdi - source

_interpret_loop:
    mov     %rdi, %rbx              # Use %rbx to address the i-th character (i is stored in %rax)
    add     %rax, %rbx
    movzbl  (%rbx), %ebx            # Copy the character we want to %bl and pad with zeros
    cmp     $43, %rbx               # '+' char
    je      _plus_char
    inc     %rax
    jmp     _strlen_loop

_plus_char:





_start:

    mov     16(%rsp), %rdi          # %rsp = argc, then argv for each word
    call    print

    mov     16(%rsp), %rdi
    call    read_file

    push    %rax                    # File content in heap

    mov     %rax, %rdi
    call    print

    pop     %rdi
    call    gen_bracket_map



    mov     %rax, %rdi
    mov     $60, %rax               # system call 60 is exit
    syscall                         # invoke kernel to exit
