all: deps gitdeps python redshift tmux vim zsh kitty helix zellij
	@echo "Everything has been set up!"

.PHONY: alacritty clean deps git gitdeps increase-notify npm python redshift rust rustdeps tmux vim zsh kitty betterutils fish

alacritty: rust
	cargo install alacritty
	mkdir -p ~/.config/alacritty
	ln -s ~/.files/conf/alacritty.yml ~/.config/alacritty/ 2> /dev/null || true

clean:
	rm -f ~/.config/redshift.conf ~/.vimrc ~/.bundles.vim ~/.hgrc ~/.zshrc ~/.npmrc
	rm -rf ~/.vim/bundle/Vundle.vim

deps:
	sudo apt-get install -y build-essential curl python3-pygments python-dev pinta ncdu libtool libssl-dev htop fonts-hack-ttf

git:
	sudo pacman -S git lazygit
	mkdir -p ~/.config/lazygit
	ln -s ~/.files/conf/lazygit.yml ~/.config/lazygit/config.yml || echo "lazygit config already present"
	ln -s ~/.files/conf/gitconfig ~/.gitconfig || echo ".gitconfig already present"

gitdeps:
	git submodule init
	git submodule update

increase-inotify:
	sudo cp ~/.files/conf/sysctl_10_inotify.conf /etc/sysctl.d/10-inotify.conf
	sudo sysctl -p --system

kitty:
	sudo pacman -S kitty ttf-firacode-nerd
	mkdir -p ~/.config/kitty/
	ln -s ~/.files/conf/kitty.conf ~/.config/kitty/ || echo "kitty.conf already present"

npm:
	ln -s ~/.files/private/conf/npmrc ~/.npmrc || echo ".npmrc already present"

python:
	curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && python get-pip.py --user && rm get-pip.py

redshift:
	#sudo apt install -y redshift
	mkdir -p ~/.config/redshift
	ln -s ~/.files/conf/redshift.conf ~/.config/redshift/redshift.conf || echo "redshift.conf already present"

rust:
	@(which cargo > /dev/null || curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh)

rustdeps: rust
	@(cargo install ripgrep > /dev/null 2>&1 || (cargo install ripgrep 2>&1 | grep "already" > /dev/null || echo "error when installing ripgrep"))
	@(cargo install fd-find > /dev/null 2>&1 || (cargo install fd-find 2>&1 | grep "already" > /dev/null || echo "error when installing fd-find"))

betterutils:
	# exa: replacement of ls with colors
	# bottom: system information
	# ripgrep: parallel grep with better defaults
	# fd: find with better default search
	# dust: faster du
	# zoxide: replacement for cd/z
	# sd: faster and simpler sed
	# fzf (go, booo): fuzzy find
	sudo pacman -S exa bottom ripgrep fd dust zoxide sd fzf

tmux:
	#sudo apt install -y tmux
	ln -s ~/.files/conf/tmux.conf ~/.tmux.conf || echo ".tmux.conf already present"

vim:
	mkdir -p ~/.config/nvim
	mkdir -p ~/.local/share/nvim/backup
	mkdir -p ~/.vim
	sudo pacman -S ttf-firacode-nerd
	ln -s ~/.config/nvim/autoload ~/.vim/autoload || echo "autoload already present"
	ln -s ~/.files/conf/vimrc ~/.config/nvim/init.vim || echo "init.vim already present"

helix:
	sudo pacman -S helix
	ln -s ~/.files/conf/helix ~/.config/helix || echo "helix config already present"

zellij:
	sudo pacman -S zellij
	ln -s ~/.files/conf/zellij ~/.config/zellij || echo "zellij config already present"

fish:
	sudo pacman -S fish
	ln -s ~/.files/conf/fish ~/.config/ || echo "fish config folder already exists!"
	which fish | sudo tee -a /etc/shells
	sudo chsh -s /usr/sbin/fish ben

zsh:
	#sudo apt install -y zsh
	ln -s ~/.files/conf/zshrc ~/.zshrc || echo ".zshrc already present"
	sudo chsh -s /bin/zsh ben
