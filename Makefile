all: deps gitdeps vim hg zsh npm watchman crecord tmux
	@echo "Everything has been setup!"

.PHONY: deps gitdeps vim hg npm zsh tmux clean watchman crecord

deps:
	sudo apt-get install -y vim-gnome zsh build-essential autoconf2.13 curl redshift git python3-pygments mercurial
	ln -s ~/.files/conf/redshift.conf ~/.config/redshift.conf || echo "redshift.conf already present"

gitdeps:
	git submodule init
	git submodule update

vim:
	mkdir -p ~/.config/nvim
	mkdir -p ~/.local/share/nvim/backup
	ln -s ~/.files/conf/vimrc ~/.config/nvim/init.vim || echo "init.vim already present"

hg:
	ln -s ~/.files/conf/hgrc ~/.hgrc || echo ".hgrc already present"

zsh:
	ln -s ~/.files/conf/zshrc ~/.zshrc || echo ".zshrc already present"

tmux:
	ln -s ~/.files/conf/tmux.conf ~/.tmux.conf || echo ".tmux.conf already present"

npm:
	ln -s ~/.files/private/conf/npmrc ~/.npmrc || echo ".npmrc already present"

watchman:
	(cd ~/.files/bin/watchman-dir && ./autogen.sh && ./configure && make -j8)
	(cd ~/.files/bin/ && hg clone https://bitbucket.org/facebook/hgwatchman && cd hgwatchman && make local)

crecord:
	(cd ~/.files/bin && hg clone https://bitbucket.org/edgimar/crecord)

clean:
	rm -f ~/.config/redshift.conf ~/.vimrc ~/.bundles.vim ~/.hgrc ~/.zshrc ~/.npmrc
	rm -rf ~/.vim/bundle/Vundle.vim
