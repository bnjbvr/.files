.PHONY: betterutils fish git helix help increase-notify kitty redshift tmux vim wezterm zellij

.DEFAULT_GOAL := help

betterutils: ## Install betters utils
	# lsd: replacement of ls with colors
	# bottom: system information
	# ripgrep: parallel grep with better defaults
	# fd: find with better default search
	# dust: faster du
	# zoxide: replacement for cd/z
	# sd: faster and simpler sed
	# fzf (go, booo): fuzzy find
	# fx: JSON query tool
	sudo pacman -S lsd bottom ripgrep fd dust zoxide sd fzf fx

fish: ## Install the fish shell and set it up.
	sudo pacman -S fish
	ln -s ~/.files/conf/fish ~/.config/ || echo "fish config folder already exists!"
	which fish | sudo tee -a /etc/shells
	sudo chsh -s /usr/sbin/fish ben

git: ## Install git, lazygit and setups the configurations
	sudo pacman -S git lazygit
	mkdir -p ~/.config/lazygit
	ln -s ~/.files/conf/lazygit.yml ~/.config/lazygit/config.yml || echo "lazygit config already present"
	ln -s ~/.files/conf/gitconfig ~/.gitconfig || echo ".gitconfig already present"

jj: ## Install jj and set up its configuration file.
	sudo pacman -S jj
	mkdir -p ~/.config/jj
	ln -s ~/.files/conf/jj.toml ~/.config/jj/config.toml || echo "jj config already present"

helix: ## Install and set up the second-to-best text editor in the world.
	sudo pacman -S helix
	ln -s ~/.files/conf/helix ~/.config/helix || echo "helix config already present"

help: ## Show the help.
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

increase-inotify: ## Increase the inotify count on linux machines.
	sudo cp ~/.files/conf/sysctl_10_inotify.conf /etc/sysctl.d/10-inotify.conf
	sudo sysctl -p --system

kitty: ## Set up Kitty and its configuration file, along with nice fonts.
	sudo pacman -S kitty ttf-firacode-nerd
	mkdir -p ~/.config/kitty/
	ln -s ~/.files/conf/kitty.conf ~/.config/kitty/ || echo "kitty.conf already present"

redshift: ## Install redshift with its configuration file.
	sudo apt install -y redshift || pacman -S redshift
	mkdir -p ~/.config/redshift
	ln -s ~/.files/conf/redshift.conf ~/.config/redshift/redshift.conf || echo "redshift.conf already present"

tmux: ## Install tmux and sets up its configuration file
	sudo apt install -y tmux || sudo pacman -S tmux
	ln -s ~/.files/conf/tmux.conf ~/.tmux.conf || echo ".tmux.conf already present"

vim: ## Set up the best text editor in the world.
	mkdir -p ~/.config/nvim
	mkdir -p ~/.local/share/nvim/backup
	mkdir -p ~/.vim
	sudo pacman -S ttf-firacode-nerd
	ln -s ~/.config/nvim/autoload ~/.vim/autoload || echo "autoload already present"
	ln -s ~/.files/conf/vimrc ~/.config/nvim/init.vim || echo "init.vim already present"

wezterm: ## Install the wez terminal with nice fonts and set it up.
	sudo pacman -S wezterm ttf-firacode-nerd
	ln -s ~/.files/conf/wezterm.lua ~/.wezterm.lua || echo "wezterm conf already exists!"

zellij: ## Install zellij and set it up.
	sudo pacman -S zellij
	ln -s ~/.files/conf/zellij ~/.config/zellij || echo "zellij config already present"
