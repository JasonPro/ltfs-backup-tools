#!/bin/bash

export TAPE_NAME="bar"
export TARGET_BASE_DIR="/Users/username/Volumes/${TAPE_NAME}/tardirect"
export KEY_FILE="/Users/username/tape_keys/${TAPE_NAME}.key"
export TARGET_VOLUME_DIR="/Users/username/Volumes/${TAPE_NAME}"

source tape_backup.sh

mkdir -p "${TARGET_BASE_DIR}"

\date
load_indexes_to_cache "${TARGET_BASE_DIR}" "${KEY_FILE}"

backup_to_tape "/Users/username" "${TARGET_BASE_DIR}" "HomeDir-username" "${KEY_FILE}"
backup_to_tape "/Users/Shared" "${TARGET_BASE_DIR}" "HomeDir-Shared" "${KEY_FILE}"
backup_to_tape "/Applications" "${TARGET_BASE_DIR}" "MBP-Applications" "${KEY_FILE}"

save_indexes_to_tape "${TARGET_BASE_DIR}" "${KEY_FILE}"
\date

