#!/bin/bash
mkdir -p logs
IFS='|' read -ra ODKAZY <<< "$1"
for ODKAZ in "${ODKAZY[@]}"; do
    IFS='=' read -ra odkaz <<< "$ODKAZ"
    for i in 1 2 3 4 5; 
    do
        obsah=$(echo -n $(date '+%Y-%m-%d %H:%M:%S')", ";curl --write-out '%{response_code}, %{time_total}' --silent --max-time 10 --insecure --output /dev/null ${odkaz[1]})
        #echo "$obsah";
        IFS="," read -a obsahArray <<< $obsah
        echo "-${obsahArray[1]}-";
        if [ "${obsahArray[1]}" == " 200" ] || [ "${obsahArray[1]}" == " 202" ] || [ "${obsahArray[1]}" == " 301" ] || [ "${obsahArray[1]}" == " 307" ]; then
            result=" success,"
            break
        else
            result=" failed,"
            sleep 5
        fi
    done
    echo "${obsah/${obsahArray[1]},/$result}"
done
find logs/ -iname '*.log' > logs/files.cfg