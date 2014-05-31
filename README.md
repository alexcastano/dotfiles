dotfiles
========

Add plugin on vim

git submodule add http://github.com/tpope/vim-fugitive.git vim/bundle/fugitive
git add .
git commit -m "Install Fugitive.vim bundle as a submodule."


Update plugins

# new ones
git submodule init
git submodule sync
git submodule update


git submodule foreach git pull origin master

# Remove plugins

1. Remove it from .gitmodules
2. Remove it from .git/config
3. Run git rm --cached <path-to-module></path-to-module>
