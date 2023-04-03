#!/usr/bin/env bash

# Run this script on the root directory of this repo.
CURR_DIR=$(pwd)
DATA_DIR="${CURR_DIR}/data"
# The ceresdb data directory is determined by the config file: ./config/ceresdb-config.toml.
CERESDB_DIR="/tmp/ceresdbbench"

export RESULT_FILE="${DATA_DIR}/result_$(date +%Y-%m-%d).md"
export DATA_FILE="${DATA_DIR}/data.out"
export LOG_DIR="${DATA_DIR}/log"
export CERESDB_CONFIG_FILE="${CURR_DIR}/config/ceresdb-config.toml"
export CERESDB_ADDR="127.0.0.1:38131"


set -x

trap cleanup EXIT
cleanup() {
    rm -rf $CERESDB_DIR
}

# Cleanup the old data.
cleanup

# Run the tsbs
if [ ! -d ceresdb ]; then
    git clone https://github.com/ShiKaiWi/ceresdb.git
fi

cd ceresdb
git checkout refactor-tsbs-running
git pull
make tsbs
cd $CURR_DIR

# Upload the benchmark results
git checkout main
git pull
cp -f ${RESULT_FILE} ./records/
git add ./records
git commit -m "feat: upload benchmark result of $(date +%Y-%m-%d)"
git push
