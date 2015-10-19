export PATH=/opt/local/bin:/opt/local/sbin:$PATH
 mountAndroid(){
	hdiutil attach ~/android.dmg.sparseimage -mountpoint /Volumes/android;
}
 unmountAndroid(){
	hdiutil detach /Volumes/android;
}
mcd(){
	mkdir -p "$1";
	cd "$1";
}
backup(){
	cp "$1"{,.bak};
}
 alias rcp='scp'
alias xargs='xargs -I{}'
alias ll='ls -lh'

if [ -f ~/.bashrc ] ; then
    . ~/.bashrc
fi
