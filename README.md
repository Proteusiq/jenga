# jenga
Unhelling Python Environment: Bash script to easy setup
![pythonhell](pythonhell.png)

Jenga is a Swahili word for `build`. `jenga.sh` automate the steps needed to setup python with `pyenv`. Let's reduce the potential for human error and get your system unhelled faster than ever before.

## Usage
![image](https://user-images.githubusercontent.com/14926709/213185121-783fcc2e-4309-4a7a-9401-fd0bb6c2331e.png)

```sh
curl -L https://raw.githubusercontent.com/Proteusiq/jenga/main/jenga.sh | bash -s _ --help 
```

### Examples
Download `jenga.sh`. Ensure that you understand what the script is doing before running it.

Make `jenga.sh` executable
```bash
chmod +x jenga.sh
```
Getting help
```bash
./jenga.sh --help # get help
```
Install pyenv with latest `python 3.10` with `.bashrc` as run commands file
```bash
./jenga.sh --python=3.10 --runcommands=bashrc
```
For data scients, jupyter lab can be added with `--jupyter`
e.g. use latest `python 3.9`, with `.zshrc` as run commands and install `jupyter lab`
```bash
./jenga.sh --python=3.9 --runcommands=zshrc --jupyter
```

curl -o- https://raw.githubusercontent.com/Proteusiq/jenga/main/jenga.sh --help | bash

# Why?
![XKCD](https://imgs.xkcd.com/comics/python_environment.png)

<br>

### Issues: MacOS and Windows
#### MacOS
gnu-getopt is required and `--runcommands=bash_profile` (I think)
```sh
brew install gnu-getopt && brew link --force gnu-getopt
```

#### Windows
Windows users need [WSL](https://docs.microsoft.com/en-us/windows/wsl/install)
- [ ] Download and Install Ubuntu from the Microsoft Store.
- [ ] Execute code below as Admin & Restart PC (`shutdown /R /T 0`).
```powershell
# Run powershell as Admin
wsl --install
```

## Roadmap 
- [ ] Create uninstall script
- [ ] Add Poetry installation similar to Jupiter's
- [ ] Write examples
- [ ] Start project flow `jenga.sh new <ProjectName>`

## Credit
The bash script templete adopts [command line named parameter bash](https://www.linkedin.com/pulse/command-line-named-parameters-bash-karthik-bhat-k/?published=t) - Karthik Bhat K
