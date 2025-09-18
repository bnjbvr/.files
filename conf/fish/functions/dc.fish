function dc --wraps=docker-compose --wraps=podman-compose --description 'alias dc=podman-compose'
    # Use "docker compose" if available, otherwise use podman.
    if command -v docker > /dev/null
        docker compose $argv
    else if command -v podman-compose > /dev/null
        podman-compose $argv
    else
        echo "Error: Neither docker-compose nor podman-compose is installed." >&2
        return 1
    end
end
