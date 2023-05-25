#!/usr/bin/env bash

set -x

# TODO: Optimize code. Since I am not familiar with the shell, the code is rough.
get_result() {
    # get content of line 4
    line=$(cat "$1" | sed -n '4p')
    # get value
    value=$(echo "$line" | awk -F',' '{print $NF}')
    echo $value
}

if [ -z "${TOKEN}" ]; then
    echo 'Abort reporting to dingding when TOKEN is not set.'
    exit 0
fi

dingding_token=${TOKEN}
cd "$(dirname "$0")"
files=$(ls -trh ./records | grep result | tail -2)

rets=()
for file in $files
do
	ret=$( get_result "./records/$file" )
	rets+=( $ret )
done

result=$(echo "scale=4; (${rets[1]} / ${rets[0]} - 1) * 100" | bc)
result=$(printf "%.2f" $result)
content="tsbs: \n`date`\ntoday: ${rets[1]} rows/s\nyesterday: ${rets[0]} rows/s\nperformance: ${result}%"
echo $content
curl "https://oapi.dingtalk.com/robot/send?access_token=${dingding_token}" \
 -H 'Content-Type: application/json' \
 -d "{\"msgtype\": \"text\",\"text\": {\"content\":\"$content\"}}"
