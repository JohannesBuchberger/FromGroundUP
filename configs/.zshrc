# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

ZSH_THEME=powerlevel10k/powerlevel10k
POWERLEVEL9K_MODE="awesome-patched"

plugins=(
git
docker
zsh-autosuggestions
colored-man-pages
thefuck
tmux
mvn
docker
zsh-z
zsh-syntax-highlighting
)

# Environment Variables
export JAVA_HOME=/lib/jvm/java-8-openjdk-amd64
export POSTGRES_BACKUP_DIR=/backups/dbBackups/postgresBackups/
export GIT_REPO=/home/$USER/workspace/git
# Environment Variables - Others
export LC=ALL="en_US.UTF-8" ## Language Encoding is us-english utf-8

# all alias
alias sudo='sudo '
alias zip='gzip -9'¬
alias random='cat /dev/random | base64'¬
alias copy='xclip -selection clipboard'¬
# alias mountEdison='sudo mount -t cifs -o username=jbu //fileshare/share/exentra_share ~/edison'¬

# Sourcing of external files
REPO=$GIT_REPO/FromGroundUP
source ~/.oh-my-zsh/oh-my-zsh.sh
source $REPO/scripts/bash_functions.sh
source $REPO/scripts/dockeralias.sh
source $REPO/scripts/postgresalias.sh

# Plugin Configuration
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh # To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
eval $(thefuck --alias) # eval ...  is the configuration for the "fuck" plugin
