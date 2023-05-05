function tmux --wraps='TERM=screen-256color-bce /usr/bin/tmux' --description 'alias tmux=TERM=screen-256color-bce /usr/bin/tmux'
  TERM=screen-256color-bce /usr/bin/tmux $argv; 
end
