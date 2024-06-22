function __sk_find_file -d "List files and folders"
    set -l commandline (__sk_parse_commandline)
    set -l dir $commandline[1]
    set -l sk_query $commandline[2]

    set -q SKIM_FIND_FILE_COMMAND
    or set -l SKIM_FIND_FILE_COMMAND "
    command find -L \$dir -mindepth 1 \\( -path \$dir'*/\\.*' -o -fstype 'sysfs' -o -fstype 'devfs' -o -fstype 'devtmpfs' \\) -prune \
    -o -type f -print \
    -o -type d -print \
    -o -type l -print 2> /dev/null | sed 's@^\./@@'"

    begin
        eval "$SKIM_FIND_FILE_COMMAND | "(__skcmd) "-m $SKIM_DEFAULT_OPTS $SKIM_FIND_FILE_OPTS --query \"$sk_query\"" | while read -l s; set results $results $s; end
    end

    if test -z "$results"
        commandline -f repaint
        return
    else
        commandline -t ""
    end

    for result in $results
        commandline -it -- (string escape $result)
        commandline -it -- " "
    end
    commandline -f repaint
end
