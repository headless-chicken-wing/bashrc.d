# bashrc confiuration source from interactive sessions after ~/.profile
# If not running interactively, don't do anything

[[ $- == *i* ]] || return

#Set user's prompt
PS1="\[\e[38;5;201m\]\u\[\e[38;5;13m\]@\[\e[38;5;51m\]\h\[\e[38;5;10m\] \w\[\e[38;5;13m\] $:\[\e[0m\]"

#User specific environment
EDITOR="/usr/bin/nano"
BAT_THEME="Monokai Extended Bright"


#FIX FOR PATH
#The regex change ((^|:)/sbin(:|$)) ensures that /sbin is only added if it’s not already in the PATH:
#(^|:) ensures it’s either at the start or after a colon (:).
#(:|$) ensures it’s either at the end or followed by a colon.
#This avoids matching a part of another directory with "sbin" in it (e.g., /usr/bin/sbin).

if ! [[ "$PATH" =~ (^|:)/sbin(:|$) ]]; then
  PATH="$PATH:/sbin:/usr/sbin"
fi



if 
   [[ -e ~/.config/bashrc.d/.bash_aliases ]]
  then
   source ~/.config/bashrc.d/.bash_aliases
  else
 echo "No aliases found in $USER's $HOME"
fi



if [[ ${USER} = "brandon" ]]; then
  source /usr/share/bash-completion/bash_completion || echo "Couldn't source completions!"
   echo "bash_completion enabled"; elif
    [[ ${UID} -eq "0" ]]; then
   source /usr/share/bash-completion/bash_completion || echo "Couldn't source root's completions"; else
  echo "bash_completion is unsourced!"
fi


#Append this login's details to all_logins.log


if [[ -f /var/log/all_logins.txt && -n "$SSH_CLIENT" ]]; then
  echo ""$USER" logged into "$HOSTNAME" on $(date) from "$SSH_CLIENT"" | tee -a /var/log/all_logins.txt
fi

# enable color support of ls and also add handy aliases

if [[ -x /usr/bin/vivid ]]; then
  LS_COLORS="$(vivid generate ayu)"
elif [[ -f "$HOME/.local/bin/colors/molokai" ]]; then
  . "$HOME/.local/bin/colors/molokai"
else
  LS_COLORS="$(/usr/bin/dircolors "$HOME/.config/bashrc.d/.dir_colors")"
fi

# Shell options
shopt -s checkwinsize
shopt -s histappend
shopt -s histreedit
shopt -s cmdhist
shopt -s histverify
shopt -s globstar
set -o noclobber
#set +o histexpand

# Require prompt write to history after every command and append to the history file; don't overwrite it
PROMPT_COMMAND="history -a; $PROMPT_COMMAND"

# History settings
HISTFILE="$HOME/.config/bashrc.d/.bash_history."$USER"@"$HOSTNAME""
#HISTCONTROL=ignoreboth
HISTTIMEFORMAT=" %m-%d-%Y %T "
HISTSIZE=
HISTFILESIZE=

# Export some environment variables
export PATH EDITOR BAT_THEME LS_COLORS PS1 HISTFILE HISTTIMEFORMAT HISTSIZE HISTFILESIZE
