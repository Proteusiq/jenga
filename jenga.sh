#!/bin/bash

# filename: jenga.sh
# author: @proteusiq

help() {

    cat <<EOF
Usage: ./jenga --python=3.10 [-hrj]
Unhelling Python Environments: install pyenv to manage environements

-h, -help,          --help                  Display help

-p, -python,       --python                 Main Python version default $(3.10)

-r, -runcommands,  --runcommands            Run Commands default $(.bashrc)

-j, -jupyter,      --jupyter                Install a global Jupyter Lab

EOF

}

setup_pyenv() {
    echo "Installing pyenv with global Python ${python} the rc is ${runcommands}"
    echo "Updating & Installing necessary packages"

    sudo apt update -y && sudo apt install -y curl git gcc make openssl libssl-dev libbz2-dev libreadline-dev libsqlite3-dev \
        zlib1g-dev libncursesw5-dev libgdbm-dev libc6-dev zlib1g-dev libsqlite3-dev tk-dev libssl-dev openssl libffi-dev \
        liblzma-dev

    echo "Installing Pyenv"
    # install pyenv
    # curl https://pyenv.run | bash

    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"

    pyenv update && pyenv install ${python} &&

        # set pyenv to .bashrc or .profile
        echo -e '\nexport PYENV_ROOT="$HOME/.pyenv"
    \ncommand -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
    \neval "$(pyenv init -)"' >>${runcommands}

    #  source bashrc
    echo "Setting completed. To complete installation execute >> source ${runcommands}"
}

setup_jupyter() {

    echo "Install Jupyter Lab"
    pyenv virtualenv ${python} jupyter
    pyenv activate jupyter
    python -m pip install --upgrade pip && pip install jupyterlab
    cd ~ && curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
    sudo apt-get install -y nodejs
    node --version
    jupyter labextension install jupyterlab-plotly
    pyenv global ${python} jupyter
}

export python=3.10
export runcommands=$HOME/.bashrc
export jupyter=0

options=$(getopt -l "help,runcommands:,python:,jupyter" -o "hr:p:j" -a -- "$@")

eval set -- "$options"

check_args="true"
run_setup="false"

while true; do
    case "$1" in
    -h | --help)
        help
        exit 0
        ;;
    -r | --runcommands)
        shift
        export runcommands="$HOME/.$1"
        run_setup="true"
        ;;
    -p | --python)
        shift
        export python="$1"
        run_setup="true"
        ;;

    -j | --jupyter)
        export jupyter=1
        ;;
    --)

        shift
        break
        ;;
    esac

    check_args="false"
    shift
done
[[ "$check_args" == "true" ]] && {
    echo "Run: ./jenga.sh --help"
    exit 1
}

[[ "$run_setup" == "true" ]] && { setup_pyenv; }

[[ "$jupyter" == 1 ]] && { setup_jupyter; }

echo $python $runcommands $jupyter
