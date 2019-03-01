#!/usr/bin/env bash

IFS=$'\n' clusters=($(kubectl config get-contexts --no-headers | awk '{print $2}'))
active_cluster=$(kubectl config current-context)

for i in ${!clusters[@]};
do
    :
    if [ "${clusters[$i]}" == $active_cluster ]; then
        echo -e "\e[34m[*] \e[36m"${clusters[$i]}
    else
        echo -e "\e[34m[$((i+1))] \e[36m"${clusters[$i]}
    fi
done

read -p "Select cluster: " cluster

if [[ -z "$cluster" ]]; then
    echo -e "\e[91mNothing selected"
    exit 1
fi

if (( cluster - 1 < ${#clusters[@]} )) &&
        (( cluster > 0 )) &&
        [[ $cluster = *[[:digit:]]* ]]; then

    if [ "${clusters[$cluster - 1]}" == $active_cluster ]; then
        echo -e "\e[93mCluster ${clusters[$cluster - 1]} is already active"
        exit 0
    fi

    echo -e "\e[32mSelected cluster: ${clusters[$cluster - 1]}"
    kubectl config use-context ${clusters[$cluster - 1]}
else
    echo -e "\e[91mOops, $cluster is not there"
    exit 1
fi

