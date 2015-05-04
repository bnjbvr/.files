all: deps gitdeps vim hg zsh watchman
	@echo "Everything has been setup!"

.PHONY: deps gitdeps vim hg npm zsh clean watchman

deps:
	sudo apt-get install -y vim-gnome zsh build-essential curl redshift git python3-pygments mercurial
	ln -s ~/.files/conf/redshift.conf ~/.config/redshift.conf || echo "redshift.conf already present"

gitdeps:
	git submodule init
	git submodule update

vim:
	ln -s ~/.files/conf/vimrc ~/.vimrc || echo ".vimrc already present"
	ln -s ~/.files/conf/vimrc ~/.nvimrc || echo ".nvimrc already present"
	ln -s ~/.vim ~/.nvim || echo ".nvim dir already present"

hg:
	ln -s ~/.files/conf/hgrc ~/.hgrc || echo ".hgrc already present"

zsh:
	ln -s ~/.files/conf/zshrc ~/.zshrc || echo ".zshrc already present"

npm:
	ln -s ~/.files/conf/npmrc ~/.npmrc || echo ".npmrc already present"

watchman:
	(cd ~/.files/bin/watchman-dir && ./autogen.sh && ./configure && make -j8)
	(cd ~/.files/bin/ && hg clone https://bitbucket.org/facebook/hgwatchman && cd hgwatchman && make local)

clean:
	rm -f ~/.config/redshift.conf ~/.vimrc ~/.bundles.vim ~/.hgrc ~/.zshrc ~/.npmrc
	rm -rf ~/.vim/bundle/Vundle.vim
