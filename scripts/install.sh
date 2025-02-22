#! /bin/bash

install_packages() {
  packages=("zip" "hyprland" "hyprpaper" "hyprlock" "wofi" "waybar" "ntfs-3g" "tree" "discord" "lazygit" "ufw" "zsh" "unzip" "wget" "stow" "curl" "yazi" "neovim" "eza" "btop" "gamemode" "steam" "mangohud" "zoxide" "fzf" "bat" "kitty" "geany" "geany-plugins" "tmux" "jdk23-openjdk" "docker" "ripgrep" "cargo" "fd" "sddm" "starship" "okular" "vlc" "xclip" "isoimagewriter" "hypridle" "pinta")

  for package in "${packages[@]}"; do
	sudo pacman -S "$package" --noconfirm || { echo "Failed to install $package"; }
  done
}

config_ufw() {
  sudo systemctl start ufw
  sudo ufw default deny incoming
  sudo ufw default allow outgoing
  sudo ufw enable
}

copy_config() {
  cp "$HOME/hyprland/.zshrc" "$HOME/"
  cp -r "$HOME/hyprland/.config" "$HOME/"
  cp -r "$HOME/hyprland/Pictures/Wallpaper/" "$HOME/Pictures/"
}

install_yay(){
  sudo pacman -S --needed git base-devel && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si
}

install_nitch() {
	echo "Installing nitch..."
	wget https://raw.githubusercontent.com/unxsh/nitch/main/setup.sh && sh setup.sh
	echo "Finished!"
}

configure_git() {
  read -r -p "Want to configure git? (y/n): " gitconfig
  if [[ $gitconfig == "y" ]]; then
    read -r -p "What is your GitHub username? " username
    git config --global user.name "$username"
    read -r -p "What is your email address? " useremail
    git config --global user.email "$useremail"
  fi
  
  if [[ $gitconfig == "y" ]]; then
    ssh-keygen -t ed25519 -C "$useremail"
  fi
}


install_themes() {
  sudo cp -a "$HOME/hyprland/Fonts/MesloLGS NF Regular.ttf" "/usr/share/fonts"
  sudo cp -r "$HOME/hyprland/Cursor/Bibata-Modern-Ice" "/usr/share/icons"
  
  echo "Installing Vencord..."

  bash "$HOME/hyprland/Vencord/VencordInstaller.sh"

  cp -r "$HOME/hyprland/Vencord/themes/" "$HOME/.config/Vencord/"

  echo "Done!"

}

add_tmux_tpm() {
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
  mkdir -p ~/.config/tmux/plugins/catppuccin 
  git clone -b v2.1.2 https://github.com/catppuccin/tmux.git ~/.config/tmux/plugins/catppuccin/tmux
}

install_packages
configure_git

config_ufw
install_nitch
copy_config
install_themes
add_tmux_tpm

echo "Creating work directory"
mkdir -p "$HOME/Documents/Github/Projects"
echo "Done"
    
install_yay

echo "Installing packages from yay"
yay -S --noconfirm $(cat "$HOME/hyprland/yay-packages.txt")
echo "Finished!"

cat "$HOME/.ssh/id_ed25519.pub"
