#include <assert.h>
#include <string.h>
#include "brainfuck.c"

void test_gen_bracket_table(){
    assert(gen_bracket_table("[]", 3)[0] == 1);
    assert(gen_bracket_table("[[]]", 5)[0] == 3);
    assert(gen_bracket_table("[[]]", 5)[1] == 2);
    assert(gen_bracket_table("[[[]]][]", 9)[0] == 5);
    assert(gen_bracket_table("[[[]]][]", 9)[1] == 4);
    assert(gen_bracket_table("[[[]]][]", 9)[2] == 3);
    assert(gen_bracket_table("[[[]]][]", 9)[6] == 7);
}

void test_hello_world(){
    FILE* out = popen("./brainfuck helloworld.bf 2 >&1", "r");
    char output[100];
    fgets(output, 100, out);
    assert(strcmp(output, "Hello World!\n") == 0);
}

void test_rot13(){
    FILE* out = popen("./brainfuck rot13.bf abcdefghijklmnopqrstuvwxyz 2 >&1", "r");
    char output[100];
    fgets(output, 100, out);
    assert(strcmp(output, "nopqrstuvwxyzabcdefghijklm\n") == 0);
}

int main(){
    test_gen_bracket_table();
    test_hello_world();
    test_rot13();
    return 0;
}
