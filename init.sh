#!/usr/bin/env bash
set -o errexit
set -o pipefail
set -o nounset

ANTLR=antlr4
if [[ "$OSTYPE" == "darwin"* ]]; then ANTLR=antlr; fi # it's name in brew is without the version number
PYTHON="/usr/bin/env python3"

[ -x "$(command -v $ANTLR)" ] || (echo "Please install antlr from your package manager" && exit 1)

[ -d mediawiki ] || git clone https://github.com/wikimedia/mediawiki --depth=1

[ -f PhpLexerBase.py ] || wget https://raw.githubusercontent.com/antlr/grammars-v4/master/php/Python3/PhpLexerBase.py
[ -f transformGrammar.py ] || wget https://raw.githubusercontent.com/antlr/grammars-v4/master/php/Python3/transformGrammar.py
[ -f PhpLexer.g4 ] || wget https://raw.githubusercontent.com/antlr/grammars-v4/master/php/PhpLexer.g4
[ -f PhpParser.g4 ] || wget https://raw.githubusercontent.com/antlr/grammars-v4/master/php/PhpParser.g4

$PYTHON -m pip install antlr4-python3-runtime
$PYTHON transformGrammar.py
$ANTLR -Dlanguage=Python3 PhpLexer.g4
$ANTLR -Dlanguage=Python3 PhpParser.g4
$PYTHON main.py mediawiki/includes/changetags/ChangeTags.php
