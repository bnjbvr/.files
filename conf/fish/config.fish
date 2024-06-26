# Get rid of the fish greeting.
set fish_greeting

# Add some directories to PATH
# It's ok to add paths that don't exist, it will just silently fail.
fish_add_path $HOME/.cargo/bin
fish_add_path $HOME/.files/bin
fish_add_path $HOME/.files/private/bin
fish_add_path $HOME/.local/bin
fish_add_path $HOME/go/bin
fish_add_path $HOME/sync/bin
fish_add_path /opt/homebrew/bin

# Only for interactive prompts,
if status is-interactive
    # set up zoxide!
    zoxide init fish | source

    # set up fzf!
    if test -e /usr/share/fish/vendor_functions.d/fzf_key_bindings.fish
        source /usr/share/fish/vendor_functions.d/fzf_key_bindings.fish
        # Configure Ctrl+T (file widget) / Ctrl+R (history) / Alt+C (cd widget)
        fzf_key_bindings
    end
end

# set up gnome-keyring as the ssh-agent
if test -e $XDG_RUNTIME_DIR/gcr/ssh
    set -gx SSH_AUTH_SOCK "$XDG_RUNTIME_DIR/gcr/ssh"
end
