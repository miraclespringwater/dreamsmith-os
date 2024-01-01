set -e

## Make sure the script is not run as an admin
# if [ "$(id -u)" = 0 ]; then
#     echo "##################################"
#     echo "Don't run this as sudo frfr"
#     echo "##################################"
#     exit 1
# fi

# Reset
Color_Off='\033[0m'       # Text Reset

# Regular Colors
Black='\033[0;30m'        # Black
Red='\033[0;31m'          # Red
Green='\033[0;32m'        # Green
Yellow='\033[0;33m'       # Yellow
Blue='\033[0;34m'         # Blue
Purple='\033[0;35m'       # Purple
Cyan='\033[0;36m'         # Cyan
White='\033[0;37m'        # White

# Bold
BBlack='\033[1;30m'       # Black
BRed='\033[1;31m'         # Red
BGreen='\033[1;32m'       # Green
BYellow='\033[1;33m'      # Yellow
BBlue='\033[1;34m'        # Blue
BPurple='\033[1;35m'      # Purple
BCyan='\033[1;36m'        # Cyan
BWhite='\033[1;37m'       # White

# Underline
UBlack='\033[4;30m'       # Black
URed='\033[4;31m'         # Red
UGreen='\033[4;32m'       # Green
UYellow='\033[4;33m'      # Yellow
UBlue='\033[4;34m'        # Blue
UPurple='\033[4;35m'      # Purple
UCyan='\033[4;36m'        # Cyan
UWhite='\033[4;37m'       # White

# Background
On_Black='\033[40m'       # Black
On_Red='\033[41m'         # Red
On_Green='\033[42m'       # Green
On_Yellow='\033[43m'      # Yellow
On_Blue='\033[44m'        # Blue
On_Purple='\033[45m'      # Purple
On_Cyan='\033[46m'        # Cyan
On_White='\033[47m'       # White

# High Intensity
IBlack='\033[0;90m'       # Black
IRed='\033[0;91m'         # Red
IGreen='\033[0;92m'       # Green
IYellow='\033[0;93m'      # Yellow
IBlue='\033[0;94m'        # Blue
IPurple='\033[0;95m'      # Purple
ICyan='\033[0;96m'        # Cyan
IWhite='\033[0;97m'       # White

# Bold High Intensity
BIBlack='\033[1;90m'      # Black
BIRed='\033[1;91m'        # Red
BIGreen='\033[1;92m'      # Green
BIYellow='\033[1;93m'     # Yellow
BIBlue='\033[1;94m'       # Blue
BIPurple='\033[1;95m'     # Purple
BICyan='\033[1;96m'       # Cyan
BIWhite='\033[1;97m'      # White

# High Intensity backgrounds
On_IBlack='\033[0;100m'   # Black
On_IRed='\033[0;101m'     # Red
On_IGreen='\033[0;102m'   # Green
On_IYellow='\033[0;103m'  # Yellow
On_IBlue='\033[0;104m'    # Blue
On_IPurple='\033[0;105m'  # Purple
On_ICyan='\033[0;106m'    # Cyan
On_IWhite='\033[0;107m'   # White

nvim_url='https://github.com/miraclespringwater/neovim-config'
awesome_url='https://github.com/miraclespringwater/awesomewm-config'
dotfiles_url='https://github.com/miraclespringwater/dotfiles'

script_dir="$(cd "$(dirname "$0")" && pwd)"
echo $script_dir

clear;

ecco() {
  echo -e "${2}$1\e[0m"
}

error() {
  clear; printf "ERROR:\\n%s\\n" "$1" >&2; exit 1;
}

yn() {
  read -p "$(echo -e "${1} (y/N):")" && [[ $REPLY =~ ^[Yy]$ ]]
}

repos() {
  echo '# Downloading MSW repositories from GitHub...'

  echo '-> Downloading AwesomeWM configuration repo...'
  # rm -rf awesomewm-config
  git clone $awesome_url
  echo
  echo '-> Downloading neovim configuration repo...'
  # rm -rf neovim-config
  git clone $nvim_url
  echo
  echo '-> Downloading rest of the dotfiles...'
  # rm -rf dotfiles
  git clone $dotfiles_url

  echo "✅ Successfully downloaded repositories!"
}

chaotic () {
  echo '# Seting up chaotic-aur repository!' 


  echo '-> Getting chaotic keys...' 
  sudo pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com &&
  sudo pacman-key --lsign-key 3056513887B78AEB &&
  sudo pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' &&

  echo '-> Installing mirror list...' 
  sudo pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst' &&

  echo "[chaotic-aur]" | sudo tee -a /etc/pacman.conf
  echo "Include = /etc/pacman.d/chaotic-mirrorlist" | sudo tee -a /etc/pacman.conf

  echo '✅ Successfully configured chaotic-aur!' 
}

pkgs () {
  echo '# Installing necessary packages...' 

  yay || {
  sudo pacman -S --needed git base-devel
  git clone https://aur.archlinux.org/yay.git
  cd yay
  makepkg -si
  }
  sudo pacman -S --noconfirm --needed - < $script_dir/pkg-list.txt
  yay -S --noconfirm --needed - < $script_dir/pkg-list.txt

  echo '✅ Successfully installed all packages!' 
}

struct() {
  echo '# Setting up custom $HOME file structure...' 

  mkdir ~/audio &&
  mkdir ~/design &&
  mkdir ~/dev &&
  mv ~/Documents ~/doc || mkdir ~/doc &&
  mv ~/Downloads ~/downloads || mkdir ~/downloads &&
  mkdir ~/lab &&
  mv ~/Music ~/music || mkdir ~/music &&
  mv ~/Pictures ~/pix || mkdir ~/pix &&
  mkdir ~/safe &&
  mv ~/Videos ~/vid || mkdir ~/vid &&
  mkdir ~/vms

  echo '✅ Successfully setup $HOME file structure!' 
}

utils() {
  echo '# Copying custom scripts & utilities...' 

  mkdir ~/.local/bin -p
  cp $script_dir/dotfiles/.local/bin/* ~/.local/bin/ -v
  
  echo '✅ Successfully copied utilities!' 
}

confs() {
  echo '# Copying configurations...' 

  mkdir ~/.config
  cp $script_dir/dotfiles/.config/* -r ~/.config/
  cp $script_dir/dotfiles/lab/* -r ~/lab/
  cp $script_dir/dotfiles/.bashrc ~/.bashrc
  cp $script_dir/dotfiles/.bash_profile ~/.bash_profile
  cp $script_dir/dotfiles/.xinitrc ~/.xinitrc
  cp $script_dir/dotfiles/.gtkrc-2.0 ~/.gtkrc-2.0

  cp $script_dir/awesomewm-config -r ~/.config/awesome
  cp $script_dir/neovim-config -r ~/.config/nvim

  sudo cp $script_dir/etc/{acpi,issues,profile} -r /etc/
  sudo mkdir /etc/X11/xorg.conf.d/ -p
  sudo cp $script_dir/etc/X11/xorg.conf.d/00-keyboard.conf /etc/X11/xorg.conf.d/00-keyboard.conf

  echo '✅ Successfully copied all configurations!' 
}

services() {
  echo '# Configuring services...'

  sudo systemctl start acpid
  sudo systemctl start cronie

  echo '✅ Successfully setup services!'
}

echo "This script is going to make changes to your \$HOME directory,"
echo 'as well as your login prompt, GTK & QT themes, AwesomeWM, cmus,'
echo 'terminal themes, and install a list of necessary packages (a number'
echo 'of which is going to be installed from the chaotic-aur repository).'
echo 'You can get the full list of packages from the "pkg-list.txt" file'
echo 'found in the same directory as this script and modify or add to it'
echo 'as you see fit.'

yn "\nAre you sure you wish to proceed?" || { echo -e "\nExiting script..." ; exit 1; }

yn "\nAre you ABSOLUTELY 100% SURE you wish to proceed?" && echo -e "\nYou chose to proceed." || { echo -e "\nExiting script..." ; exit 1; }

echo -e "\n\n"
awk '/^$/{p=1; next} p' etc/issues
echo -e "\n\n"

repos || error 'Error downloading repos'
chaotic || error 'Error configuring chaotic-aur'
pkgs || error 'Error installing packages'
struct || error 'Error writing custom file structure'
utils || error 'Error copying utilities and custom scripts'
confs || error 'Error copying user configurations'


### Copy custom scripts/utils
# ~/lab/utils
# ~/.local/bin/
###

### Copy configs
# Login screen (copy the banner or whatever)
# Bash setup/starship prompt/autostart x (copy .bashrc)
# Set primary wm in X (copy .xinitrc)
# Window Manager (copy awesome rc)
# Terminal (copy alacritty rc)
# Music player (copy cmus rc)
# Copy rofi configs
# Set gtk and qt themes (gotta figure out where these are stored)
# setup auto-cpufreq
# Neovim config (copy nvim rc)
# Setup tidal cycles
# /etc/acpid/
# optionally setup mail (neomutt)
# optionally change caps to escape
###
