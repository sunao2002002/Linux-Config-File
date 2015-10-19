#!/bin/bash

PLATFORM=$(uname)
function mybackup(){
    cp $1 $1_bak
}
if [ "$PLATFORM" = "Darwin" -or "$PLATFORM" = "Linux" ];then
    echo "install on Mac OS" 
    mybackup ~/.vimrc
    cp ./bashrc ~/.bashrc
    cp ./bash_profile ~/.bash_profile
    cp ./vimrc ~/.vimrc
else
    echo "Unsupported platform"
fi
 
if [ "$PLATFORM" = "Darwin"  ];then
    mybackup ~/.bash_profile
    cp ./bash_profile ~/.bash_profile
fi
