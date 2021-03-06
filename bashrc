#branch-1.0
# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt
export PATH=~/bin:~/android-ndk/:$PATH
# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alhF'
alias la='ls -A'
alias l='ls -CF'
#other alias
alias vi='vim'
alias vim='vim -X'
alias cp='cp -rv'
alias mv='mv -v'
alias cat='cat -n'
alias df='df -h'
alias cd..='cd ..'
alias dos2unix='fromdos'
alias cmount='mount | column -t'
alias unmount='umount'
alias unix2dos='todos'
alias tailf='tail -f'
alias hexdump='hexdump -C'
alias cls='clear'
alias myfgrep='find . -type f  | xargs grep -i --color -n'
alias listmodule='find .  -type f -name Android.mk | xargs grep  --color -n LOCAL_MODULE[^_] -i'
alias findmodule='find . -type f -name Android.mk | xargs grep  --color -n  -i'
alias myftouch='find .  -type f  | xargs touch'
alias findf='find . -type f -iname'
alias findfile='find . -type f -iname'
alias findd='find . -type d -iname'
alias finddir='find . -type d -iname'
alias pwd='/bin/pwd'
alias astyle='astyle --style=linux -s4 -c -s -p -U  -n'
alias trim_file='sed -i "s/[ \t]*$//"'

alias mkdir='mkdir -p'
alias rm='rm -rvf'
alias ps?='ps aux |grep -E -i'
alias free='free -t'

alias his='history'
alias hisgrep='history |grep'
alias rename='mv '
alias aptinstall='sudo apt-get install'
alias mirror_site='wget -r -p -np -k'
alias websiteget='wget --random-wait -r -p -e robots=off -U mozilla'
# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi


function swapfile()
{
    if [[ $# -lt 2 ]];then
        echo "Usage: swapfile file1 file2"
        return
    fi
    local TMPFILE=tmp.$$
    mv "$1" $TMPFILE
    mv "$2" "$1"
    mv $TMPFILE "$2"
}
function backup()
{   
    if [[ -z "$1" ]];then
        echo "Usage: backup filename"
        return
    fi
    cp -rvf  "$1" "$1_bak"
}
function printred()
{
    echo -e "\033[;31m $1 \033[0m"
}
function openfile()
{
    if [[ -z "$1"  ]]; then
        echo "Usage: openfile <regex>"
        return
    fi
    if [[ -f "$1"  ]]; then
        vim "$1"
        return
    fi
    if [[ ! -f "./.file_list"  ]]; then
        find . -wholename ./out -prune -o -wholename ./.repo -prune -o -wholename .svn -prune -o -type f  > .file_list 
    fi
    local lines
    lines=($(grep -i "$1" .file_list | sort | uniq))
    if [[ ${#lines[@]} = 0 ]]; then
        echo "Not found"
        return
    fi
    local pathname
    local choice
    if [[ ${#lines[@]} > 1 ]]; then
        while [[ -z $pathname ]]; do
            local index=1
            local line
            for line in ${lines[@]}; do
                printf "%6s %s\n" "[$index]" $line
                index=$(($index+1))
            done
            echo
            echo -n "Select one:"
            unset choice
            read choice
            echo $choice
            if [[ $choice -gt ${#lines[@]} || $choice -lt 1 ]]; then
                echo "Invalid choice"
                continue    
            fi
            pathname=${lines[$(($choice-1))]}
        echo $pathname
    done
    else
        pathname=${lines[0]}
    fi
    vim $pathname
}
function untar(){
    if [ -z "$1" ];then
        echo "Usage: extract file"
        return
    fi
    if [ -f "$1"  ]; then
        case "$1" in
            *.tar)      tar -xvf $@   ;;
            *.tar.gz)   tar -xvzf $@  ;;
            *.tgz)      tar -xvzf $@  ;;
            *.tar.bz2)  tar -xvjf $@  ;;
            *.tbz2)     tar -xvjf $@  ;;
            *.tar.xz)   tar -xvJf $@  ;;
            *.txz)      tar -xvJf $@  ;;
            *.bz2)      bunzip2 $1   ;;
            *.rar)      unrar x $1     ;;
            *.gz)       gunzip $1    ;;
            *.zip)      unzip $1     ;;
            *.Z)        uncompress $1 ;;
            *.7z)       7z x $1       ;;
            *)          echo "'$1' cannot be extarct via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}
function mcd(){
    mkdir -p "$1"
    cd "$1"
}
function rmbigfold(){
	mkdir /tmp/blank
	rsync --delete-before -a -H -v --progress --stats /tmp/blank/ $1
	rm -rvf $1
}
function addcompletions()
{
    local T dir f
    if [ -z "${BASH_VERSION}"  ]; then
        return
    fi
    dir=~/bin/bash_completion
    if [ -d ${dir} ]; then
        for f in `/bin/ls ${dir}/[a-z]*.bash 2>/dev/null`; do
            echo "include $f"
            source $f

        done
    fi
}
function show_time()
{
    local start_time=$(date +"%s")
    command "$@"
    local ret=$?
    local end_time=$(date +"%s")
    local tdiff=$(($end_time-$start_time))
    local hours=$(($tdiff / 3600 ))
    local mins=$((($tdiff % 3600) / 60))
    local secs=$(($tdiff % 60))
    local ncolors=$(tput colors 2>/dev/null)
    if [ -n "$ncolors" ] && [ $ncolors -ge 8 ]; then
        color_failed="\e[0;31m"
        color_success="\e[0;32m"
        color_reset="\e[00m"
    else
        color_failed=""
        color_success=""
        color_reset=""
    fi
    echo
    if [ $ret -eq 0 ] ; then
        echo -n -e "${color_success}#### run completed successfully "
    else
        echo -n -e "${color_failed}#### run failed to build some targets "
    fi
    if [ $hours -gt 0 ] ; then
        printf "(%02g:%02g:%02g (hh:mm:ss))" $hours $mins $secs
    elif [ $mins -gt 0 ] ; then
        printf "(%02g:%02g (mm:ss))" $mins $secs
    elif [ $secs -gt 0 ] ; then
        printf "(%s seconds)" $secs
    fi
    echo -e " ####${color_reset}"
    echo
    return $ret
}
function retry_command()
{
    command $@
    while [  "$?" -ne "0" ]
    do
        sleep 5
        command $@
    done
}
function backtar(){
    local subfix=`date +%Y%m%d%H%M%S`
    tar -zcvf $1_$subfix.tgz $1
}
addcompletions
 export LC_ALL=en_US.UTF-8
 export LANG=en_US.UTF-8
