all: deps gitdeps vim hg zsh npm tmux watchman crecord redshift python mozilla i3 kalamine lsp
	@echo "Everything has been set up!"

.PHONY: clean deps gitdeps vim hg zsh npm tmux watchman crecord redshift python mozilla increase-notify i3 kalamine

deps:
	sudo apt-get install -y build-essential curl python3-pygments python-dev pinta ncdu libtool libssl-dev htop fonts-hack-ttf

rust:
	@(which cargo > /dev/null || curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh)

rustdeps: rust
	@(cargo install ripgrep > /dev/null 2>&1 || (cargo install ripgrep 2>&1 | grep "already" > /dev/null || echo "error when installing ripgrep"))
	@(cargo install fd-find > /dev/null 2>&1 || (cargo install fd-find 2>&1 | grep "already" > /dev/null || echo "error when installing fd-find"))

alacritty: rust
	cargo install alacritty
	mkdir -p ~/.config/alacritty
	ln -s ~/.files/conf/alacritty.yml ~/.config/alacritty/ 2> /dev/null || true

i3: rust
	cargo install i3wsr
	sudo add-apt-repository ppa:kgilmer/speed-ricer
	sudo add-apt-repository ppa:agornostal/ulauncher
	sudo apt-get update
	sudo apt-get install -y i3-gaps lxappearance suckless-tools pulseaudio-utils playerctl xbacklight compton fonts-font-awesome fonts-powerline udiskie feh ulauncher
	mkdir -p ~/.config/i3/
	mkdir -p ~/.config/udiskie
	@(ln -s ~/.files/conf/i3/config ~/.config/i3/config || true)
	@(ln -s ~/.files/conf/compton.conf ~/.config/compton.conf || true)
	@(ln -s ~/.files/conf/udiskie.yml ~/.config/udiskie/config.yml || true)
	@(ln -s ~/.files/conf/Xresources ~/.Xresources || true)
	@(ln -s ~/.files/conf/ulauncher ~/.config/ulauncher || true)

dunst:
	sudo apt install dunst
	mkdir -p ~/.config/dunst
	@(ln -s ~/.files/conf/dunstrc ~/.config/dunst/ || true)

kalamine:
	git clone https://github.com/fabi1cazenave/kalamine /tmp/kalamine
	sudo pip3 install -e /tmp/kalamine
	sudo xkalamine install ./conf/qwerty-ben.yaml
	setxkbmap us -variant benjamin

python:
	curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && python get-pip.py --user && rm get-pip.py

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
	sudo apt -y install neovim xsel

git:
	sudo apt install -y git
	ln -s ~/.files/conf/gitconfig ~/.gitconfig || echo ".gitconfig already present"

hg:
	pip install --user mercurial
	ln -s ~/.files/conf/hgrc ~/.hgrc || echo ".hgrc already present"

mozilla: python hg vim
	sudo apt install -y autoconf2.13 automake libnotify-bin ccache cmake

zsh:
	sudo apt install -y zsh
	ln -s ~/.files/conf/zshrc ~/.zshrc || echo ".zshrc already present"
	sudo chsh -s /bin/zsh ben

tmux:
	sudo apt install -y tmux
	ln -s ~/.files/conf/tmux.conf ~/.tmux.conf || echo ".tmux.conf already present"

npm:
	ln -s ~/.files/private/conf/npmrc ~/.npmrc || echo ".npmrc already present"

increase-inotify:
	sudo cp ~/.files/conf/sysctl_10_inotify.conf /etc/sysctl.d/10-inotify.conf
	sudo sysctl -p --system

watchman: increase-inotify
	(cd ~/.files/bin/watchman-dir && ./autogen.sh && ./configure --enable-lenient && make -j8)
	sudo mkdir -p /usr/local/var/run/watchman/ben-state
	sudo chown ben:ben /usr/local/var/run/watchman/ben-state

crecord:
	(cd ~/.files/bin && hg clone https://bitbucket.org/edgimar/crecord)

clean:
	rm -f ~/.config/redshift.conf ~/.vimrc ~/.bundles.vim ~/.hgrc ~/.zshrc ~/.npmrc
	rm -rf ~/.vim/bundle/Vundle.vim

redshift:
	sudo apt install -y redshift
	ln -s ~/.files/conf/redshift.conf ~/.config/redshift.conf || echo "redshift.conf already present"

lsp:
	sudo apt install -y ccls
	npm -g i typescript-language-server
