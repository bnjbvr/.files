# Themes are in ~/.oh-my-zsh/themes/
ZSH_THEME="robbyrussell"

# Normal plugins are in $ZSH/plugins/, custom plugins are in $ZSH/custom/plugins/
plugins=(git mercurial debian battery npm jump sudo)

# Programs to activate
ZSH=$HOME/.files/zsh
source $ZSH/oh-my-zsh.sh
source /home/ben/.nix-profile/etc/profile.d/nix.sh

# Path
export PATH="/home/ben/.files/bin:/home/ben/.files/bin-private:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:~/usr/bin:$PATH"
export MANPATH="/usr/local/man:$MANPATH"

# Aliases
alias op='gnome-open'
alias j='jump'
alias fbn='find ./ -name $1'
alias psg='ps aux | grep $1'

alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

alias upvim='vim -u ~/.bundles.vim +PluginInstall +qall'

# Mozilla build shortcuts
alias m1ke='make -s 2>&1 | colout -t g++'
alias m4ke='make -s -j4 2>&1 | colout -t g++'
alias m8ke='make -s -j8 2>&1 | colout -t g++'
alias m='m8ke'
alias b='./build.sh && m8ke'
alias c='j mozsources && cd .. && autoconf2.13 && cd -2'
alias mb='mv build.sh /tmp/build.sh && (rm -rf ./* .deps) && mv /tmp/build.sh ./ && ./build.sh && m8ke'

# PulseAudio workarounds
alias skipe='PULSE_LATENCY_MSEC=30 skype'
alias vidyo='PULSE_LATENCY_MSEC=30 VidyoDesktop'

export LC_ALL="en_US.UTF-8"

