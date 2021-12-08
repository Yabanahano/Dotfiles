#!/usr/bin/env sh

echo "[*] >> Copy Neovim Lua Config << [*]"
echo "[*] >> Remove Old Lua Config"
rm -rf $HOME/.config/nvim/lua/
echo "[*] >> Copy New Lua Config"
cp -r $HOME/dotfiles/config/nvim/lua $HOME/.config/nvim/lua
echo "[*] >> Succest << [*]"
