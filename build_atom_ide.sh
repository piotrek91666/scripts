#!/bin/bash
# Need: apm (atom-editor)

if [ -d "$HOME/.atom" ]; then
    rm -rf $HOME/.atom
fi

if [ -d "$HOME/.cache/Atom" ]; then
    rm -rf $HOME/.cache/Atom
fi

if [ -d "$HOME/.config/Atom" ]; then
    rm -rf $HOME/.config/Atom
fi

apm install linter
apm install linter-gcc
apm install linter-flake8
apm install linter-pep8
apm install language-ini
apm install language-kconfig
apm install autocomplete-python
apm install autocomplete-clang
apm install platformio-ide
apm install platformio-ide-terminal
apm install atom-sync
apm install markdown-writer
