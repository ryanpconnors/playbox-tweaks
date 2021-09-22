# Sinden Lightgun Setup

First off you'll want to go and follow all of the instructions here:
https://sindenlightgun.miraheze.org/wiki/Raspberry_Pi_Setup_Guide

## RetroPie Menu
Let's move the Sinden Lightgun setup scripts over to a new folder in the RetroPie menu.
```
mkdir ~/RetroPie/retropiemenu/SindenLightgun
cp ~/RetroPie/roms/ports/SindenLightgun*.sh ~/RetroPie/retropiemenu/SindenLightgun
cp ~/RetroPie/roms/ports/StopSindenLightgun(s).sh ~/RetroPie/retropiemenu/SindenLightgun
rm ~/RetroPie/roms/ports/SindenLightgun*.sh
rm ~/RetroPie/roms/ports/StopSindenLightgun(s).sh
```

Add the following entries to `/opt/retropie/configs/all/emulationstation/gamelists/retropie/gamelist.xml`
```
    	<folder>
		<path>./SindenLightgun</path>
		<name>: Sinden Lightgun</name>
		<desc>Configure Sinden Lightgun(s)</desc>
		<image>./icons/sinden-lightgun.png</image>
	</folder>
    	<game>
		<path>./SindenLightgun/SindenLightgunStartP1.sh</path>
		<name>Start Player 1</name>
		<desc>Start Sinden Lightgun Player 1</desc>
		<image>./icons/sinden-lightgun.png</image>
		<playcount>2</playcount>
		<lastplayed>20210919T234521</lastplayed>
    	</game>
    	<game>
		<path>./SindenLightgun/SindenLightgunStartP2.sh</path>
		<name>Start Player 2</name>
		<desc>Start Sinden Lightgun Player 2</desc>
		<image>./icons/sinden-lightgun.png</image>
		<playcount>2</playcount>
		<lastplayed>20210919T234521</lastplayed>
    	</game>
    	<game>
		<path>./SindenLightgun/SindenLightgunTestP1.sh</path>
		<name>Test Player 1</name>
		<desc>Test Sinden Lightgun Player 1</desc>
		<image>./icons/sinden-lightgun.png</image>
		<playcount>2</playcount>
		<lastplayed>20210919T234521</lastplayed>
	</game>
    	<game>
		<path>./SindenLightgun/SindenLightgunTestP2.sh</path>
		<name>Test Player 2</name>
		<desc>Test Sinden Lightgun Player 2</desc>
		<image>./icons/sinden-lightgun.png</image>
		<playcount>2</playcount>
		<lastplayed>20210919T234521</lastplayed>
	</game>
	<game>
		<path>./StopSindenLightgun(s).sh</path>
		<name>Stop Sinden Lightgun(s)</name>
		<desc>Stop all running Sinden Lightguns</desc>
		<image>./icons/sinden-lightgun.png</image>
		<playcount>2</playcount>
		<lastplayed>20210919T234521</lastplayed>
	</game>
```

Be sure to add an image at `~/RetroPie/retropiemenu/icons/sinden-lightgun.png`

## RetroArch

When setting up the lightgun in Retroarch, you'll want to save the config overrides for the rom itself after changing the overlay and configuring the lightgun.

To override the configs for the rom, go to `Quick Menu > Overrides > Save Game Overrides`.
This will create a new file in `/opt/retropie/configs/all/retroarch/config/${core_name}` called `{rom_name}.cfg`. Example: `/opt/retropie/configs/all/retroarch/config/FCEUmm/Duck Hunt (World).cfg`

Retroarch seems to have some issue saving the mapping for the lightgun trigger. To add this manually open up `/opt/retropie/configs/all/retroarch/config/${core_name}/{rom_name}.cfg` and add the line: `input_player2_gun_trigger_mbtn = "1"` Note that for the `player1` gun, the input value is actually `player2`. I am not 100% sure what this will look like with multiple light guns added.

You will also want to save the core settings per the rom. Go to `Quick Menu > Options > Save Game Options file`. This will create a new file in `/opt/retropie/configs/all/retroarch/config/${core_name}`  called `{rom_name}.opt`.

There is also an options remap file stored in `/opt/retropie/configs/${system_name}/${core_name}` that should be defined for each lightgun rom.

There are some other input configuration values that might come in handy in the future:
https://github.com/clockworkpi/GameShellDocs/blob/master/retroarch.cfg#L765-L808

### SNES Super Scope Setup

Super Scope old works with Sinden Lightgun in SNES9x and NOT SNES9x 2010. So any rom that you will want to configure to use the Super Scope will have to be opened with SNES9x. So add this entry to the bottom of `/opt/retropie/configs/all/emulators.cfg`:

```
snes_BattleClashUSA = "lr-snes9x"
snes_BazookaBlitzkriegUSA = "lr-snes9x"
snes_HuntforRedOctoberTheUSA = "lr-snes9x"
snes_LamborghiniAmericanChallengeUSA = "lr-snes9x"
snes_Lemmings2TheTribesUSA = "lr-snes9x"
snes_MetalCombatFalconsRevengeUSA = "lr-snes9x"
snes_OperationThunderboltUSA = "lr-snes9x"
snes_SuperScope6USA = "lr-snes9x"
snes_T2TheArcadeGameUSA = "lr-snes9x"
snes_TinStarUSA = "lr-snes9x"
snes_XZoneJapanUSA = "lr-snes9x"
snes_YoshisSafariUSA = "lr-snes9x"
```

You will have to add override config `cfg` and options `opt` files for each of the above roms.
You will also have to create remap files for each rom in `/opt/retropie/configs/snes/Snes9x/`

## Genesis and Sega CD

Functions much like the other emulators, files for Genesis and Sega CD are both in `/opt/retropie/configs/all/retroarch/config/Genesis Plus GX` but the remap files for sega cd are located in `/opt/retropie/configs/segacd/Genesis Plus GX` and the remap files for Genesis are located in `/opt/retropie/configs/genesis/Genesis Plus GX`
