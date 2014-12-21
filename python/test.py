from .brainfuck import generate_bracket_map


def test_generate_bracket_map():
    assert generate_bracket_map("[]") == {0: 1}
    assert generate_bracket_map("[hello]") == {0: 6}
    assert generate_bracket_map("[[]][]") == {0: 3, 1: 2, 4: 5}
    assert generate_bracket_map("[[][[]]]") == {0: 7, 1: 2, 3: 6, 4: 5}
