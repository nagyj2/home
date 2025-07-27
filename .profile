# Extract various archive formats
function extract() {
    if [ -f "$1" ]; then
        case "$1" in
            *.tar.bz2) tar xjf "$1" ;;
            *.tar.gz) tar xzf "$1" ;;
            *.zip) unzip "$1" ;;
            *) echo "Unknown archive format" ;;
        esac
    fi
}

# Environment Variables
export LS_COLORS="di=1;34:ex=1;31:"
export EDITOR=vim
export PATH=$HOME/.local/bin:$PATH

# source other files
source $HOME/.profile
