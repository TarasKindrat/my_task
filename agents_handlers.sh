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
# Get converted date of "down" state and fill array
date_arr=( $(cat txt_resources.txt | jq -Sc '.resource[] | select(.agentState.state == "down") | .agentState.time | sub("(?<time>.*)\\.[\\d]{3}(?<tz>.*)"; "\(.time)\(.tz)") | strptime("%Y-%m-%dT%H:%M:%SZ") |mktime ') );
# Get resourceName in "down" state and fill array
names_arr=( $(cat txt_resources.txt | jq '.resource[] | select(.agentState.state == "down") | .resourceName') );
# Get last dates of "down" state
sorted_last_date=( $(cat txt_resources.txt | jq -Sc '.resource[] | select(.agentState.state == "down") | .agentState.time | sub("(?<time>.*)\\.[\\d]{3}(?<tz>.*)"; "\(.time)\(.tz)") | strptime("%Y-%m-%dT%H:%M:%SZ") |mktime ' | uniq | sort -nu | head -n 10) )

i=0
for item2 in ${sorted_last_date[*]}
do   
    for index in ${!date_arr[*]}
    do
        if [[ "${date_arr[$index]}" = "$item2" ]]; then
            #echo $item2
            echo "names: ${names_arr[$index]}"
            ((i++))
            # Get only 10 latest resousces, there are more like one resource with the same time of "Down" stare
            if [[ $i -eq 10 ]]; then
                break 2
            fi
        fi
    done
done
