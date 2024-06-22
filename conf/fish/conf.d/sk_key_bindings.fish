if test "$SKIM_LEGACY_KEYBINDINGS" -eq 1
    bind \ct '__sk_find_file'
    bind \cr '__sk_reverse_isearch'
    bind \ec '__sk_cd'
    bind \eC '__sk_cd --hidden'
    bind \cg '__sk_open'
    bind \co '__sk_open --editor'

    if bind -M insert >/dev/null 2>/dev/null
        bind -M insert \ct '__sk_find_file'
        bind -M insert \cr '__sk_reverse_isearch'
        bind -M insert \ec '__sk_cd'
        bind -M insert \eC '__sk_cd --hidden'
        bind -M insert \cg '__sk_open'
        bind -M insert \co '__sk_open --editor'
    end
else
    bind \co '__sk_find_file'
    bind \cr '__sk_reverse_isearch'
    bind \ec '__sk_cd'
    bind \eC '__sk_cd --hidden'
    bind \eO '__sk_open'
    bind \eo '__sk_open --editor'

    if bind -M insert >/dev/null 2>/dev/null
        bind -M insert \co '__sk_find_file'
        bind -M insert \cr '__sk_reverse_isearch'
        bind -M insert \ec '__sk_cd'
        bind -M insert \eC '__sk_cd --hidden'
        bind -M insert \eO '__sk_open'
        bind -M insert \eo '__sk_open --editor'
    end
end

if set -q SKIM_COMPLETE
    bind \t '__sk_complete'
    if bind -M insert >/dev/null 2>/dev/null
        bind -M insert \t '__sk_complete'
    end
end

function sk_key_bindings_uninstall -e sk_key_bindings_uninstall
    # disabled until we figure out a sensible way to ensure user overrides
    # are not erased
    # set -l _bindings (bind -a | sed -En "s/(')?__sk.*\$//p" | sed 's/bind/bind -e/')
    # for binding in $_bindings
    #     eval $binding
    # end
end
