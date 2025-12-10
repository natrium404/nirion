#!/bin/bash

echo -e "\e[1;34m============================= INSTALLATION STARTING =============================\e[0m"
bash -c "$(wget -q https://raw.githubusercontent.com/asifakonjee/openbangla-fcitx5/master/installer.sh -O -)"
# xD yea literally one line... GREAT!!!

echo -e "\n\e[1;34m============================= INSTALLATION COMPLETE =============================\e[0m"
echo -e "\n\e[1;33mDO THIS NOW:\e[0m"
echo -e "\n\e[1;32m1. Reboot or logout and log back in to apply the changes.\e[0m"
echo -e "\n\e[1;33m2. After logging in, open the FCITX5 configuration by running:\e[0m"
echo -e "\n\e[1;36m   fcitx5-config\e[0m"
echo -e "\n\e[1;32m3. In the configuration window, search for 'OpenBangla', select it, and double-click to add it.\e[0m"
echo -e "\n\e[1;32m4. Once added, you can switch input methods using the CTRL+SPACE key.\e[0m"

echo -e "\n\e[1;34m============================= SETUP COMPLETE =============================\e[0m"
echo -e "\n\e[1;36mYou're all set! Enjoy typing in Bangla!\e[0m"
