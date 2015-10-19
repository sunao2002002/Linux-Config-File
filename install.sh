#!/bin/bash

PLATFORM=$(uname)
function mybackup(){
    cp $1 $1_bak
}
if [ "$PLATFORM" = "Darwin" ];then
    echo "install on Mac OS" 
    mybackup ~/.bash_profile
    mybackup ~/.bashrc
    mybackup ~/.vimrc
    cp ./bashrc ~/.bashrc
    cp ./bash_profile ~/.bash_profile
    cp ./vimrc ~/.vimrc
elif [ "$PLATFORM" = "Linux" ];then
    echo "install on Linux" 
    mybackup ~/.bash_profile
    mybackup ~/.bashrc
    mybackup ~/.vimrc
    cp ./bashrc ~/.bashrc
    cp ./bash_profile ~/.bash_profile
    cp ./vimrc ~/.vimrc
else
    echo "Unsupported platform"
fi
