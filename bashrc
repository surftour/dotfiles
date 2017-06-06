
# guards against problems with scp
if [ -z "$PS1" ]; then
    return
fi

alias ls='ls -G'
alias ll='ls -Gl'
alias dir='ls -Gl'
alias rm='rm -i'

alias grep='grep --color=auto -d skip'

#
# note on the color coding
#
# Attribute codes:
# 00=none 01=bold 04=underscore 05=blink 07=reverse 08=concealed
# Text color codes:
# 30=black 31=red 32=green 33=yellow 34=blue 35=magenta 36=cyan 37=white
# Background color codes:
# 40=black 41=red 42=green 43=yellow 44=blue 45=magenta 46=cyan 47=white
#
export LS_COLORS='no=00:fi=00:di=01;34:ln=01;36:pi=40;33:so=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jpg=01;35:*.png=01;35:*.gif=01;35:*.bmp=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.mpg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35::*.eps=04;33:*.ps=04;33:*.pdf=04;43:*.ppt=07;42;30:'



export PROMPT_COMMAND='echo -ne "\033]0;${USER}: ${PWD/#$HOME/~}\007"'



