#include <stdio.h>
#include <stdlib.h>
#include <assert.h>


int* gen_bracket_table(char* source, int file_length){
    int *bracket_table = malloc(sizeof(int) * file_length);
    // Worst case scenario: you have a size n array, filled with "[[[[...]]]]"
    int *temp_bracket_stack = malloc((sizeof(int) * file_length)/2);
    int stack_ptr = 0;
    int i;
    for (i=0; i<file_length; i++) {
        switch(source[i]){
        case '[':
            temp_bracket_stack[stack_ptr++] = i;;break;
        case ']':
            bracket_table[temp_bracket_stack[--stack_ptr]] = i; break;
        }
    }
    return bracket_table;
}

void read_file(char** source, int* file_length, char* file_name) {
    FILE *file = fopen(file_name, "rb");
    fseek(file, 0, SEEK_END);
    *file_length = ftell(file);
    rewind(file);
    *source = (char *) malloc((*file_length + 1) * sizeof(char));
    fread(*source, sizeof(char), *file_length, file);
    fclose(file);
}
