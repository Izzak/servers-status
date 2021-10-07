#!/bin/bash
mkdir -p logs
IFS='|' read -ra ODKAZY <<< "$1"
for ODKAZ in "${ODKAZY[@]}"; do
    IFS='=' read -ra odkaz <<< "$ODKAZ"
    (echo -n $(date '+%Y-%m-%d %H:%M:%S')", ";curl --write-out '%{response_code}, %{time_total}' --silent --insecure --output /dev/null ${odkaz[1]};echo) >> logs/${odkaz[0]}.log
done
find logs/ -iname '*.log' > logs/files.cfg