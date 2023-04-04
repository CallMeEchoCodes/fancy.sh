#!/bin/bash

spinner_pid=

function start_spinner {
    trap "stop_spinner \"\\e[91m\\e[0m $1\"" SIGINT
    { 
        while : ; do for X in '\e[93m|\e[0m' '\e[93m/\e[0m' '\e[93m-\e[0m' '\e[93m\\\e[0m';
            do 
                echo -ne "\r\033[0K"
                echo -en "$X $1";
                sleep 0.1;
            done;
        done &
    } 2>/dev/null
    spinner_pid=$!
}

function stop_spinner {
    if [[ -n "$spinner_pid" ]]; then
        { kill -9 $spinner_pid && wait; } 2>/dev/null
        unset spinner_pid
        echo -en "\033[2K\r"
        echo -e "$1"
        trap - SIGINT
    fi
}

function spinner {
    start_spinner "$2"
    cmdout="$1"
    if ! $cmdout; then 
        stop_spinner "\e[91m\e[0m $2"
        exit 1
    else
        stop_spinner "\e[92m\e[0m $2"
    fi
}
