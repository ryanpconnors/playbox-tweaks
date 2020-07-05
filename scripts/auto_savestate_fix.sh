#!/usr/bin/env bash

###########################################
# Auto Save/Load State Config Fix
#
# Sets all auto savestate configs to false
###########################################

CONFIG_DIR='/opt/retropie/configs'

find ${CONFIG_DIR} -type f -name '*.cfg' -print0 | xargs -0 sed -i 's|savestate_auto_save = "true"|savestate_auto_save = "false"|g'
find ${CONFIG_DIR} -type f -name '*.cfg' -print0 | xargs -0 sed -i 's|savestate_auto_load = "true"|savestate_auto_load = "false"|g'
