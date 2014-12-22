from .brainfuck import generate_bracket_map
import subprocess


def test_generate_bracket_map():
    assert generate_bracket_map("[]") == {0: 1}
    assert generate_bracket_map("[hello]") == {0: 6}
    assert generate_bracket_map("[[]][]") == {0: 3, 1: 2, 4: 5}
    assert generate_bracket_map("[[][[]]]") == {0: 7, 1: 2, 3: 6, 4: 5}


def test_helloworld_parsing():
    p = subprocess.Popen(["python", "brainfuck.py", "../helloworld.bf"],
                         stdout=subprocess.PIPE)
    out = p.communicate()[0]
    assert out == "Hello World!\n"


def test_rot13_parsing():
    p = subprocess.Popen(["python", "brainfuck.py", "../rot13.bf", "abcdefghijklmnopqrstuvwxyz"],
                         stdout=subprocess.PIPE)
    out = p.communicate()[0]
    assert out == "nopqrstuvwxyzabcdefghijklm"
