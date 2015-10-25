#!/bin/bash

PLATFORM=$(uname)
function mybackup(){
    cp -vf $1 $1_bak
}
if [ "$PLATFORM" = "Darwin" -or "$PLATFORM" = "Linux" ];then
    echo "install on $PLATFORM" 
    mybackup ~/.vimrc
    cp -vf ./bashrc ~/.bashrc
    cp -vf ./bash_profile ~/.bash_profile
    cp -vf ./vimrc ~/.vimrc
else
    echo "Unsupported platform"
fi
 
if [ "$PLATFORM" = "Darwin"  ];then
    mybackup ~/.bash_profile
    cp -vf ./bash_profile ~/.bash_profile
fi
