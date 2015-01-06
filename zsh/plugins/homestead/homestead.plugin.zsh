# Adds aliases for vagrant

export HOMESTEAD_DIR="$HOME/.homestead"

alias hsd="(cd $HOMESTEAD_DIR; vagrant down)"
alias hsp="(cd $HOMESTEAD_DIR; vagrant provision)"
alias hss="(cd $HOMESTEAD_DIR; vagrant ssh)"
alias hsu="(cd $HOMESTEAD_DIR; vagrant up)"
