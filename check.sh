#!/bin/bash
mkdir -p logs
IFS='|' read -ra ODKAZY <<< "$1"
for ODKAZ in "${ODKAZY[@]}"; do
    IFS='=' read -ra odkaz <<< "$ODKAZ"
    echo "${odkaz[0]}"
    for i in 1 2 3; 
    do
        obsah=$(echo -n $(date '+%Y-%m-%d %H:%M:%S')", ";curl --write-out '%{response_code}, %{time_total}' --silent --insecure --output /dev/null ${odkaz[1]})
        IFS="," read -a obsahArray <<< $obsah
        if [ "${obsahArray[1]}" == " 200" ] || [ "${obsahArray[1]}" == " 202" ] || [ "${obsahArray[1]}" == " 301" ] || [ "${obsahArray[1]}" == " 307" ]; then
            result=" success,"
            break
        else
            result=" failed,"
        fi
        sleep 2
    done
    echo "${obsah/${obsahArray[1]},/$result}" >> logs/${odkaz[0]}.log
done
ls -1 logs/*.log > logs/files.cfg