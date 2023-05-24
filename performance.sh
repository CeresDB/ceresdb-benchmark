#!/usr/bin/env bash

set -x

get_result() {
    # get content of line 4
    line=$(cat "$1" | sed -n '4p')
    # get value
    value=$(echo "$line" | awk -F',' '{print $NF}')
}

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

content="tsbs: \n`date`\ntoday: ${rets[1]} rows/s, yesterday: ${rets[0]} rows/s\nperformance: ${result}%"
curl "https://oapi.dingtalk.com/robot/send?access_token=${dingding_token}" \
 -H 'Content-Type: application/json' \
 -d "{\"msgtype\": \"text\",\"text\": {\"content\":\"$content\"}}"
