all: deps gitdeps vim hg zsh npm watchman crecord tmux
	@echo "Everything has been setup!"

.PHONY: deps gitdeps vim hg npm zsh tmux clean watchman crecord

deps:
	sudo apt-get install -y zsh build-essential autoconf2.13 curl redshift git python3-pygments automake python-dev libnotify-bin
	ln -s ~/.files/conf/redshift.conf ~/.config/redshift.conf || echo "redshift.conf already present"

gitdeps:
	git submodule init
	git submodule update

vim:
	mkdir -p ~/.config/nvim
	mkdir -p ~/.local/share/nvim/backup
	curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	mkdir -p ~/.vim
	ln -s ~/.config/nvim/autoload ~/.vim/autoload || echo "autoload already present"
	ln -s ~/.files/conf/vimrc ~/.config/nvim/init.vim || echo "init.vim already present"
	sudo apt install software-properties-common
	sudo add-apt-repository ppa:neovim-ppa/unstable
	sudo apt update
	sudo apt install neovim

hg:
	(cd ~/.files/private/bin && \
	 wget https://www.mercurial-scm.org/release/mercurial-3.9.2.tar.gz && \
	 tar xvzf mercurial*.tar.gz && \
	 mv mercurial*/ mercurial-dir && \
	 cd mercurial-dir && \
	 rm ../mercurial*.tar.gz && \
	 make local && \
	 cd ../ && \
	 ln -s ./mercurial-dir/hg ./)
	ln -s ~/.files/conf/hgrc ~/.hgrc || echo ".hgrc already present"

zsh:
	ln -s ~/.files/conf/zshrc ~/.zshrc || echo ".zshrc already present"
	sudo chsh -s /bin/zsh ben

tmux:
	ln -s ~/.files/conf/tmux.conf ~/.tmux.conf || echo ".tmux.conf already present"

npm:
	ln -s ~/.files/private/conf/npmrc ~/.npmrc || echo ".npmrc already present"

watchman:
	(cd ~/.files/bin/watchman-dir && ./autogen.sh && ./configure && make -j8)

crecord:
	(cd ~/.files/bin && hg clone https://bitbucket.org/edgimar/crecord)

clean:
	rm -f ~/.config/redshift.conf ~/.vimrc ~/.bundles.vim ~/.hgrc ~/.zshrc ~/.npmrc
	rm -rf ~/.vim/bundle/Vundle.vim
