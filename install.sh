#!/bin/bash

if [ -f "~/.vimrc"  ] ;then
	mv ~/.vimrc ~/.vimrc_bak
	cp ./vimrc ~/.vimrc
fi


if [ -f "~/.bashrc"  ] ;then
	mv ~/.bashrc  ~/.bashrc_bak
	cp ./bashrc  ~/.bashrc
fi
