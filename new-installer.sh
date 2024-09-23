#!bin/bash 
cat ~/Installer-Scripts/own-installer/art-input.txt
echo
#Partition
lsblk
read -p "Bitte gebe deine Root-Partition ein wie im folgenden Beispiel (z.b. /dev/sda3). Das Kannst du mit der liste über dir herrauslesen. Sei dir bitte sicher, dass es richtig ist und notier dir auch ruhig die anderen Partitionen.: " Haupt
    mkfs.ext4 "$Haupt"
    mount "$Haupt" /mnt 
# Swap 
read -p "Bitte Swap-partition in dem Schemata von eben eingeben.: " Tausch
    mkswap "$Tausch"
    swapon "$Tausch"
# Boot
read -p "Bitte jetzt als letztes die Boot Partition auch im selben Schema.: " Start
    mkfs.fat -F 32 "$Start"
    mkdir -p /mnt/boot/efi
    mount "$Start" /mnt/boot/efi
# End-Partition thing
# Anfang Programme
read -p "Welchen Text Editor willst du haben?: " text
read -p "von Wem wurde deine CPU Hergestellt? amd oder intet?: " cpu
read -p "Welchen Terminal-emulator(Also der Weg um das Terminal in einer DE/WM umgebung zu nutzen) moechtest du haben? konsole, alacritty oder was anderes (dann bitte pkg-name angeben)?: " terminal
if [[$WMDE == WM]]
then
    read -p "Welchen GPU Hersteller nutzt du?: " gpu
    if [[$gpu == nvidia]] 
    then 
        pacstrap -K /mnt base linux linux-firmware grub efibootmgr networkmanager neofetch sof-firmware base-devel git sudo $text "$cpu"-ucode $terminal firefox dolphin sddm plasma system-config-printer cups cups-pdf nvidia nvidia-utils 
        echo "MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)" >> /mnt/etc/mkinitcpio.conf
        echo "options nvidia_drm modeset=1 fbdev=1" >> /mnt/etc/modprobe.d/nvidia.conf
        mkinitcpio -P 
    elif [[$gpu == amd]]
    then 
        pacstrap -K /mnt base linux linux-firmware grub efibootmgr networkmanager neofetch sof-firmware base-devel git sudo $text "$cpu"-ucode $terminal firefox dolphin sddm plasma system-config-printer cups cups-pdf mesa vulkan-radeon 
    elif [[$gpu == intel]]
        pacstrap -K /mnt base linux linux-firmware grub efibootmgr networkmanager neofetch sof-firmware base-devel git sudo $text "$cpu"-ucode $terminal firefox dolphin sddm plasma system-config-printer cups cups-pdf mesa intel-vulkan 
    then 
    fi
elif [[$WMDE == WM]] 
then
    read -p "Welchen GPU Hersteller nutzt du?: " gpu
    if [[$gpu == nvidia]] 
    then 
        pacstrap -K /mnt base linux linux-firmware grub efibootmgr networkmanager neofetch sof-firmware base-devel git sudo $text "$cpu"-ucode $terminal firefox dolphin hyprland hyprpaper waybar nvidia nvidia-utils 
        echo "MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)" >> /mnt/etc/mkinitcpio.conf
        echo "options nvidia_drm modeset=1 fbdev=1" >> /mnt/etc/modprobe.d/nvidia.conf
        mkinitcpio -P 
    elif [[$gpu == amd]]
    then 
        pacstrap -K /mnt base linux linux-firmware grub efibootmgr networkmanager neofetch sof-firmware base-devel git sudo $text "$cpu"-ucode $terminal firefox dolphin hyprland hyprpaper waybar system-config-printer cups cups-pdf mesa vulkan-radeon 
    elif [[$gpu == intel]]
        pacstrap -K /mnt base linux linux-firmware grub efibootmgr networkmanager neofetch sof-firmware base-devel git sudo $text "$cpu"-ucode $terminal firefox dolphin hyprland hyprpaper waybar system-config-printer cups cups-pdf mesa intel-vulkan 
    then 
    fi
    #Abfrage Dotfiles (WIP)
fi 