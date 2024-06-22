set -q SKIM_TMUX_HEIGHT; or set -U SKIM_TMUX_HEIGHT "40%"
set -q SKIM_DEFAULT_OPTS; or set -U SKIM_DEFAULT_OPTS "--height $SKIM_TMUX_HEIGHT"
set -q SKIM_LEGACY_KEYBINDINGS; or set -U SKIM_LEGACY_KEYBINDINGS 1
set -q SKIM_PREVIEW_FILE_CMD; or set -U SKIM_PREVIEW_FILE_CMD "head -n 10"
set -q SKIM_PREVIEW_DIR_CMD; or set -U SKIM_PREVIEW_DIR_CMD "ls"

function sk_uninstall -e sk_uninstall
    # disabled until we figure out a sensible way to ensure user overrides
    # are not erased
    # set -l _vars (set | command grep -E "^SKIM.*\$" | command awk '{print $1;}')
    # for var in $_vars
    #     eval (set -e $var)
    # end
end
