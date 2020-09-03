
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
  rsync -rva ~/playbox-Tweaks/arcade/mame-advmame/playbox/*.rc /opt/retropie/configs/mame-advmame/
  ```

###### Changing the runcommand launching images
Clone the `es-runcommand-splash` repo and change all of the extensions to jpg and copy all the config dir:
```
mkdir ~/runcommand-splash
git clone https://github.com/ehettervik/es-runcommand-splash.git ~/runcommand-splash
find ~/runcommand-splash -depth -name "*.png" -exec sh -c 'mv "$1" "${1%.png}.jpg"' _ {} \;
cp -v -r ~/runcommand-splash/* /opt/retropie/configs/
cp ~/runcommand-splash/megadrive/launching.jpg /opt/retropie/configs/genesis/launching.jpg
```

###### Slideshow/Screensaver Directory
- Screensaver slideshow images directory: `~/.emulationstation/slideshow/image`
```
rm -rf ~/.emulationstation/slideshow/image/
cp ~/playbox/slideshow/image/ ~/.emulationstation/slideshow/image/
```

###### Setup USB Roms
- Doing my own custom setup here after looking at https://discordapp.com/channels/423557415271661569/700046889046900856/728664433534042132. A couple of questions remain for me as far as the editing of the `gamelist.xml` files, and the decision to create `addonusb`, `combined_drives` directories as opposed to just mounting the USB drive at `~/RetroPie`
- Following most of the directions here: https://retropie.org.uk/docs/Running-ROMs-from-a-USB-drive/
1. Run `df` to confirm the USB drive file system. This is usually going to be `/dev/sda1`
2. Run `ls -l /dev/disk/by-uuid/` to get the drive's UUID. ex. `7CEC-1114`
3. Edit `/etc/fstab` and add the following entry (where `7CEC-1114`) is the drive's UUID
  ```
  UUID=B2E4755EE47525AF	/home/pi/RetroPie	ntfs-3g	auto,nofail,user,rw,exec,uid=pi,gid=pi,umask=022	0	2
  ```
- Note: Move music off of USB to `~/RetroPie/music` and tweak directory in `~/.livewire.py`
```
rsync -av ~/RetroPie/music/ /home/pi/
sed -i "s|/home/pi/RetroPie/roms/music|/home/pi/music|g" /home/pi/.livewire.py
sed -i "s|/home/pi/RetroPie/roms/music/|/home/pi/music/|g" /opt/retropie/configs/all/autostart.sh
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
