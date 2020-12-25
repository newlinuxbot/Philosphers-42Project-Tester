#!/bin/bash

echo '\e[91m _____ _   _ _                 _                  _____        _           
|  _  | |_|_| |___ ___ ___ ___| |_ ___ ___ ___   |_   _|__ ___| |_ ___ ___ 
|   __|   | | | . |_ -| . | . |   | -_|  _|_ -|    | || -_|_ -|  _| -_|  _|
|__|  |_|_|_|_|___|___|___|  _|_|_|___|_| |___|    |_||___|___|_| |___|_|  
                          |_|                                              \e[0m\n'

if [ "$#" -ne 2 ]; then
    echo "Usage: start.sh <Project Folder> <Test Type>"
    echo "\tType 0: test philo_one, philo_two and philo_three"
    echo "\tType 1: test philo_one only"
    echo "\tType 2: test philo_two only"
    echo "\tType 3: test philo_three only"
    exit
fi

if [ "$2" -gt 3 -o "$2" -lt 0 ]; then
    echo "[Error]: Wrong Arguments"
    exit
fi

echo "\e[92m[+] Given Folder: $1"
echo "[+] Test Type: $2\e[0m\n"

if [ "$2" -eq 1 -o "$2" -eq 0 ];then

    echo "[============[Testing philo_one]==============]"

    target="philo_one"
    make -C "$1/$target" > /dev/null

    if [ "$?" -ne 0 ];then
        echo "\n[+] There's a problem while compiling $target, please recheck your inputs"
        exit
    fi

    "$1/$target/$target" 4 310 200 100 > "./death_log_$target"
    sleep 5
    pkill $target
    output=$(grep died -m 1 "./death_log_$target" | awk '{print $NF}')
    if [ $output = "died" ];then
        echo "\e[92m[+] Test #1 Succeded !\e[0m"
    else
        echo "\e[91m[+] Test #1 Failed !\e[0m"
    fi
    rm -rf "./death_log_$target"
fi



