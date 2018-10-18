all: deps gitdeps vim hg zsh npm watchman crecord tmux
	@echo "Everything has been setup!"

.PHONY: deps gitdeps vim hg npm zsh tmux clean watchman crecord

deps:
	sudo apt-get install -y zsh build-essential autoconf2.13 curl redshift git python3-pygments automake python-dev libnotify-bin pinta ncdu libtool libssl-dev xsel
	curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
	python get-pip.py --user && rm get-pip.py
	ln -s ~/.files/conf/redshift.conf ~/.config/redshift.conf || echo "redshift.conf already present"

rustdeps:
	@(cargo install bat > /dev/null 2>&1 || (cargo install bat 2>&1 | grep "already" > /dev/null || echo "error when installing bat"))
	@(cargo install ripgrep > /dev/null 2>&1 || (cargo install ripgrep 2>&1 | grep "already" > /dev/null || echo "error when installing ripgrep"))
	@(cargo install fd-find > /dev/null 2>&1 || (cargo install fd-find 2>&1 | grep "already" > /dev/null || echo "error when installing fd-find"))
	@(cargo install tealdeer > /dev/null 2>&1 || (cargo install 2>&1 | grep "already"> /dev/null || echo "error when installing tealdeer"))

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

git:
	ln -s ~/.files/conf/gitconfig ~/.gitconfig || echo ".gitconfig already present"

hg:
	pip install --user mercurial
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
