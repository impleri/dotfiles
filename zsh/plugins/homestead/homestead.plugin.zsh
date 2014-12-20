# Adds aliases for vagrant

export HOMESTEAD_DIR="$HOME/.homestead"

alias hsp="(cd $HOMESTEAD_DIR; vagrant provision)"
alias hsu="(cd $HOMESTEAD_DIR; vagrant up)"
alias hsd="(cd $HOMESTEAD_DIR; vagrant down)"
