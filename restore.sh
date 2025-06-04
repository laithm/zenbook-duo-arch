#!/bin/bash

set -e

echo "[+] Starting Zenbook Duo system restore..."

### 1. INSTALL CORE PACKAGES
echo "[+] Installing core packages..."
sudo pacman -Syu --needed - < pkglist.txt

### 2. INSTALL AUR PACKAGES (requires yay or paru)
if ! command -v yay &> /dev/null; then
  echo "[!] yay not found. Install AUR helper manually to continue AUR install."
else
  echo "[+] Installing AUR packages..."
  yay -S --needed - < pkglist-aur.txt
fi

### 3. CONFIG FILES
echo "[+] Restoring configs..."
mkdir -p ~/.config/hypr
cp -r hypr/* ~/.config/hypr/

cp zsh/.zshrc ~/.zshrc

### 4. SCRIPTS
echo "[+] Restoring scripts..."
mkdir -p ~/.local/bin
cp scripts/battery-mode.sh ~/.local/bin/
chmod +x ~/.local/bin/battery-mode.sh

### 5. UDEV RULE
echo "[+] Installing udev rule..."
sudo cp udev/99-low-power.rules /etc/udev/rules.d/
sudo udevadm control --reload

### 6. GRUB CONFIG (OPTIONAL)
if [ -f grub ]; then
  echo "[+] Overwriting /etc/default/grub..."
  sudo cp grub /etc/default/grub
  sudo grub-mkconfig -o /boot/grub/grub.cfg
fi

### 7. SYSTEMD (OPTIONAL)
if [ -f power/battery-profile.service ]; then
  echo "[+] Installing systemd user service..."
  mkdir -p ~/.config/systemd/user/
  cp power/battery-profile.service ~/.config/systemd/user/
  systemctl --user daemon-reexec
  systemctl --user enable battery-profile.service
fi

echo "[✓] Restore complete. Reboot recommended."
