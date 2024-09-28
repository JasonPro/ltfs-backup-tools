#!/bin/bash

export CACHE_DATE=$(date "+%Y%m%d-%H-%M-%S")
export CACHE_DIR="/tmp/${CACHE_DATE}-tape-index-caches"

load_indexes_to_cache() {
  local TARGET_BASE_DIR="$1"
  local KEY_FILE="$2"
  local TARGETINDEX="indicies.tar.gz.enc"

  echo Loading indices
  mkdir -p "${CACHE_DIR}"
  #cp "${TARGET_BASE_DIR}"/*.sngz "${CACHE_DIR}"/
  touch "${TARGET_BASE_DIR}"/${TARGETINDEX}
  cat "${TARGET_BASE_DIR}"/${TARGETINDEX} | openssl enc -d -aes-256-ecb -K $(cat ${KEY_FILE}) | gunzip | gtar -x --no-check-device -C "${CACHE_DIR}"/
  echo Done
}

save_indexes_to_tape() {
  local TARGET_BASE_DIR="$1"
  local KEY_FILE="$2"
  local TARGETINDEX="indicies.tar.gz.enc"

  echo Saving indices
  mkdir -p "${CACHE_DIR}"
  #cp -f "${CACHE_DIR}"/*.sngz "${TARGET_BASE_DIR}"/
  gtar  -c -I "pigz | openssl enc -aes-256-ecb -K $(cat ${KEY_FILE})" --no-check-device -f "${TARGET_BASE_DIR}/${TARGETINDEX}" -C "${CACHE_DIR}" $(cd "${CACHE_DIR}";ls *.sngz)
  #rm -rf "${CACHE_DIR}"
  echo Done
}

backup_to_tape() {
  local SOURCE="$1"
  local TARGET_BASE_DIR="$2"
  local TARGET="$3"
  local KEY_FILE="$4"

  local DATE=$(date "+%Y%m%d-%H-%M-%S")

  mkdir -p "${TARGET_BASE_DIR}"
  echo "Starting backup of ${SOURCE} to ${TARGET_BASE_DIR}/${TARGET}"
  time gtar --exclude="${TARGET_VOLUME_DIR}" -c -I "pigz | openssl enc -aes-256-ecb -K $(cat ${KEY_FILE})" -g "${CACHE_DIR}/${TARGET}.sngz" --no-check-device -f "${TARGET_BASE_DIR}/${DATE}-${TARGET}.tar.gz.enc" "${SOURCE}"
  echo "End backup of ${SOURCE} to ${TARGET_BASE_DIR}/${TARGET}"
}

backup_to_tape_uncompressed() {
  local SOURCE="$1"
  local TARGET_BASE_DIR="$2"
  local TARGET="$3"
  local KEY_FILE="$4"

  local DATE=$(date "+%Y%m%d-%H-%M-%S")

  mkdir -p "${TARGET_BASE_DIR}"
  echo "Starting uncompressed backup of ${SOURCE} to ${TARGET_BASE_DIR}/${TARGET}"
  time gtar --exclude="${TARGET_VOLUME_DIR}" -c -I "openssl enc -aes-256-ecb -K $(cat ${KEY_FILE})" -g "${CACHE_DIR}/${TARGET}.sngz" --no-check-device -f "${TARGET_BASE_DIR}/${DATE}-${TARGET}.tar.enc" "${SOURCE}"
  echo "End uncompressed backup of ${SOURCE} to ${TARGET_BASE_DIR}/${TARGET}"
}


#backup_to_tape() {
#  local SOURCE="$1"
#  local TARGET_BASE_DIR="$2"
#  local TARGET="$3"
#  local CERT="$4"
#
#  local DATE=$(date "+%Y%m%d-%H-%M-%S")
#
#  mkdir -p "${TARGET_BASE_DIR}"
#  echo "Starting backup of ${SOURCE} to ${TARGET_BASE_DIR}/${TARGET}"
#  time gtar -c -I "pigz | openssl smime -encrypt -binary -aes-256-cbc -stream -outform DER \"${CERT}\"" -g "${CACHE_DIR}/${TARGET}.sngz" --no-check-device -f "${TARGET_BASE_DIR}/${DATE}-${TARGET}.tar.gz" "${SOURCE}"
#  echo "End backup of ${SOURCE} to ${TARGET_BASE_DIR}/${TARGET}"
#}

index_from_tape() {
  local TARGET="$2"
  local KEY_FILE="$1"

  local DATE=$(date "+%Y%m%d-%H-%M-%S")

  echo "Indexing backup from ${TARGET} with key file ${KEY_FILE}"
  time cat ${TARGET} | openssl enc -d -aes-256-ecb -K $(cat ${KEY_FILE}) | gunzip | gtar -t -g "/dev/null" --no-check-device
  echo "End index of ${SOURCE} to ${TARGET_BASE_DIR}/${TARGET}"
}

index_from_tape_uncompressed() {
  local TARGET="$2"
  local KEY_FILE="$1"

  local DATE=$(date "+%Y%m%d-%H-%M-%S")

  echo "Indexing backup from ${TARGET} with key file ${KEY_FILE}"
  time cat ${TARGET} | openssl enc -d -aes-256-ecb -K $(cat ${KEY_FILE}) | gtar -t -g "/dev/null" --no-check-device
  echo "End index of ${SOURCE} to ${TARGET_BASE_DIR}/${TARGET}"
}

restore_from_tape() {
  local TARGET="$2"
  local KEY_FILE="$1"

  local DATE=$(date "+%Y%m%d-%H-%M-%S")

  echo "Restoring backup from ${TARGET} with key file ${KEY_FILE}"
  time cat ${TARGET} | openssl enc -d -aes-256-ecb -K $(cat ${KEY_FILE}) | gunzip | gtar -x -g "/dev/null" --no-check-device
  echo "End restore of ${SOURCE} to ${TARGET_BASE_DIR}/${TARGET}"
}


tape_mkkey() {
  openssl rand -hex 32 > "$1"
}
