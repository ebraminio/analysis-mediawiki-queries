#!/usr/bin/env python3

import sys
from antlr4 import *
from PhpLexer import PhpLexer
from PhpParser import PhpParser

def main(file_name: str):
    input_stream = FileStream(file_name)
    lexer = PhpLexer(input_stream)
    stream = CommonTokenStream(lexer)
    parser = PhpParser(stream)
    tree = parser.htmlDocument() # TODO: Is this the best root?
    print(tree.toStringTree(recog=parser))

if __name__ == '__main__':
    main(sys.argv[1])
