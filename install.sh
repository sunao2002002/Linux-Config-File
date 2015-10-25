#!/bin/bash

PLATFORM=$(uname)
function mybackup(){
    cp -vf $1 $1_bak
}
if [ "$PLATFORM" = "Darwin" ];then
    echo "install on $PLATFORM" 
    mybackup ~/.bash_profile
    cp -vf ./bash_profile ~/.bash_profile
    mybackup ~/.vimrc
    cp -vf ./bashrc ~/.bashrc
    cp -vf ./bash_profile ~/.bash_profile
    cp -vf ./vimrc ~/.vimrc
elif [  "$PLATFORM" = "Linux" ];then
    echo "install on $PLATFORM" 
    mybackup ~/.vimrc
    cp -vf ./bashrc ~/.bashrc
    cp -vf ./bash_profile ~/.bash_profile
    cp -vf ./vimrc ~/.vimrc
else
    echo "Unsupported platform"
fi
 
