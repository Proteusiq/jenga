#!/bin/bash

# filename: jenga.sh
# author: @proteusiq

help() {

    cat <<EOF
Usage: ./jenga --python=3.10 [-hrj]
Unhelling Python Managers w/🐍 pyenv and Environments w/🪴 poetry 

-h, -help,          --help                  Display help

-p, -python,       --python                 Main Python version default "3.10"

-r, -runcommands,  --runcommands            Run Commands default "$HOME/.bashrc"

-j, -jupyter,      --jupyter                Install a global Jupyter Lab

EOF

}

setup_build(){
    # Packages to compile Python
    echo "Updating & Installing necessary packages"

    sudo apt update -y && sudo apt install -y curl git gcc make openssl \
                          libssl-dev libbz2-dev libreadline-dev libsqlite3-dev \
                          zlib1g-dev libncursesw5-dev libgdbm-dev libc6-dev \
                          tk-dev libffi-dev liblzma-dev 
}
setup_pyenv() {
    # Installing sets for pyenv that does not depend on Python
    echo "Installing pyenv with global Python ${python} the rc is ${runcommands}"
    echo "Installing Pyenv"
    # install pyenv
    curl https://pyenv.run | bash

    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"

    pyenv update && pyenv install ${python} &&

        # set pyenv to .bashrc or .profile or .zshrc
        echo -e '\nexport PYENV_ROOT="$HOME/.pyenv"
    \ncommand -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
    \neval "$(pyenv init -)"' >>${runcommands}

    #  source .bashrc or .profile or .zshrc
    echo "Setup completed. To complete installation execute >> source ${runcommands}"
}

setup_jupyter() {
    # instructions to install jupyter lab and nodejs
    echo "Install Jupyter Lab & Nodejs used in jupyter extensions"
    pyenv virtualenv ${python} jupyter
    pyenv activate jupyter &&
        python -m pip install --upgrade pip && pip install jupyterlab
    cd ~ && curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
    sudo apt-get install -y nodejs
    jupyter labextension install jupyterlab-plotly
    pyenv global ${python} jupyter
    echo "Installation completed. Node $(node --version) powering Jupyter"
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
        run_setup="pyenv"
        ;;
    -p | --python)
        shift
        export python="$1"
        run_setup="pyenv"
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

# if no arguments echo this message
[[ "$check_args" == "true" ]] && {
    echo "Run: ./jenga.sh --help"
    exit 1
}

# run pyenv installation if true
[[ "$run_setup" == "pyenv" ]] && { setup_build; setup_pyenv; }

# run jupyter installation if flagged
[[ "$jupyter" == 1 ]] && { setup_jupyter; }

echo "completed :dragon:"
