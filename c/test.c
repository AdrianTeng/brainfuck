#include <assert.h>
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

int main(){
    test_gen_bracket_table();
    return 0;
}``
