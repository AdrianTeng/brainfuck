import sys


def interpret_source(source):
    bracket_map = generate_bracket_map(source)
    data_ptr = 0
    heap = [0 for _ in range(100)]
    i = 0
    while i < len(source):
        char = source[i]
        if char == "+":
            heap[data_ptr] += 1
        elif char == "-":
            heap[data_ptr] -= 1
        elif char == ">":
            data_ptr += 1
            if data_ptr >= len(heap):
                heap.extend([0 for _ in range(100)])
        elif char == "<":
            data_ptr -= 1
        elif char == ".":
            sys.stdout.write(chr(heap[data_ptr]))
        elif char == "[":
            if heap[data_ptr] == 0:
                i = bracket_map[i]
        elif char == "]":
            if heap[data_ptr] != 0:
                i = [o for o, c in bracket_map.items() if c == i][0]
        i += 1


def generate_bracket_map(source):
    bracket_map = {}
    open_bracket_stack = []
    for i in range(len(source)):
        if source[i] == "[":
            open_bracket_stack.append(i)
        elif source[i] == "]":
            bracket_map[open_bracket_stack.pop()] = i
    return bracket_map


def open_and_read(path):
    f = open(path)
    return "".join([line for line in f]).replace("\n", "")

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print "Source file as argument required."
        exit(1)
    # For now we assume there is no comment in code and the code is
    # syntactically correct
    source_path = sys.argv[1]
    source = open_and_read(source_path)
    interpret_source(source)
