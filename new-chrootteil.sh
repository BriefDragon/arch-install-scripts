#!/bin/bash
# CHroot Teil 
echo "Wer Windows Dual Booten will, muss nach der Installation os-prober muss den sogenannten Root-Nutzer verwenden mit ’su -’ und mit ’pacman -S os-prober’ os-prober installieren und dann ’grub-mkconfig -o /boot/grub/grub.cfg’ ausführen und kann danach zum User mit ’su BENUTERNAME’ zurückkehren. (Die ’ nicht mitschreiben, danke.)" 
read -p "Was soll der Hostname fuer das Geraet werden?" HOSTNAME
read -p "Welches Standarttastaturlayout? QWERTZ=de-latin1 QWERTY=us " TASTATURLAYOUT
read -p "Soll ein User erstellt werden? (y/N) (Groß ist der Standart-Wert)" CHOISEUSER
    if [ "$CHOISEUSER"==y ]; then #|| "$CHOISEUSER"==Y || "$CHOISEUSER"==yes || "$CHOISEUSER"==Yes ||]; then
        read -p "Wie soll er Heissen?: " USERNAME
        read -p "Was soll sein Passwort werden?: " USERPW
        read -p "Bitte Bestätigen: " USERPW2
            #if ["$USERPW" != "USERPW2"]; then 
                #echo "Die Passwörter stimmen nicht Ueberein. Bitte Script mit neustarten. ((1.) cd /root/own-installer (2.) sh chroot-teil.sh)"
                #exit 1
            #fi
        useradd -m -G wheel -s /bin/bash $USERNAME
        chpasswd <<<""$USERNAME":"$USERPW""
        echo "%wheel ALL=(ALL) ALL" >> /etc/sudoers
    fi
read -p "Wie soll das Root-Passwort lauten? (Root ist das eqivalent zum Windows Admin nur mit noch mehr rechten wegen Konsole und so.): " ROOTPW
    read -p "Bitte Bestätigen" ROOTPW2
        #if [ "$ROOTPW" != "$ROOTPW2" ]; then 
            #echo "Die Passwörter stimmen nicht Ueberein. Bitte Script mit neustarten. ((1.) cd /root/own-installer (2.) sh chroot-teil.sh)"
            #exit 1
        #fi
        read -p "Welches Land bist du Ansässig? (Deutschland=de ; USA/Kanada=us ; Japan=jp)" LC
#config 
#cat /root/own-installer/art-config1.txt
if [ "$LC" == de ]; then
    echo de_DE.UTF-8 UTF-8 >> /etc/locale.gen
    locale-gen
    echo de_DE.UTF-8 >> /etc/locale.conf
    echo KEYMAP="$TASTATURLAYOUT" >> /etc/vconsole.conf
    cp /root/own-installer/mirrorlist /etc/pacman.d/mirrorlist 
fi
if [ "$LC" == us ]; then
    echo en_US.UTF-8 UTF-8 >> /etc/locale.gen
    locale-gen
    echo en_US.UTF.8 >> /etc/locale.conf
    echo KEYMAP="$TASTATURLAYOUT" >> /etc/vconsole.conf
fi
#if [ "$LC" == jp ]; then
    #echo ja_JP.UTF-8 UTF-8 >> /etc/locale.gen
    #WIP because i dont know, how to do the Japanese KEyboard layout thing.
chpasswd <<< "root:"$ROOTPW""
#"Treiber"
pacman -S --noconfirm bluez bluez-utils blueman
if [ "$NVIDIA" == y ]; then #|| "$NVIDIA" == yes || "$NVIDIA" == Y || "$NVIDIA" == Yes || ]; then +
    pacman -S --noconfirm nvidia nvidia-utils 
    #libva-nvidia-driver egl-wayland
    #cp /root/own-installer/mkinitcpio.conf /etc/mkinitcpio.conf
    #echo options nvidia_drm modeset=1 dbdev=1 >> /etc/modprobe.d/nvidia.conf
    #mkinitcpio -P
fi
    systemctl enable sddm
    systemctl enable cups
#Last Config 
#cat /root/own-Installer/art-lastconfig.txt
modprobe btubs
systemctl enable bluetooth.service
systemctl enable NetworkManager
systemctl enable sddm
systemctl enable cups
grub-install 
grub-mkconfig -o /boot/grub/grub.cfg
#ende 
#cat /root/own-installer/art-end.txt
echo "Die Installation ist fertig und du kannst mit ’reboot’ neustarten. Wenn du Hyprland ausgewählt hast, kannst du die Installation der dotfiles nach dem reboot durch 1. ’sh dotinstaller.sh’ starten. (Anmerkung: Work in progress)"
rm /root/own-installer
exit 1