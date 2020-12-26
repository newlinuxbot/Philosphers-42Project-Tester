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

    echo "[============[Testing philo_one]==============]\n"

    target="philo_one"
    make -C "$1/$target" > /dev/null

    if [ "$?" -ne 0 ];then
        echo "\n[+] There's a problem while compiling $target, please recheck your inputs"
        exit
    fi

    #TEST 1

    # ("$1/$target/$target" 4 310 200 100 > "./log_$target")&
    # sleep 5
    # pkill $target
    # output=$(grep died -m 1 "./log_$target" | awk '{print $NF}')
    # if [ $output = "died" ];then
    #     echo "\e[92m[+] Test #1 Succeded !\e[0m"
    # else
    #     echo "\e[91m[+] Test #1 Failed !\e[0m"
    # fi
    # rm -rf "./log_$target"
    # #TEST 2

    # echo "\e[92m[+] Test #2: Executing your program for 180 second, please wait...\e[0m"
    # ("$1/$target/$target" 4 410 200 200 > /dev/null)&
    # i=1
    # error=0
    # while [ $i -lt 180 ];do
    #     printf "\r[%d...]" $i
    #     pgrep $target > /dev/null
    #     if [ "$?" -ne 0 ];then
    #         echo "\r\e[91m[+] Test #2 Failed\e[0m"
    #         error=1
    #         break
    #     fi
    #     sleep 1
    #     i=$(( $i + 1 ))
    # done
    # sleep 1
    # if [ $error -eq 0 ];then
    #     pkill $target
    #     echo "\r\e[92m[+] Test #2 Succeded\e[0m"
    # fi

    # #TEST 3

    # echo "\e[92m[+] Test #3: Executing your program for 180 second, please wait...\e[0m"
    # ("$1/$target/$target" 5 800 200 200 > /dev/null)&
    # i=1
    # error=0
    # while [ $i -lt 180 ];do
    #     printf "\r[%d...]" $i
    #     pgrep $target > /dev/null
    #     if [ "$?" -ne 0 ];then
    #         echo "\r\e[91m[+] Test #3 Failed\e[0m"
    #         error=1
    #         break
    #     fi
    #     sleep 1
    #     i=$(( $i + 1 ))
    # done
    # sleep 1
    # if [ $error -eq 0 ];then
    #     pkill $target
    #     echo "\r\e[92m[+] Test #3 Succeded\e[0m"
    # fi

    #TEST 4

    #Turn into function and pass multiple arguments besides 7
    echo "\e[92m[+] Test #4 on progress, please wait...\e[0m"
    ("$1/$target/$target" 4 410 200 200 7 > "./log_$target")&
    sleep 10
    pgrep $target > /dev/null
    if [ "$?" -eq 1 ];then
        lines=$(grep eating "./log_$target" | wc -l)
        if [ $lines -ge 28 ];then
            echo "\r\e[92m[+] Test #3 Succeded\e[0m"
        else
            echo "\r\e[91m[+] Test #3 Failed\e[0m"
        fi
    else
        echo "\r\e[91m[+] Test #3 Failed\e[0m"
        pkill $target
    fi
    rm -rf "./log_$target"


    
fi
