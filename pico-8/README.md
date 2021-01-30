1. Create roms directory
`mkdir ~/RetroPie/roms/pico8`
Extract roms and gamelist to `~/RetroPie/roms/pico8`

2. Add PICO-8 Emulator
`mkdir /opt/retropie/emulators/pico8`
Extract pico-8.zip to `/opt/retropie/emulators/pico8`

Open permissions for files in `/opt/retropie/emulators/pico8`
`chmod 755 *.*` 

3. Create RetroPie configs:
`mkdir /opt/retropie/configs/pico8`
Copy `emulators.cfg` and `launching.jpg` to `/opt/retropie/configs/pico8/`

1. Add PICO-8 to Emulation Station
Add to `/etc/emulationstation/es_systems.cfg`
`
  <system>
    <name>pico8</name>
    <fullname>PICO-8</fullname>
    <path>/home/pi/RetroPie/roms/pico8</path>
    <extension>.sh .SH .p8 .P8 .png .PNG</extension>
    <command>/opt/retropie/supplementary/runcommand/runcommand.sh 0 _SYS_ pico8 %ROM%</command>
    <platform>pico8</platform>
    <theme>pico8</theme>
  </system>
`

5. Add PICO-8 to the Emulation Station theme:
    https://www.lexaloffle.com/bbs/?tid=3935
    
    Note: here is my own branch of the Pixel theme with PICO-8 added: https://github.com/ryanpconnors/es-theme-pixel/tree/pico8

6. If this is for the Retroflag GPi and the controller mappings are not working, this is a handy tutorial for setting up the SDL2 controller map: https://retropie.org.uk/forum/topic/15577/ppsspp-controller-setup-guide-for-when-nothing-else-works/2 