#!/bin/bash

read -p "Enter mount point (/, /var, /data etc): " MP

while true
do
    clear

    echo "====================================================="
    echo "Filesystem Usage"
    echo "====================================================="
    df -h "$MP" | tail -1

    echo
    echo "====================================================="
    echo "Top 20 Directories in $MP"
    echo "====================================================="
    du -xh --max-depth=1 "$MP" 2>/dev/null | sort -hr | head -20

    echo
    echo "====================================================="
    echo "Top 20 Files in $MP"
    echo "====================================================="
    find "$MP" -type f -printf "%s %p\n" 2>/dev/null | \
    sort -nr | head -20 | \
    awk '
    {
        size=$1
        path=$2
        split("B KB MB GB TB",u)
        i=1
        while(size>=1024 && i<5){
            size/=1024
            i++
        }
        printf "%8.2f %-2s %s\n", size, u[i], path
    }'

    echo
    read -p "Enter directory to drill down (q to quit): " DIR

    [ "$DIR" = "q" ] && exit 0

    if [ -d "$DIR" ]; then
        MP="$DIR"
    else
        echo "Directory not found."
        sleep 2
    fi
done
