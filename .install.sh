# Append .profile source to .bashrc if it doesnt exist
if [ -f $HOME/bashrc ]; then
  source_bash="source ~/.profile"
  grep -qxF "$source_bash" $HOME/bashrc || echo "$source_bash" >> $HOME/bashrc
fi

# Append .profile source to .zshrc if it doesnt exist
if [ -f $HOME/zshrc ]; then
  source_zsh="[[ -e ~/.profile ]] && emulate sh -c 'source ~/.profile'"
  grep -qxF "$source_zsh" $HOME/zshrc || echo "$source_zsh" >> $HOME/zshrc
fi

# Create local bin folder
mkdir -p $HOME/.local/bin
ln -s $HOME/.local/bin $HOME/Scripts

# Create repo folder
mkdir -p $HOME/Repos
