#!/usr/bin/env bash -euo pipefail

[ -f PhpLexerBase.py ] || wget https://raw.githubusercontent.com/antlr/grammars-v4/master/php/Python3/PhpLexerBase.py
[ -f transformGrammar.py ] || wget https://raw.githubusercontent.com/antlr/grammars-v4/master/php/Python3/transformGrammar.py
[ -f PhpLexer.g4 ] || wget https://raw.githubusercontent.com/antlr/grammars-v4/master/php/PhpLexer.g4
[ -f PhpParser.g4 ] || wget https://raw.githubusercontent.com/antlr/grammars-v4/master/php/PhpParser.g4

PYTHON="/usr/bin/env python3"
$PYTHON -m pip install antlr4-tools

antlr4 -Dlanguage=Python3 PhpLexer.g4
antlr4 -Dlanguage=Python3 PhpParser.g4

$PYTHON -m pip install antlr4-python3-runtime
$PYTHON transformGrammar.py

[ -d mediawiki ] || git clone https://github.com/wikimedia/mediawiki --depth=1
$PYTHON main.py mediawiki/includes/changetags/ChangeTags.php
