#!/usr/bin/env bash
##By Angel Mariscurrena
##Repo: https://github.com/Mariscurrena/Hash-Validator.git
##git@github.com:Mariscurrena/Hash-Validator.git 
clear

##Colors Definition
GREEN="\033[30;42m"; GREENF="\033[0m"
BLUE="\e[34m"; BLUEF="\e[0m"
RED="\033[31;40m"; REDF="\033[0m"

##Function to download the necessary libraries to execute this script.
downloads(){
    if which coreutils > /dev/null; then
        echo "Package COREUTILS detected!"
        echo "Continuing with proccess..."
    else
        echo "Package COREUTILS undetected!!"
        echo "Installing COREUTILS..."
        sudo apt install coreutils
    fi
    if which libdigest-sha3-perl > /dev/null; then
        echo "Package libdigest-sha3-perl detected!"
        echo "Continuing with proccess..."
    else
        echo "Package libdigest-sha3-perl undetected!!"
        echo "Installing libdigest-sha3-perl..."
        sudo apt install libdigest-sha3-perl
    fi
}

loading(){
    loading_chars="/ - \\ |"
    duration=3
    interval=0.1
    end_time=$((SECONDS + duration))

    echo -e "${BLUE}You have selected $1 hashing.${BLUEF}"
    while [ $SECONDS -lt $end_time ]; do
        for char in $loading_chars; do
            echo -ne "\rLoading... $char"
            sleep $interval
        done
    done
}

hash_type(){
	select type in "MD5" "BLAKE2" "SHA-1" "SHA-256" "SHA-512224" "SHA-3"
    do
            case $type in
                MD5) 
                    file_hash=$(md5sum $1 | awk '{ print $1 }')
                    loading MD5
                    break
                ;;
                BLAKE2) 
                    file_hash=$(b2sum $1 | awk '{ print $1 }')
                    loading BLAKE2
                    break
                ;;
                SHA-1) 
                    file_hash=$(shasum -a 1 $1 | awk '{ print $1 }')
                    loading SHA-1
                    break 
                ;;
                SHA-256) 
                    file_hash=$(shasum -a 256 $1 | awk '{ print $1 }')
                    loading SHA-256
                    break 
                ;;
                SHA-512224) 
                    file_hash=$(shasum -a 512224 $1 | awk '{ print $1 }')
                    loading SHA-512224
                    break 
                ;;
                SHA-3) 
                    file_hash=$(sha3sum -a 512 $1 | awk '{ print $1 }')
                    loading SHA-3
                    break 
                ;;
                *) echo -e "${RED}That is not a valid option.${REDF}";;
            esac
    done	
}

#downloads
file_hash=""

loading_chars="/ - \\ |" duration=3 interval=0.1 end_time=$((SECONDS + duration))
    while [ $SECONDS -lt $end_time ]; do
        for char in $loading_chars; do
            echo -ne "\rLoading... $char"
            sleep $interval
        done
    done
clear
echo -e "${GREEN}Welcome to the Hash Validator.${GREENF}"
echo -e "${GREEN}         By Angel Mariscurrena${GREENF}"
sleep 1.5
echo -e "${BLUE}Here you will be able to confirm that the integrity of your files has not been compromised.${BLUEF}"

while getopts :f:h: option; do
        case $option in
            f) 
                echo -e "${BLUE}Select the hash algorithm that was applied to the file.${BLUEF}"
                hash_type $OPTARG
            ;;
            h)
                hash="$OPTARG"
                if [ "$file_hash" = "$hash" ]; then
                    echo ""
                    echo -e "${GREEN}File hash has not been modified. You can continue working safetly...${GREENF}"
                else
                    echo ""
                    echo -e "${RED}File's integrity has been compromised!! Be careful!${REDF}"
                fi
            ;;
            ?) echo "Option Unknown: "$OPTARG""
        esac
done
