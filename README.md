dotfiles
========

Add plugin on vim

git submodule add http://github.com/tpope/vim-fugitive.git bundle/fugitive
git add .
git commit -m "Install Fugitive.vim bundle as a submodule."


Update plugins

git submodule foreach git pull origin master
