sudo apt-get install -y vim-gnome zsh build-essential curl redshift git python3-pygments mercurial

git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim

ln -s ~/.files/conf/zshrc ~/.zshrc
ln -s ~/.files/conf/vimrc ~/.vimrc
ln -s ~/.files/conf/bundles.vim ~/.bundles.vim
ln -s ~/.files/conf/hgrc ~/.hgrc
ln -s ~/.files/conf/redshift.conf ~/.config/redshift.conf

# install oh-my-zsh in the .files directory
curl -L http://install.ohmyz.sh | ZSH=~/.files/zsh sh
sudo chsh -s /bin/zsh

