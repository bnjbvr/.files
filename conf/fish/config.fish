# Add some directories to PATH
# It's ok to add paths that don't exist, it will just silently fail.
fish_add_path $HOME/.cargo/bin
fish_add_path $HOME/.files/bin
fish_add_path $HOME/.files/private/bin
fish_add_path $HOME/.local/bin
fish_add_path $HOME/go/bin
fish_add_path $HOME/sync/bin

# set up zoxide!
zoxide init fish | source

# set up fzf!
if test -e $HOME/.fzf/shell/key-bindings.fish
    source $HOME/.fzf/shell/key-bindings.fish
    # Configure Ctrl+T (file widget) / Ctrl+R (history) / Alt+C (cd widget)
    fzf_key_bindings
end
