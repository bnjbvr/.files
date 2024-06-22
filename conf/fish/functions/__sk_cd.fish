function __sk_cd -d "Change directory"
    set -l commandline (__sk_parse_commandline)
    set -l dir $commandline[1]
    set -l sk_query $commandline[2]

    if not type -q argparse
        # Fallback for fish shell version < 2.7
        function argparse
            functions -e argparse # deletes itself
        end
        if contains -- --hidden $argv; or contains -- -h $argv
            set _flag_hidden "yes"
        end
    end

    # Fish shell version >= v2.7, use argparse
    set -l options  "h/hidden"
    argparse $options -- $argv

    set -l COMMAND

    set -q SKIM_CD_COMMAND
    or set -l SKIM_CD_COMMAND "
    command find -L \$dir -mindepth 1 \\( -path \$dir'*/\\.*' -o -fstype 'sysfs' -o -fstype 'devfs' -o -fstype 'devtmpfs' \\) -prune \
    -o -type d -print 2> /dev/null | sed 's@^\./@@'"

    set -q SKIM_CD_WITH_HIDDEN_COMMAND
    or set -l SKIM_CD_WITH_HIDDEN_COMMAND "
    command find -L \$dir \
    \\( -path '*/\\.git*' -o -fstype 'dev' -o -fstype 'proc' \\) -prune \
    -o -type d -print 2> /dev/null | sed 1d | cut -b3-"

    if set -q _flag_hidden
        set COMMAND $SKIM_CD_WITH_HIDDEN_COMMAND
    else
        set COMMAND $SKIM_CD_COMMAND
    end

    eval "$COMMAND | "(__skcmd)" +m $SKIM_DEFAULT_OPTS $SKIM_CD_OPTS --query \"$sk_query\"" | read -l select

    if not test -z "$select"
        builtin cd "$select"

        # Remove last token from commandline.
        commandline -t ""
    end

    commandline -f repaint
end
