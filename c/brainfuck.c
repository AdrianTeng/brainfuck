#include <stdio.h>
#include <stdlib.h>


void read_file(char** source, int* file_length, char* file_name) {
    FILE *file = fopen(file_name, "rb");
    fseek(file, 0, SEEK_END);
    *file_length = ftell(file);
    rewind(file);
    *source = (char *) malloc((*file_length + 1) * sizeof(char));
    fread(*source, sizeof(char), *file_length, file);
    fclose(file);
}

int main(int argc, char **argv){
    if (argc < 2) {
        printf("Error: Missing Brainfuck input files.\n");
        return 1;
    }
    int file_length;
    char* source;
    read_file(&source, &file_length, argv[1]);

    return 0;
}
