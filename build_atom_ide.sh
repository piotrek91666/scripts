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

apm install atom-sync
apm install autocomplete-clang
apm install build
apm install busy
apm install git-plus
apm install language-ini
apm install linter
apm install linter-gcc
apm install markdown-writer
apm install platformio-ide
apm install platformio-ide-terminal
apm install script
apm install tool-bar
