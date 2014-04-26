sudo apt-get install -y vim-gnome zsh build-essential curl redshift git python3-pygments

git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim

ln -s ~/.files/.zshrc ~/.zshrc
ln -s ~/.files/.vimrc ~/.vimrc
ln -s ~/.files/.bundles.vim ~/.bundles.vim
ln -s ~/.files/.hgrc ~/.hgrc
ln -s ~/.files/redshift.conf ~/.config/redshift.conf

mkdir -p ~/.files/bin
git clone https://github.com/nojhan/colout ~/.files/bin/colout
ln -s ~/.files/bin/colout/colout/colout.py ~/.files/colout

# install oh-my-zsh in the .files directory
curl -L http://install.ohmyz.sh | ZSH=~/.files/zsh sh
sudo chsh -s /bin/zsh

~/.files/upvim
