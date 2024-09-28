#!/bin/bash

export TAPE_NAME="foo"
export TARGET_BASE_DIR="/Users/username/Volumes/${TAPE_NAME}/tardirect"
export KEY_FILE="/Users/username/tape_keys/${TAPE_NAME}.key"
export TARGET_VOLUME_DIR="/Users/username/Volumes/${TAPE_NAME}"

source tape_backup.sh

mkdir -p "${TARGET_BASE_DIR}"

\date
load_indexes_to_cache "${TARGET_BASE_DIR}" "${KEY_FILE}"

backup_to_tape "/Volumes/ScannedFiles" "${TARGET_BASE_DIR}" "NAS-ScannedFiles" "${KEY_FILE}"
backup_to_tape "/Volumes/Photos" "${TARGET_BASE_DIR}" "NAS-Photos" "${KEY_FILE}"
backup_to_tape "/Volumes/Applications" "${TARGET_BASE_DIR}" "NAS-Applications" "${KEY_FILE}"
backup_to_tape "/Volumes/Misc" "${TARGET_BASE_DIR}" "NAS-Misc" "${KEY_FILE}"

save_indexes_to_tape "${TARGET_BASE_DIR}" "${KEY_FILE}"
\date

