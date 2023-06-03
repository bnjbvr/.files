function h --wraps=helix --description 'alias h=helix'
  if which helix >/dev/null 2>&1
    helix $argv
  else
    hx $argv
  end
end
