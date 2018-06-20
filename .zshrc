# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH=/home/mainuser/.oh-my-zsh

# For pywal
export PATH="${PATH}:${HOME}/.local/bin/"

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="bira"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(sudo colored-man-pages history-search-multi-word alias-tips zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# remove command lines from the history list when the first character on the
# line is a space
setopt histignorespace

# Keep 1000 lines of history within the shell
HISTSIZE=10000
SAVEHIST=10000

# avoid "beep"ing
setopt nobeep

export ZSH_PLUGINS_ALIAS_TIPS_EXCLUDES="_ ll vi"
export LS_OPTIONS="--color=auto"
alias grep='grep --color=auto'

function lazygit(){
  if (( $# == 0 ))
    then echo "Missing commit message: lazygit <commit message>"; fi 
  git add .
  git commit -a -m "$1"
  git push
}

function dic(){
  if (($# > 0))
    then dict -f -d wn "$1" | tail -n +3 | grep -E -z "$1";
  else echo "Pick a work to define..."
  fi
}

function say(){
  if (($# > 0))
    then espeak -ven-uk-rp -s 120 $1
  fi
}

function hg(){
  if (($# == 0))
    then echo "Add history grep filter"; fi
  history | grep "$1"
}

function lg(){
  if (($# == 0))
    then echo "Add ls grep filter"; fi
  exa -la | grep "$1"
}

function alg(){
  if (($# == 0)) then
    apt list | grep installed
  else
    apt list | grep $1 | grep installed
  fi
}

# Easy extract
function extract {
 if [ -z "$1" ]; then
    # display usage if no parameters given
    echo "Usage: extract <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz>"
    echo "       extract <path/file_name_1.ext> [path/file_name_2.ext] [path/file_name_3.ext]"
    return 1
 else
    for n in $@
    do
      local filename=$(basename "$n")
      local foldername="${filename%%.*}"
      local fullpath=`perl -e 'use Cwd "abs_path";print abs_path(shift)' "$1"`
      local overwrite=true
      if [ -d "$foldername" ]; then
        vared -h -p "$foldername already exists, do you want to overwrite it? (y/n) " -c reply 
        if [[ "$reply" =~ ^[Nn]$ ]]; then
          overwrite=false
        fi
      fi
      if [[ "$overwrite" = true ]] ; then
	echo "$n"
        if [ -f "$n" ] ; then
          case "${n%,}" in
	    *.tar.bz2|*.tbz2)	 tar xvjf ./"$n"    ;;
	    *.tar.gz|*.tgz)	 tar xvzf ./"$n"    ;;
	    *.tar.xz|*.txz|*.tar) tar xvf ./"$n"    ;;
            *.lzma)      unlzma ./"$n"      	;;
            *.bz2)       bunzip2 ./"$n"     	;;
            *.rar)       unrar x -ad ./"$n" 	;;
            *.gz)        gunzip ./"$n"      	;;
            *.zip)       unzip ./"$n"       	;;
            *.z|*.Z)     uncompress ./"$n"  	;;
            *.7z|*.arj|*.cab|*.chm|*.deb|*.dmg|*.iso|*.lzh|*.msi|*.rpm|*.udf|*.wim|*.xar)
		    	 7z x ./"$n"		;;
            *.xz)        unxz ./"$n"		;;
            *.exe)       cabextract ./"$n"	;;
            *)
                         echo "extract: '$n' - unknown archive method"
                         return 1
                         ;;
          esac
        else
          echo "'$n' - file does not exist"
          return 1
        fi
      else
        echo "Not overwriting $n"
      fi
    done
fi
}

function cdn(){
  cmd=""
  for (( i=0; i < $1; i++)) 
    do  
        cmd="$cmd../"
    done
  cd "$cmd"
}    

# make a backup of a file
# https://github.com/grml/grml-etc-core/blob/master/etc/zsh/zshrc
function bk() {
	cp -a "$1" "${1}_$(date --iso-8601=seconds)"
}

function mcd { mkdir $1 && cd $1; }
md5check() { md5sum "$1" | grep "$2";}
backup() { cp -r "$1"{,.bak};}
#function grp(){
#	if (($# <= 2))
#		then echo "Add pipe grep filter"; fi
#	| grep $1
#}

# Gen password
function pw {
	local length=20;
	if (($# > 0)) ; then
		local length=$1;
	fi
	
	</dev/urandom tr -dc 'A-Za-z0-9!"#$%&'\''()*+,-./:;<=>?@[\]^_`{|}~' | head -c $length  ; echo
}

function sear3 {
	if (($# > 0)) ; then
		cat ~/.i3/config | grep $1;
	fi
}
function searz {
	if (($# > 0)) ; then
		cat ~/.zshrc | grep $1;
	fi
}

# Quick add alias
function iz {
	if (($# >= 2)) ; then
		local command_text="alias $1='";
		for n in "${@:2}"; do
			command_text="$command_text$n ";
		done
		echo "$command_text';" >> ~/.zshrc;
		. ~/.zshrc;
	else
		echo 	"Usage: command_alias functions and arguments";
		echo 	"   or: command_alias \"commands | special chars &\"";
	fi
}


function sine_wave() {
	
	i=0
	while true
	do 
		SIN=$(python -c "from math import *;print map( lambda x: ceil(6*sin((x+$i)*pi/5)), range($(tput cols)) )" | tr -d '[]' | spark)
		echo -ne $SIN\\r 
		let i=i+1
		sleep 0.05
	done
	echo
}

function acs() {
	if (($# == 1)) ; then
		aptitude search $1 | grep $1
	fi
}

function ai() {
	if (($# == 1)) ; then
		sudo aptitude install $1 | grep $1
	fi
}


# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"


# Debian


alias ll='exa -l'
alias l='exa'
alias lt='exa -lT'
alias lt2='exa -lT -L 2'
alias la='exa -la'
alias cl='clear'
alias cll='clear; exa'
alias clll='clear; exa -l'
alias aug='sudo aptitude upgrade'
alias au='sudo aptitude update'
alias top10='sudo du -a . | sort -n -r | head -n 10'
alias wl='wal -t -i ~/Pictures/Wallpapers; wal-steam -w'
# install colordiff package :)
alias diff='colordiff'
alias pingg='ping -c 5 google.ca'
alias rmf='rm -rf'
alias vw='view'
alias vpn='openpyn -k; openpyn ca -a toronto -d --max-load 50 -t 6'
alias st='speedtest'
alias tert='echo testing'
## Mirror url
alias mirror='wget --mirror --no-parent --convert-links --adjust-extension --page-requisites'
alias mirrorup='wget -c -N'
## pass options to free ##
alias meminfo='free -m -l -t'
alias wip='dig +short myip.opendns.com @resolver1.opendns.com' 
alias lip='curl -s freegeoip.net/csv/$(wip) | cut -d , -f 3,6'
## get top process eating memory
alias psmem='ps auxf | sort -nr -k 4'
alias psmem10='ps auxf | sort -nr -k 4 | head -10'
 
## get top process eating cpu ##
alias pscpu='ps auxf | sort -nr -k 3'
alias pscpu10='ps auxf | sort -nr -k 3 | head -10'
 
## Get server cpu info ##
alias cpuinfo='lscpu'

#Docker
alias g7='sudo docker run -v /home/mainuser/Git/GraphAlgorithmTesting:/app -it gcc'

#open
alias open='xdg-open'

#FTL mods
alias ftl='cd ~/Steam/SlipstreamModManager_1.9.1-Unix; java -jar modman.jar'

alias vi='nvim'
alias viz='vi ~/.zshrc; . ~/.zshrc' 
alias vi3='vi ~/.i3/config'

alias -g gr='| grep'

alias cw='docker run -v /$HOME/.cache/wal:/wal -it colorwander'

#Compton
#compton

# Import colorscheme from 'wal'
#(wal -t &)


#Reload zsh
#https://superuser.com/questions/570000/source-new-bashrc-in-all-open-terminals/570013#570013
zshrc_sourced=$(stat -c %Y ~/.zshrc)

PROMPT_COMMAND='
    test $(stat -c %Y ~/.zshrc) -ne $zshrc_sourced && source ~/.zshrc
'
alias dcls='docker container ls ';
alias dils='docker images ';
alias dls='dcls && dils'

eval $(thefuck --alias)
alias ds='docker search ';
alias vip='vi /home/mainuser/.config/polybar/config ';
alias vips='vi /home/mainuser/.scripts/polybar.sh ';
alias gits='git status ';
alias gits='git status ';
