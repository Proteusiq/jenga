#!/bin/bash

# filename: jenga.sh
# author: @proteusiq

help() {

cat << EOF  
Usage: ./jenga --python=3.10 [-hrj]
Unhelling Python Environments: install pyenv and poetry to manage environements

-h, -help,          --help                  Display help

-p, -python,       --python                 Main Python version default `3.10`

-r, -runcommands,  --runcommands            Run Commands default `.bashrc`

-j, -jupyter,      --jupyter                Install a global Jupyter Lab

EOF

}


export python=3.10
export runcommands=bashrc
export jupyter=0


options=$(getopt -l "help,python,runcommands:,jupyter" -o "hpr:j" -a -- "$@")

eval set -- "$options"

check_args="true"

while true
do
case "$1" in
-h|--help) 
    help
    exit 0
    ;;
-p|--python) 
    shift
    export python="$1"
    ;;
-r|--runcommands) 
    shift
    export runcommands="$HOME/.$1"
    ;;
-j|--jupyter)
    export jupyter=1
    ;;
--)
    shift
    break;;
esac
check_args="false"
shift
done
[[ "$check_args" == "true" ]] && { help; exit 1;}

echo $python $runcommands $jupyter
