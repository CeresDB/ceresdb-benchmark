#!/usr/bin/env bash

set -x

# Ensure the rust toolchain can be found in crontab task
source ~/.bashrc
# Switch to the directory of this script.
cd "$(dirname "$0")"

CURR_DIR=$(pwd)
DATA_DIR="${CURR_DIR}/data"
# The ceresdb data directory is determined by the config file: ./config/ceresdb-config.toml.
CERESDB_DIR="/tmp/ceresdbbench"

export RESULT_FILE="${DATA_DIR}/result_$(date +%Y-%m-%d).md"
export DATA_FILE="${DATA_DIR}/data.out"
export LOG_DIR="${DATA_DIR}/log"
export CERESDB_CONFIG_FILE="${CURR_DIR}/config/ceresdb-config.toml"
export CERESDB_ADDR="127.0.0.1:38131"

# Run the tsbs
if [ ! -d ceresdb ]; then
    git clone https://github.com/CeresDB/ceresdb.git
fi

trap cleanup EXIT
cleanup() {
    rm -rf $CERESDB_DIR
}

# Cleanup the old data.
cleanup

cd ceresdb
git checkout main
git pull
CERESDB_COMMIT=$(git rev-parse HEAD)
make tsbs
cd $CURR_DIR

# Append the server informatin to the result file.
echo "# ServerInfo" >> ${RESULT_FILE}
echo "- ceresdb version: $CERESDB_COMMIT" >> ${RESULT_FILE}
echo "- benchmark version: $(git rev-parse HEAD)" >> ${RESULT_FILE}
echo "- create time: $(date +%Y-%m-%d\ %H:%M:%S\ %z)" >> ${RESULT_FILE}
echo "- cpu stats:" >> ${RESULT_FILE}
echo '```plaintext' >> ${RESULT_FILE}
echo "$(lscpu)" >> ${RESULT_FILE}
echo '```' >> ${RESULT_FILE}

# Upload the benchmark results
if [ ! -z "${DISABLE_UPLOAD}" ]; then
    echo 'Upload is disabled'
    exit 0
fi

git checkout main
git pull
cp -f ${RESULT_FILE} ./records/
git add ./records
git commit -m "feat: upload benchmark result of $(date +%Y-%m-%d)"
git push
