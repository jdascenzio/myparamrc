# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
# yes, i want colors, aliases etc...
#[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# don't overwrite GNU Midnight Commander's setting of `ignorespace'.
HISTCONTROL=$HISTCONTROL${HISTCONTROL+,}ignoredups
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)

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
force_color_prompt=yes

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
    PS1="${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$\[\033[01;33m\]\$(__git_ps1)\[\033[00m\] "
else
    PS1="${debian_chroot:+($debian_chroot)}\u@\h:\w\$(__git_ps1) "
fi
unset color_prompt force_color_prompt

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
alias ll='ls -l'
alias la='ls -lA'
#alias l='ls -CF'

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

# alias ctags
alias ctagsc='ctags -R --c++-kinds=+p --fields=+iaS --extra=+q --language-force=C++'
alias gitcommitall='git commit -a -m WIP ; git logo'
alias cross-make='ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- make'
alias cross-qmake='/home/julien/projet/LNS/buildroot/output/host/usr/bin/qmake -r -spec /home/julien/projet/LNS/buildroot/output/host/usr/arm-buildroot-linux-gnueabi/sysroot/usr/mkspecs/qws/linux-arm-g++'

export LS_OPTIONS='-N --color=tty -T 5 --time-style=long-iso'

export PATH=$HOME/local/bin:$HOME/soft/git-achievements:/sbin:$PATH

shopt -s expand_aliases

alias git='LANG=en_US.UTF-8 git-achievements'
source $HOME/soft/git/contrib/completion/git-prompt.sh
source $HOME/soft/git/contrib/completion/git-completion.bash

cp_p()
{
	local params=( "$@" )
	# Le dernier champs est la destination
	unset params[$(( ${#params[@]} - 1 ))]
	# $COLUMNS correspond à la largeur de votre terminal
	# et est mise à jour après chaque commande si l'option
	# checkwinsize est définie ou à la réception du signal WINCH
	kill -s WINCH $$
	[ $COLUMNS -lt 20 ] && (cp -a -- "$@"; return $?)
	lim=$(( $COLUMNS - 10 ))
	# Les "--" sont là pour signifier qu'il n'y a pas d'options
	# sinon, il faut modifier le "du" etc...
	# J'utilise le "-a" pour pouvoir copier par exemple des
	# répertoires sans soucis.
	strace -e write cp -a -- "$@" 2>&1 |
	awk '
	{
		count += $NF    # rajoute la valeur du dernier champs
		# 10 représente la fréquence d affichage
		if (count % 10 == 0)
		{
			percent = count / total_size * 100
			printf "%3d%% [", percent
			for (i=0;i<=percent*'$lim'/100;i++)
				printf "="
			if (percent<100)
				printf ">"
			for (j=i;j< '$lim';j++)
				printf " "
			printf "]\r"
		}
	}
	END { printf "100\n" }' \
	total_size=$(du -bc "${params[@]}" | awk 'END {print $1}') \
	count=0
}

# Opening a new tab in gnome-terminal retains cwd (current path)
if [ -f /etc/profile.d/vte.sh ]
then
	. /etc/profile.d/vte.sh
fi

# used 256 color for the terminal
export TERM='xterm-256color'
