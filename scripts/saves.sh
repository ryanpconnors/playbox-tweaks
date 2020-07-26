#!/usr/bin/env bash

################################################################################
# THRILLHO's SaveFile Script                                                   #
################################################################################
# Author: THRILLHO                                                             #
# Date: 2020.07.24                                                             #
################################################################################
# Purpose: Creates a save directory at ~/RetroPie/saves                        #
# and configures all retroarch emulators with their own config files           #
# to store savefiles at ~/RetroPie/saves/{system_name}                         #
# and savestate files at ~/Retropie/saves/{system_name}/states                 #
################################################################################

CONFIGS_DIR=/opt/retropie/configs
CONFIG_FILENAME=retroarch.cfg
SAVES_DIR=~/RetroPie/saves
ROMS_DIR=~/RetroPie/roms

SAVE_FILE_CONFIG="savefile_directory = \"~/RetroPie/saves"
SAVE_STATE_CONFIG="savestate_directory = \"~/RetroPie/saves"

CONFIG_FILE_INCLUDE="#include \"/opt/retropie/configs/all/retroarch.cfg\""

infobox=""
infobox="${infobox}\n"
infobox="${infobox}This will create a new seperate 'saves' directory for your save/state files.\n"
infobox="${infobox}Note: This will NOT move any existing saves in your roms directories.\n\n"
infobox="${infobox}**Apply**\n"
infobox="${infobox}Creates saves/states directories and sets as default save file directory for all retroarch emulators.\n\n"
infobox="${infobox}**Revert**\n"
infobox="${infobox}Removes save files directorys, configs and moves existing saves to emulator folder in roms directory."
infobox="${infobox}\n"

dialog --backtitle "PlayBox Toolkit" \
--title "Single Saves Directory by THRILLHO" \
--msgbox "${infobox}" 35 110

function main_menu() {
    local choice
    while true; do
        choice=$(dialog --backtitle "$BACKTITLE" --title " MAIN MENU " \
            --ok-label OK --cancel-label Exit \
            --menu "Choose:" 25 75 20 \
            1 "Apply" \
            2 "Revert" \
            2>&1 > /dev/tty)

        case "$choice" in
            1) apply;;
            2) revert;;
            -) none ;;
            *) break ;;
        esac
    done
}

function apply {
  dialog --infobox "...Creating Single Saves Directory..." 3 20	; sleep 1

  # Loop through the configs directory
  for d in ${CONFIGS_DIR}//*; do

      # Get the system/emulator name
      system_name=${d##*/}

      # Skip over the `all` config
      if [[ ${system_name} == 'all' || ${system_name} == 'amiga'  ]]; then
        echo "Skipping ${system_name}."
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

      # Check if savefile & savestate config exists
      if grep -E 'savefile_directory*|savestate_directory*' "${config_file}"; then
        echo "Overwriting existing configs..."
        sed -i "s|savefile_directory.*|${SAVE_FILE_CONFIG}/${system_name}\"|" "${config_file}"
        sed -i "s|savestate_directory.*|${SAVE_STATE_CONFIG}/${system_name}/states\"|" "${config_file}"
      elif grep -E "${CONFIG_FILE_INCLUDE}" "${config_file}"; then
        echo "Writing new save configs above the '#include \"/opt/retropie/configs/all/retroarch.cfg\"' line ..."
        sed -i "s|${CONFIG_FILE_INCLUDE}|${SAVE_FILE_CONFIG}\n${SAVE_STATE_CONFIG}\n${CONFIG_FILE_INCLUDE}|" "${config_file}"
      else
        echo "Writing new save configs to the end of file."
        echo "${SAVE_FILE_CONFIG}/${system_name}\"" >> "${config_file}"
        echo "${SAVE_STATE_CONFIG}/${system_name}/states\"" >> "${config_file}"
      fi

      # Move existing saves to the master saves rom directory (except for Daphne)
      if [[ ${system_name} != 'daphne' && -d "${ROMS_DIR}/${system_name}" ]]; then
	       find "${ROMS_DIR}/${system_name}" -regextype posix-egrep -regex ".*\.(srm|auto|state.auto|fs|hi)$" -type f -print0 | xargs -0 mv -t "${SAVES_DIR}/${system_name}/" 2>/dev/null
      fi
      # Move existing saves states to the master saves rom directory (except for Daphne)
      if [[ -d "${ROMS_DIR}/${system_name}/states" && -d "~/.config/retroarch/states" ]]; then
	       find "${ROMS_DIR}/${system_name}/states" -type f -print0 | xargs -0 mv -t "${SAVES_DIR}/${system_name}/states" 2>/dev/null
	        find "~/.config/retroarch/states" -type f -print0 | xargs -0 mv -t "${SAVES_DIR}/${system_name}/states" 2>/dev/null
      fi

  done
  echo "done!"
  exit 0
}

function revert {
  dialog --infobox "...Reverting Single Saves Directory..." 3 20	; sleep 1

  # Check for the existence of the saves directory
  if [ ! -d "$SAVES_DIR" ]; then
    echo "No save file directory. Exiting."
    exit 0
  fi

  # Loop through the saves directory
  for d in ${SAVES_DIR}//*; do
    # Get the system/emulator name
    system_name=${d##*/}

    # Check for an existing roms directory
    if [ ! -d "$ROMS_DIR/${system_name}" ]; then
      echo "No roms directory for ${system_name}. Skipping ${system_name}."
      break
    fi

    # Check for existing config file
    config_file=${CONFIGS_DIR}/${system_name}/${CONFIG_FILENAME}
    if [[ ! -f ${config_file} ]]; then
      echo "No config file found for ${system_name}. Skipping ${system_name}."
      break
    fi

    # Move existing saves to the systems roms directory
    find "${SAVES_DIR}/${system_name}/" -type f -print0 | xargs -0 mv -t "${ROMS_DIR}/${system_name}" 2>/dev/null
    if [ -d "$SAVES_DIR/${system_name}/states" ]; then
      find "${SAVES_DIR}/${system_name}/states" -type f -print0 | xargs -0 mv -t "${ROMS_DIR}/${system_name}" 2>/dev/null
    fi

    # Check if savefile config exists
    if grep 'savefile_directory*' "${config_file}"; then
      echo "Removing savefile config for '${SAVE_FILE_CONFIG}/${system_name}\"' in ${config_file} ..."
      sed -i "/savefile_directory.*/d" "${config_file}"
    fi

    # Check if savestate config exists
    if grep 'savestate_directory*' "${config_file}"; then
      echo "Removing savestate config with '${SAVE_STATE_CONFIG}/${system_name}/states\"' in ${config_file} ..."
      sed -i "/savestate_directory.*/d" "${config_file}"
    fi

    # Delete system saves saves directory
    if [ -d "${SAVES_DIR}/${system_name}" ]; then
      echo "Deleting saves directory ${SAVES_DIR}/${system_name} ... "
      rm -Rf ${SAVES_DIR}/${system_name};
    fi
  done

  # Delete the saves directory if it exists
  if [ -d "${SAVES_DIR}" ]; then
     echo "Deleting the saves directory ${SAVES_DIR} ... "
     rm -Rf ${SAVES_DIR};
  fi
  echo "[OK] Done!"
  exit 0
}

main_menu
