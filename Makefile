all: deps gitdeps vim hg zsh
	@echo "Everything has been setup!"

.PHONY: deps gitdeps vim hg zsh clean

deps:
	sudo apt-get install -y vim-gnome zsh build-essential curl redshift git python3-pygments mercurial
	ln -s ~/.files/conf/redshift.conf ~/.config/redshift.conf || echo "redshift.conf already present"

gitdeps:
	git submodule init
	git submodule update

vim:
	ln -s ~/.files/conf/vimrc ~/.vimrc || echo ".vimrc already present"

hg:
	ln -s ~/.files/conf/hgrc ~/.hgrc || echo ".hgrc already present"

zsh:
	ln -s ~/.files/conf/zshrc ~/.zshrc || echo ".zshrc already present"

clean:
	rm -f ~/.config/redshift.conf ~/.vimrc ~/.bundles.vim ~/.hgrc ~/.zshrc
	rm -rf ~/.vim/bundle/Vundle.vim
