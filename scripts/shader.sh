#!/usr/bin/env bash

################################################################################
# THRILLHO's CRT Shader Script                                                 #
################################################################################
# Author: THRILLHO                                                             #
# Date: 2020.09.06                                                             #
################################################################################
# Enables the CRT Shader on ALL RetroArch Emulators                            # 
################################################################################

CONFIGS_DIR=/opt/retropie/configs
CONFIG_FILENAME=retroarch.cfg


VIDEO_SMOOTH_ENABLED="video_smooth = \"true\""
VIDEO_SMOOTH_DISABLED="video_smooth = \"false\""

VIDEO_SHADER_ENABLE="video_shader_enable = \"true\""
VIDEO_SHADER="video_shader = \"/opt/retropie/configs/all/retroarch/shaders/crt-pi.glslp\""

ENABLE_SHADER="${VIDEO_SMOOTH_DISABLED}\n${VIDEO_SHADER_ENABLE}\n${VIDEO_SHADER}\n"

infobox=""
infobox="${infobox}\n"
infobox="${infobox}This will turn on the CRT Shader for all of your RetroArch emulators\n"
infobox="${infobox}**Apply**\n"
infobox="${infobox}Enables the CRT shader all retroarch emulators.\n\n"
infobox="${infobox}**Revert**\n"
infobox="${infobox}Disables the CRT shader all retroarch emulators.\n\n"
infobox="${infobox}\n"

dialog --backtitle "PlayBox Toolkit" \
--title "CRT Shader Script by THRILLHO" \
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
  for d in ${CONFIGS_DIR}//*; do
      system_name=${d##*/}
      if [[ ${system_name} == 'all']]; then continue; fi
      config_file=${CONFIGS_DIR}/${system_name}/${CONFIG_FILENAME}
      if [[ -f ${config_file} ]]; then
        sed -i "s|${VIDEO_SMOOTH_ENABLED}|${ENABLE_SHADER}" "${config_file}"
      fi
  done
  exit 0
}

function revert {
  for d in ${CONFIGS_DIR}//*; do
    system_name=${d##*/}
    if [[ ${system_name} == 'all']]; then continue; fi
    config_file=${CONFIGS_DIR}/${system_name}/${CONFIG_FILENAME}
    if [[ -f ${config_file} ]]; then
      sed -i "s|${VIDEO_SMOOTH_DISABLED}|${VIDEO_SMOOTH_ENABLED}|" "${config_file}"
      sed -i "|${VIDEO_SHADER_ENABLE}|d" "${config_file}"
      sed -i "|${VIDEO_SHADER}|d" "${config_file}"
    fi
  done
  exit 0
}

main_menu
