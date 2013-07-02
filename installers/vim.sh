#!/bin/bash -x

if [ -d ~/.vim ]
then
  mv -f ~/.vim ~/dotfiles_old/
fi

cd ..

ln -s vim ~/.vim

if [ -f ~/.vimrc ]; then
  mv ~/.vimrc ~/.vimrc.bak
fi

ln -s ~/.vim/vimrc ~/.vimrc

git submodule update --init
cd -

mkdir ~/.vim_backups
mkdir ~/.vim_tmp
