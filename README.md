
**PlayBox Tweaks**

- Setup SSH key on local machine for password-less SSH
  ```
  ssh-keygen -t rsa -b 2048
  ssh-copy-id -i ~/.ssh/id_rsa pi@10.0.0.0
  ```

- Install vim `sudo apt-get install vim`

- Shell Colors
  - Add the following to `~/.bash_profile`:
    ```
    if [ -f ~/.bashrc ]; then
      . ~/.bashrc
    fi
    ```
  - Add the following to `~/.bashrc`:
    ```
    # shell colors
    PROMPT="%B%F{green}%n%f@%F{magenta}%m%F{blue}:%~$ %f%b"
    export LS_COLORS="rs=0:di=01;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:su=37;41:sg=30;43:tw=30;42:ow=34;42:st=37;44:ex=01;32:"
    ```

- Connect Bluetooth gamepads
  - Press F4 to exit EmulationStation
  - Run `sudo ./RetroPie-Setup/retropie_setup.sh`
  - Open 'Configuration / tools > bluetooth' and follow onscreen instructions

- Setup 8BitDo SN30 Pro and 8BitDo N64 controllers
 ```
 wget https://raw.githubusercontent.com/ryanpconnors/playbox-tweaks/master/gamepads/Pro%20Controller.cfg -P /opt/retropie/configs/all/retroarch-joypads/
 wget https://raw.githubusercontent.com/ryanpconnors/playbox-tweaks/master/gamepads/8Bitdo%20N64%20GamePad.cfg -P /opt/retropie/configs/all/retroarch-joypads/
 ```

- Opening loading screen videos directory: `~/RetroPie/splashscreens`
- Screensaver slideshow images directory: `~/.emulationstation/slideshow/image`

- Update the AdvanceMAME configs from https://github.com/ryanpconnors/playbox-tweaks/tree/master/arcade/ for 8BitDo SN30 Pro
  ```
  mkdir ~/PlayBox-Tweaks && git clone https://github.com/ryanpconnors/palybox-tweaks.git ~/PlayBox-Tweaks/
  rsync -rva ~/PlayBox-Tweaks/arcade/mame-advmame/playbox/*.rc /opt/retropie/configs/mame-advmame/
  ```


- Setup USB Roms
  - Following most of the directions here: https://retropie.org.uk/docs/Running-ROMs-from-a-USB-drive/
  - Run `df` to confirm the USB drive file system. This is usually going to be `/dev/sda1`
  - Run `ls -l /dev/disk/by-uuid/` to get the drive's UUID. ex. `7CEC-1114`
  - Edit `fstab` and add the following entry (where `7CEC-1114`) is the drive's UUID
  ```
  UUID=7CEC-1114  /home/pi/RetroPie vfat  auto,nofail,rw,exec,uid=pi,gid=pi,umask=022 0 2
  ```
  - Note: Move music off of USB to `~/RetroPie/music` and tweak directory in `~/.livewire.py`

- Clone the es-runcommand-splash repo and change all of the extensions to jpg and copy all the config dir:
  ```
  mkdir ~/SplashScreens && git clone https://github.com/ehettervik/es-runcommand-splash.git ~/SplashScreens
  cp -v -r ~/SplashScreens/* /opt/retropie/configs/
  rm /opt/retropie/configs/megadrive/launching-megadrive.jpg && mv /opt/retropie/configs/megadrive/launching-megadrive.png /opt/retropie/configs/megadrive/launching-megadrive.jpg
  mv launching.png launching.jpg
  ```
- The Bezel Project: https://github.com/thebezelproject/BezelProject
  * If you don't want game specific bezels, remove rom specific config files from `/opt/retropie/configs/all/retroarch/config/${CORE_NAME}/${ROM_NAME}`
