##
# Use sk as fish completion widget.
#
#
# When SKIM_COMPLETE variable is set, sk is used as completion
# widget for the fish shell by binding the TAB key.
#
# SKIM_COMPLETE can have some special numeric values:
#
#   `set SKIM_COMPLETE 0` basic widget accepts with TAB key
#   `set SKIM_COMPLETE 1` extends 0 with candidate preview window
#   `set SKIM_COMPLETE 2` same as 1 but TAB walks on candidates
#   `set SKIM_COMPLETE 3` multi TAB selection, RETURN accepts selected ones.
#
# Any other value of SKIM_COMPLETE is given directly as options to sk.
#
# If you prefer to set more advanced options, take a look at the
# `__sk_complete_opts` function and override that in your environment.


# modified from https://github.com/junegunn/sk/wiki/Examples-(fish)#completion
function __sk_complete -d 'sk completion and print selection back to commandline'
    # As of 2.6, fish's "complete" function does not understand
    # subcommands. Instead, we use the same hack as __fish_complete_subcommand and
    # extract the subcommand manually.
    set -l cmd (commandline -co) (commandline -ct)

    switch $cmd[1]
        case env sudo
            for i in (seq 2 (count $cmd))
                switch $cmd[$i]
                    case '-*'
                    case '*=*'
                    case '*'
                        set cmd $cmd[$i..-1]
                        break
                end
            end
    end

    set -l cmd_lastw $cmd[-1]
    set cmd (string join -- ' ' $cmd)

    set -l initial_query ''
    test -n "$cmd_lastw"; and set initial_query --query="$cmd_lastw"

    set -l complist (complete -C$cmd)
    set -l result

    # do nothing if there is nothing to select from
    test -z "$complist"; and return

    set -l compwc (echo $complist | wc -w)
    if test $compwc -eq 1
        # if there is only one option dont open sk
        set result "$complist"
    else

        set -l query
        string join -- \n $complist \
        | eval (__skcmd) (string escape --no-quoted -- $initial_query) --print-query (__sk_complete_opts) \
        | cut -f1 \
        | while read -l r
            # first line is the user entered query
            if test -z "$query"
                set query $r
            # rest of lines are selected candidates
            else
                set result $result $r
            end
          end

        # exit if user canceled
        if test -z "$query" ;and test -z "$result"
            commandline -f repaint
            return
        end

        # if user accepted but no candidate matches, use the input as result
        if test -z "$result"
            set result $query
        end
    end

    set prefix (string sub -s 1 -l 1 -- (commandline -t))
    for i in (seq (count $result))
        set -l r $result[$i]
        switch $prefix
            case "'"
                commandline -t -- (string escape -- $r)
            case '"'
                if string match '*"*' -- $r >/dev/null
                    commandline -t --  (string escape -- $r)
                else
                    commandline -t -- '"'$r'"'
                end
            case '~'
                commandline -t -- (string sub -s 2 (string escape -n -- $r))
            case '*'
                commandline -t -- $r
        end
        [ $i -lt (count $result) ]; and commandline -i ' '
    end

    commandline -f repaint
end

function __sk_complete_opts_common
    if set -q SKIM_DEFAULT_OPTS
        echo $SKIM_DEFAULT_OPTS
    end
    echo --cycle --reverse --inline-info
end

function __sk_complete_opts_tab_accepts
    echo --bind tab:accept,btab:cancel
end

function __sk_complete_opts_tab_walks
    echo --bind tab:down,btab:up
end

function __sk_complete_opts_preview
    set -l file (status -f)
    echo --with-nth=1 --preview-window=right:wrap --preview="fish\ '$file'\ __sk_complete_preview\ '{1}'\ '{2..}'"
end

test "$argv[1]" = "__sk_complete_preview"; and __sk_complete_preview $argv[2..3]

function __sk_complete_opts_0 -d 'basic single selection with tab accept'
    __sk_complete_opts_common
    echo --no-multi
    __sk_complete_opts_tab_accepts
end

function __sk_complete_opts_1 -d 'single selection with preview and tab accept'
    __sk_complete_opts_0
    __sk_complete_opts_preview
end

function __sk_complete_opts_2 -d 'single selection with preview and tab walks'
    __sk_complete_opts_1
    __sk_complete_opts_tab_walks
end

function __sk_complete_opts_3 -d 'multi selection with preview'
    __sk_complete_opts_common
    echo --multi
    __sk_complete_opts_preview
end

function __sk_complete_opts -d 'sk options for fish tab completion'
    switch $SKIM_COMPLETE
        case 0
            __sk_complete_opts_0
        case 1
            __sk_complete_opts_1
        case 2
            __sk_complete_opts_2
        case 3
            __sk_complete_opts_3
        case '*'
            echo $SKIM_COMPLETE
    end
    if set -q SKIM_COMPLETE_OPTS
        echo $SKIM_COMPLETE_OPTS
    end
end
