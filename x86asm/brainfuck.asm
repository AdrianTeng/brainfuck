    .section .text
    .global _start

_start:
    pushq   $len
    pushq   $msg
    call    print

    movq    $0, %rbx        # exit with status 0
    movq    $1, %rax        # linux kernal code for exiting program
    int     $0x80


print:                      # params: str message_to_print, int length of msg

    pushq   %rbp            # store old base pointer
    movq    %rsp, %rbp

    movq    16(%rbp), %rcx  # get str address from stack
    movq    24(%rbp), %rdx  # get str length address from stack
    movq    $1, %rbx
    movq    $4, %rax        # sys_write in linux kernal
    int     $0x80

    movq    %rbp, %rsp      # cleaup stack pointers and return
    popq    %rbp
    ret


    .section .data
msg:
    .ascii "Hello World!\n"
    len =   . - msg
