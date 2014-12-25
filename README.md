Brainfuck interpreter
=====================
[![Build Status](https://travis-ci.org/AdrianTeng/brainfuck.svg?branch=master)](https://travis-ci.org/AdrianTeng/brainfuck)

This repository is a collection of brainfuck interpreters in multiple languages.

Brain... fuck?
--------------
[Brainfuck](http://en.wikipedia.org/wiki/Brainfuck#Brainfuck.27s_formal_.22parent_language.22) is a [Turing-complete](http://en.wikipedia.org/wiki/Turing_completeness) programming language that mimics a [Turing Machine](http://en.wikipedia.org/wiki/Turing_machine). The objective of this language is to making interpreters \& compilers as short as possible. And of course, brain-fucking whoever reads the source code.


Testing Methodology
-------------------
Each interpreter is tested with helloworld \& [ROT13](http://en.wikipedia.org/wiki/ROT13).


Running the interpreter
-----------------------
Python:
Clone the repository and change to the repo's directory.

    python python\brainfuck.py helloworld.bf
    > hello world!

For rot13 you need to put the message you wish to encrypt as argument:

    python python\brainfuck.py rot13.bf encrypt_this!
    > rapelcg_guvf!
