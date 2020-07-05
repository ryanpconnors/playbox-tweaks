#!/usr/bin/env bash

################################################################################
# RPC80 SaveFile Script                                                        #
################################################################################
# Author: RPC80                                                                #
# Date: 2018.05.11                                                             #
################################################################################
# Purpose: Creates a save directory at ~/RetroPie/saves                        #
# and configures all retroarch emulators with their own config files           #
# to store savefiles at ~/RetroPie/saves/{system_name}                         #
# and savestate files at ~/Retropie/saves/{system_name}/states                 #
################################################################################

CONFIGS_DIR=/opt/retropie/configs
CONFIG_FILENAME=retroarch.cfg
SAVES_DIR=~/RetroPie/saves

SAVE_FILE_CONFIG="savefile_directory = \"~/RetroPie/saves"
SAVE_STATE_CONFIG="savestate_directory = \"~/RetroPie/saves"

echo "
  ____  ____   ____ ___   ___
 |  _ \|  _ \ / ___( _ ) / _ \\
 | |_) | |_) | |   / _ \| | | |
 |  _ <|  __/| |__| (_) | |_| |
 |_| \_\_|    \____\___/ \___/

"

# Loop through the configs directory
for d in ${CONFIGS_DIR}//*; do

    # Get the system/emulator name
    system_name=${d##*/}

    # Skip over the `all` config
    if [[ ${system_name} = 'all' ]]; then
      echo "Skipping 'all' config"
      continue
    fi

    echo "Checking System Configs for '${system_name}' ..."
    config_file=${CONFIGS_DIR}/${system_name}/${CONFIG_FILENAME}

    if [[ -f ${config_file} ]]; then
      echo "Found config file: ${config_file}"
    else
      echo "No config file found for ${system_name}"
      continue
    fi

    # Create save file directories
    if [ ! -d "$SAVES_DIR" ]; then
      echo "Creating master save file directory ${SAVES_DIR} ..."
      mkdir $SAVES_DIR
      if [ $? -ne 0 ] ; then
        echo "[ERROR] Failed to create save file directory: ${SAVE_DIR}"
        exit 1
      else
        echo "[OK] Created save file directory ${SAVES_DIR}"
      fi
    fi
    echo "Creating save file directory for ${system_name} ..."
    mkdir -p ${SAVES_DIR}/${system_name}
    if [ $? -ne 0 ] ; then
      echo "[ERROR] Failed to create save file directory: ${SAVES_DIR}/${system_name}"
      exit 1
    else
      echo "[OK] Created save file directory ${SAVES_DIR}/${system_name}"
    fi
    mkdir -p ${SAVES_DIR}/${system_name}/states
    if [ $? -ne 0 ] ; then
      echo "[ERROR] Failed to create save file directory: ${SAVES_DIR}/${system_name}/states"
      exit 1
    else
      echo "[OK] Created save file directory ${SAVES_DIR}/${system_name}/states"
    fi

    # Check if savefile config exists
    if grep 'savefile_directory*' "${config_file}"; then
      echo "Overwriting savefile config with '${SAVE_FILE_CONFIG}/${system_name}\"' in ${config_file} ..."
      sed -i "s|savefile_directory.*|${SAVE_FILE_CONFIG}/${system_name}\"|" "${config_file}"
    else
      echo "Writing savefile config ${SAVE_FILE_CONFIG}/${system_name} in ${config_file}!"
      echo "" >> "${config_file}"
      echo "${SAVE_FILE_CONFIG}/${system_name}\"" >> "${config_file}"
    fi

    # Check if savestate config exists
    if grep 'savestate_directory*' "${config_file}"; then
      echo "Overwriting savestate config with '${SAVE_STATE_CONFIG}/${system_name}/states\"' in ${config_file} ..."
      sed -i "s|savestate_directory.*|${SAVE_STATE_CONFIG}/${system_name}/states\"|" "${config_file}"
    else
      echo "Writing savestate config ${SAVE_STATE_CONFIG}/${system_name}/states\" in ${config_file}"
      echo "${SAVE_STATE_CONFIG}/${system_name}/states\"" >> "${config_file}"
    fi
done

echo "done"
exit 0
