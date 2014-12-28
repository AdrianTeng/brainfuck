#include <stdio.h>
#include <string.h>
#include "brainfuck.c"

int main(int argc, char **argv){
    char* arg = "";
    if (argc < 2) {
        printf("Error: Missing Brainfuck input files.\n");
        return 1;
    } else if (argc > 2) {
        arg = calloc(strlen(argv[2]) + 1, sizeof(char));
        strcpy(arg, argv[2]);
        arg[strlen(argv[2])] = -1;
    }
    int file_length;
    char* source;
    read_file(&source, &file_length, argv[1]);
    int* bracket_table = gen_bracket_table(source, file_length);
    interpret(source, file_length, bracket_table, arg);
    return 0;
}
