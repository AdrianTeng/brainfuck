#include <stdio.h>
#include "brainfuck.c"

int main(int argc, char **argv){
    if (argc < 2) {
        printf("Error: Missing Brainfuck input files.\n");
        return 1;
    }
    int file_length;
    char* source;
    read_file(&source, &file_length, argv[1]);
    /* int* bracket_table = gen_bracket_table(source, file_length); */
    printf("%d\n", gen_bracket_table("[]", 3)[0]);
    return 0;
}
