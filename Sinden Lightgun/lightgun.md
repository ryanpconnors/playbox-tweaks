# Sinden Lightgun Setup

First off you'll want to go and follow all of the instructions here:
https://sindenlightgun.miraheze.org/wiki/Raspberry_Pi_Setup_Guide

When setting up the lightgun in Retroarch, you'll want to save the config overrides for the rom itself after changing the overlay and configuring the lightgun.

To override the configs for the rom, go to `Quick Menu > Overrides > Save Game Overrides`.
This will create a new file in `/opt/retropie/configs/all/retroarch/config/${core_name}` called `{rom_name}.cfg`. Example: `/opt/retropie/configs/all/retroarch/config/FCEUmm/Duck Hunt (World).cfg`

Retroarch seems to have some issue saving the mapping for the lightgun trigger. To add this manually open up `/opt/retropie/configs/all/retroarch/config/${core_name}/{rom_name}.cfg` and add the line: `input_player2_gun_trigger_mbtn = "1"` Note that for the `player1` gun, the input value is actually `player2`. I am not 100% sure what this will look like with multiple light guns added.

You will also want to save the core settings per the rom. Go to `Quick Menu > Options > Save Game Options file`. This will create a new file in `/opt/retropie/configs/all/retroarch/config/${core_name}`  called `{rom_name}.opt`.

There are some other input configuration values that might come in handy in the future:
```
input_player1_gun_trigger_mbtn = "2"
input_player1_gun_offscreen_shot_mbtn = "nul"
input_player1_gun_aux_a = "nul"
input_player1_gun_aux_a_mbtn = "1"
input_player1_gun_aux_b = "space"
```