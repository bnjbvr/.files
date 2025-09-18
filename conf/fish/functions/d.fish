function d --wraps=docker --wraps=podman --description 'alias d=docker'
    # Use docker if available, otherwise use podman.
    if command -v docker > /dev/null
        docker $argv
    else if command -v podman > /dev/null
        podman $argv
    else
        echo "Error: Neither docker nor podman is installed." >&2
        return 1
    end
end
