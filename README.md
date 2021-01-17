
# PlayBox Tweaks

###### Setup SSH key on local machine for password-less SSH
  ```
  ssh-keygen -t rsa -b 2048
  ssh-copy-id -i ~/.ssh/id_rsa pi@<IP_ADDRESS>
  ```

###### Install vim
```
sudo apt-get install vim -y
```

###### Shell Colors
Add the following to `~/.bash_profile`:
```
if [ -f ~/.bashrc ]; then
  . ~/.bashrc
fi
```

Add the following to `~/.bashrc`:
```
# shell colors
PROMPT="%B%F{green}%n%f@%F{magenta}%m%F{blue}:%~$ %f%b"
export LS_COLORS="rs=0:di=01;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:su=37;41:sg=30;43:tw=30;42:ow=34;42:st=37;44:ex=01;32:"
```

###### Setup 8BitDo SN30 Pro and 8BitDo N64 controllers
 ```
 wget https://raw.githubusercontent.com/ryanpconnors/playbox-tweaks/master/gamepads/Pro%20Controller.cfg -P /opt/retropie/configs/all/retroarch-joypads/
 wget https://raw.githubusercontent.com/ryanpconnors/playbox-tweaks/master/gamepads/8Bitdo%20N64%20GamePad.cfg -P /opt/retropie/configs/all/retroarch-joypads/
 ```

###### Update the AdvanceMAME configs for 8BitDo SN30 Pro
  ```
  mkdir ~/playbox-tweaks && git clone https://github.com/ryanpconnors/playbox-tweaks.git ~/playbox-tweaks/
  rsync -rva ~/playbox-tweaks/arcade/*.rc /opt/retropie/configs/mame-advmame/
  ```

###### Changing the runcommand launching images
Either choose `pixel`:
```
cp -r ~/playbox-tweaks/es-runcommand-splash/pixel/* /opt/retropie/configs/
```
or `tronkyjared` variants:
```
cp -r ~/playbox-tweaks/es-runcommand-splash/tronkyjared/* /opt/retropie/configs/
```

###### Slideshow/Screensaver Directory
- Screensaver slideshow images directory: `~/.emulationstation/slideshow/image`
```
rm -rf ~/.emulationstation/slideshow/image/
cp ~/playbox-tweaks/slideshow/image/ ~/.emulationstation/slideshow/image/
```

###### MAME 2003 Plus
- Enable input mapping and D-pad for MAME 2003 Plus
- Replace all roms using `lr-mame2003` to use `lr-mame2003-plus`
```
sed -i 's|mame2003-plus_mame_remapping = "disabled"|mame2003-plus_mame_remapping = "enabled"|g' /opt/retropie/configs/all/retroarch-core-options.cfg
sed -i 's|mame2003-plus_analog = "analog"|mame2003-plus_analog = "digital"|g' /opt/retropie/configs/all/retroarch-core-options.cfg
sed -i 's|"lr-mame2003"|"lr-mame2003-plus"|g' /opt/retropie/configs/all/emulators.cfg
```

###### Background Music Fix
- If you find that a when launching a particular emulator that the menu background music continues to play, you will have to add it the the `emulators` list in `~/.livewire.py`

###### Disable RetroArch On-Screen Notifications
```
sed -i 's|menu_show_load_content = "true"|menu_show_load_content = "false"\nmenu_show_load_content_animation = "false"|g' /opt/retropie/configs/all/retroarch.cfg
```

###### Setup USB Roms
1. Run `df` to confirm the USB drive file system. This is usually going to be `/dev/sda1`
2. Run `ls -l /dev/disk/by-uuid/` to get the drive's UUID. ex. `7CEC-1114`
3. Edit `/etc/fstab` and add the following entry (where `7CEC-1114`) is the drive's UUID
  ```
  UUID=B2E4755EE47525AF	/home/pi/RetroPie	ntfs-3g	auto,nofail,user,rw,exec,uid=pi,gid=pi,umask=022	0	2
  ```
- Note: Move music off of USB to `~/RetroPie/music` and tweak directory in `~/.livewire.py`
```
rsync -av ~/RetroPie/music /home/pi/Music
sed -i "s|/home/pi/RetroPie/roms/music|/home/pi/Music|g" /home/pi/.livewire.py
```

# Remove N64 Custom Textures
```
rm -rf ~/.local/share/mupen64plus/hires_texture/*
```

# Fix for Quake controls
```
sed -i '5 i input_player1_r_y_minus_axis = "+3"' /opt/retropie/configs/ports/quake/retroarch.cfg
sed -i '6 i input_player1_r_y_plus_axis = "-3"' /opt/retropie/configs/ports/quake/retroarch.cfg
```

# Updating RetroPie

If you want to update the firmware, check [HERE](https://www.raspberrypi.org/documentation/hardware/raspberrypi/booteeprom.md)

Run the following while EmulationStation is shutdown:
```
sudo apt-get update -y && sudo apt-get dist-upgrade -y && sudo apt-get autoremove --purge && sudo apt-get clean
```

Reboot and with the external hard drive unplugged and run:
```
sudo ~/RetroPie-Setup/retropie_setup.sh
```
Select "Update RetroPie-Setup script" from the RetroPie-Setup menu

Once the update is complete, select "(P) Manage Packages > (C) Manage core packages > (U) Update all installed core packages" (this will upgrade retroarch, emulationstation, retropiemenu, runcommand)

Remove extraneous directories:
```
rm -rf ~/RetroPie/BIOS ~/RetroPie/roms ~/RetroPie/splashscreens
```

Rename the new RetroPie directory:
```
mv ~/RetroPie ~/RetroPie-NEW
```

Shutdown, plug in the external hardrive and reboot.
```
mv -f ~/RetroPie-NEW/retropiemenu/raspiconfig.rp ~/RetroPie/extras+/.pb-fixes/retropiemenu
mv -f ~/RetroPie-NEW/retropiemenu/rpsetup.rp ~/RetroPie/extras+/.pb-fixes/retropiemenu
mv -f ~/RetroPie-NEW/retropiemenu/configedit.rp ~/RetroPie/extras+/.pb-fixes/retropiemenu/Emulation
mv -f ~/RetroPie-NEW/retropiemenu/retroarch.rp ~/RetroPie/extras+/.pb-fixes/retropiemenu/Emulation
mv -f ~/RetroPie-NEW/retropiemenu/retronetplay.rp ~/RetroPie/extras+/.pb-fixes/retropiemenu/Emulation
mv -f ~/RetroPie-NEW/retropiemenu/bluetooth.rp ~/RetroPie/extras+/.pb-fixes/retropiemenu/Network
mv -f ~/RetroPie-NEW/retropiemenu/showip.rp ~/RetroPie/extras+/.pb-fixes/retropiemenu/Network
mv -f ~/RetroPie-NEW/retropiemenu/wifi.rp ~/RetroPie/extras+/.pb-fixes/retropiemenu/Network
mv -f ~/RetroPie-NEW/retropiemenu/audiosettings.rp ~/RetroPie/extras+/.pb-fixes/retropiemenu/System
mv -f ~/RetroPie-NEW/retropiemenu/filemanager.rp ~/RetroPie/extras+/.pb-fixes/retropiemenu/System
mv -f ~/RetroPie-NEW/retropiemenu/runcommand.rp ~/RetroPie/extras+/.pb-fixes/retropiemenu/System
mv -f ~/RetroPie-NEW/retropiemenu/esthemes.rp ~/RetroPie/extras+/.pb-fixes/retropiemenu/Visuals
mv -f ~/RetroPie-NEW/retropiemenu/splashscreen.rp ~/RetroPie/extras+/.pb-fixes/retropiemenu/Visuals
mv -f ~/RetroPie-NEW/retropiemenu/hurstythemes.sh ~/RetroPie/extras+/.pb-fixes/retropiemenu/Visuals
mv -f ~/RetroPie-NEW/retropiemenu/bezelproject.sh ~/RetroPie/extras+/.pb-fixes/retropiemenu/Visuals
rsync -avh --delete $HOME/RetroPie/extras+/.pb-fixes/retropiemenu/ $HOME/RetroPie/retropiemenu
find $HOME -name "*.rp" ! -name "raspiconfig.rp" ! -name "rpsetup.rp" ! -path "/home/pi/RetroPie/roms/*" | xargs sudo chown root:root
cp $HOME/RetroPie/extras+/.pb-fixes/retropie-gml/gamelist2play.xml /opt/retropie/configs/all/emulationstation/gamelists/retropie/gamelist.xml
sudo rm -rf /etc/emulationstation/themes/carbon/
rm -rf ~/RetroPie-NEW
```
Finally, Run the V-Man updates script
