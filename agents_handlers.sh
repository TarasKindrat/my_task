#!/bin/bash
host=$1
login_name=$2
password=$3
# Login to host:
/local/ecbin/bin/ectool --server $host login $login_name $password;
# Get recources 
/local/ecbin/bin/ectool --format json getResources > .txt_resources.txt;
echo "Online resources: "
cat txt_resources.txt | jq '.resource[] | select(.agentState.state == "up") | [.resourceName, .agentState.state, .agentState.time] ';
echo "**************************************************************************************************"
echo "Offline resources: "

date_arr=( $(cat txt_resources.txt | jq -Sc '.resource[] | select(.agentState.state == "down") | .agentState.time | sub("(?<time>.*)\\.[\\d]{3}(?<tz>.*)"; "\(.time)\(.tz)") | strptime("%Y-%m-%dT%H:%M:%SZ") |mktime ') );
names_arr=( $(cat txt_resources.txt | jq '.resource[] | select(.agentState.state == "down") | .resourceName') );
sorted_last_data=( $(cat txt_resources.txt | jq -Sc '.resource[] | select(.agentState.state == "down") | .agentState.time | sub("(?<time>.*)\\.[\\d]{3}(?<tz>.*)"; "\(.time)\(.tz)") | strptime("%Y-%m-%dT%H:%M:%SZ") |mktime ' | sort -nu | head -n 10) )

for index in ${!date_arr[*]}
do
    for item2 in ${sorted_last_data[*]}
    do
        if [[ "${date_arr[$index]}" = "$item2" ]]; then
           printf "   %s\n" ${names_arr[$index]};
        fi
        
     done
done
