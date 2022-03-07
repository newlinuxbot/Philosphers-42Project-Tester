#!/bin/zsh

echo '\e[91m _____ _   _ _                 _                  _____        _
|  _  | |_|_| |___ ___ ___ ___| |_ ___ ___ ___   |_   _|__ ___| |_ ___ ___
|   __|   | | | . |_ -| . | . |   | -_|  _|_ -|    | || -_|_ -|  _| -_|  _|
|__|  |_|_|_|_|___|___|___|  _|_|_|___|_| |___|    |_||___|___|_| |___|_|
                          |_|                                              \e[0m\n'

if [ "$#" -ne 2 ]; then
    echo "Usage: start.sh <Project Folder> <Test Type>"
    echo "\tType 0: test philo, and philo_bonus"
    echo "\tType 1: test philo only"
    echo "\tType 2: test philo_bonus only"

    exit
fi

if [ "$2" -gt 2 -o "$2" -lt 0 ]; then
    echo "[Error]: Wrong Arguments"
    exit
fi

echo "\e[92m[+] Given Folder: $1"
echo "[+] Test Type: $2\e[0m\n"
echo "\e[94m[+] In Case of a failed test, please check ./errors_log file for more information\e[0m\n"

error_log ()
{
    echo "[$1-$2]: $3" >> ./errors_log
}

test_one ()
{
    ("$2/$1/$1" 4 310 200 100 > "./log_$1")&
    sleep 5
    pkill $1
    output=$(grep died -m 1 "./log_$1" | awk '{print $NF}')
    if [ "$output" = "died" ];then
        echo "\e[92m[+] Test #1 Succeeded !\e[0m"
    else
        echo "\e[91m[+] Test #1 Failed !\e[0m"
        error_log $1 "Test #1" "Given 4 310 200 100 arguments to $1, a philosopher should die !"
    fi
    rm -rf "./log_$1"
}

test_two ()
{
    echo "\e[94m[+] Test #2: Executing your program for 180 second, please wait...\e[0m"
    ("$2/$1/$1" 4 410 200 200 > /dev/null)&
    i=1
    error=0
    while [ $i -lt 180 ];do
        printf "\r[%d...]" $i
        pgrep $1 > /dev/null
        if [ "$?" -ne 0 ];then
            echo "\r\e[91m[+] Test #2 Failed\e[0m"
            error_log $1 "Test #2" "Given 4 410 200 200 arguments to $1, no philosopher should die !"
            error=1
            break
        fi
        sleep 1
        i=$(( $i + 1 ))
    done
    sleep 1
    if [ $error -eq 0 ];then
        pkill $1
        echo "\r\e[92m[+] Test #2 Succeeded\e[0m"
    fi
}

test_three ()
{
    echo "\e[94m[+] Test #3: Executing your program for 180 second, please wait...\e[0m"
    ("$2/$1/$1" 5 800 200 200 > /dev/null)&
    i=1
    error=0
    while [ $i -lt 180 ];do
        printf "\r[%d...]" $i
        pgrep $1 > /dev/null
        if [ "$?" -ne 0 ];then
            echo "\r\e[91m[+] Test #3 Failed\e[0m"
            error_log $1 "Test #3" "Given 4 800 200 200 arguments to $1, no philosopher should die !"
            error=1
            break
        fi
        sleep 1
        i=$(( $i + 1 ))
    done
    sleep 1
    if [ $error -eq 0 ];then
        pkill $1
        echo "\r\e[92m[+] Test #3 Succeeded\e[0m"
    fi
}

test_four ()
{
    ("$2/$1/$1" 4 410 200 200 $3 > "./log_$1")&
    sleep 10
    pgrep $1 > /dev/null
    if [ "$?" -eq 1 ];then
        lines=$(grep eating "./log_$1" | wc -l)
        if [ $lines -ge $4 ];then
            echo "\t\e[92m[+] Test #4-$5 Succeeded\e[0m"
        else
            echo "\t\e[91m[+] Test #4-$5 Failed\e[0m"
            error_log $1 "Test #4" "Given 4 410 200 200 $3 arguments to $1, $1 should only be stopped if each philosopher ate at least $3 times !"
        fi
    else
        echo "\t\e[91m[+] Test #4-$5 Failed\e[0m"
        error_log $1 "Test #4" "Given 4 410 200 200 $3 arguments to $1, $1 should stop !"
        pkill $1
    fi
    rm -rf "./log_$1"
}

test_five ()
{
    echo "\e[94m[+] Test #5 on progress, please wait...\e[0m"
    i=1
    t=0
    error=0
    while [ $i -le 10 ];do
        ("$2/$1/$1" 2 60 60 60 > "./log_$1")&
        sleep 2
        pgrep $1 > /dev/null
        if [ "$?" -eq 1 ];then
            printf "\r[%d/10]" $i
            tmp=$(grep died -m 1 "./log_$1" | awk '{print $1}' | sed 's/[^0-9]*//g')
            if [ $i -gt 1 ];then
                x=$(expr $tmp - $t)
                x=${x#-}
                if [ $x -gt 10 ];then
                    printf "\r\e[91m[+] Test #5 Failed\e[0m\n"
                    error_log $1 "Test #5" "Given 2 60 60 60 arguments to $1, the time difference of each death shouldn't be bigger than 10ms !"
                    error=1
                    break
                fi
            else
                t=$tmp
            fi
        else
            printf "\r\e[91m[+] Test #5 Failed\e[0m\n"
            error_log $1 "Test #5" "Given 2 60 60 60 arguments to $1, a philosopher should die !"
            pkill $1
            break
        fi
        i=$(( $i + 1 ))
    done

    if [ $error -eq 0 ];then
        echo "\r\e[92m[+] Test #5 Succeeded\e[0m"
    fi
}

test_six ()
{
    ("$2/$1/$1" 10 410 200 200 > /dev/null)&
    sleep 2
    forks=$(pgrep $1 | wc -l)
    if [ "$forks" -eq 11 ];then
        printf "\r\e[92m[+] Test #6 Succeeded\e[0m\n"
    else
        printf "\r\e[91m[+] Test #6 Failed\e[0m\n"
        error_log $1 "Test #6" "Given 10 410 200 200 arguments to $1, 10 processes should be forked, each process for a philosopher !"
    fi
    pkill $1
}

if [ "$2" -eq 1 -o "$2" -eq 0 ];then

    echo "[============[Testing philo]==============]\n"

    target="philo"
    make -C "$1/$target" > /dev/null

    if [ "$?" -ne 0 ];then
        echo "\n[+] There's a problem while compiling $target, please recheck your inputs"
        exit
    fi

    test_one $target $1

    test_two $target $1

    test_three $target $1

    echo "\e[94m[+] Test #4 on progress, please wait...\e[0m"
    test_four $target $1 7 28 1
    test_four $target $1 10 40 2
    test_four $target $1 12 48 3
    test_four $target $1 15 60 4

    test_five $target $1
    rm -rf "./log_$target"
fi

if [ "$2" -eq 2 -o "$2" -eq 0 ];then

    echo "\n[============[Testing philo_bonus]==============]\n"

    target="philo_bonus"
    make -C "$1/$target" > /dev/null

    if [ "$?" -ne 0 ];then
        echo "\n[+] There's a problem while compiling $target, please recheck your inputs"
        exit
    fi

    test_one $target $1

    test_two $target $1

    test_three $target $1

    echo "\e[94m[+] Test #4 on progress, please wait...\e[0m"
    test_four $target $1 7 28 1
    test_four $target $1 10 40 2
    test_four $target $1 12 48 3
    test_four $target $1 15 60 4

    test_five $target $1

    test_six $target $1
    rm -rf "./log_$target"
fi
