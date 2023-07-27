################################################################
#      ....           ....           ....           ....       #
#     ||             ||             ||             ||          #
#  /"""l|\        /"""l|\        /"""l|\        /"""l|\        #
# /_______\      /_______\      /_______\      /_______\       # 
# |  .-.  |------|  .-.  |------|  .-.  |------|  .-.  |------ #
#  __|L|__| .--. |__|L|__| .--. |__|L|__| .--. |__|L|__| .--.  #
# _\  \\p__`o-o'__\  \\p__`o-o'__\  \\p__`o-o'__\  \\p__`o-o'_ #
# ------------------------------------------------------------ #
# ------------------------------------------------------------ #
#                                                              #
#   There's no place like 127.0.0.1                            #
#                                                              #
################################################################

# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# Export for awesome configs
export XDG_CONFIG_DIRS=~/.config
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
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Correct dir spellings
shopt -q -s cdspell
 
# Make sure display get updated when terminal window get resized
shopt -q -s checkwinsize
 
# Turn on the extended pattern matching features 
shopt -q -s extglob
 
# Append rather than overwrite history on exit
shopt -s histappend
 
# Make multi-line commandsline in history
shopt -q -s cmdhist 
 
# Get immediate notification of bacground job termination
set -o notify 
 
# Disable [CTRL-D] which is used to exit the shell
set -o ignoreeof

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

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

#tea timer
alias teatimer='$(STEEP=300; sleep $STEEP; xmessage "Your tea is done") &'

# reload bashrc fast
alias rl='. ~/.bashrc'

# autocomplete ssh commands
complete -W "$(echo `cat ~/.bash_history | egrep '^ssh ' | sort | uniq | sed 's/^ssh //'`;)" ssh

###### Brute force way to block all LSO cookies on Linux system with non-free Flash browser plugin
for A in ~/.adobe ~/.macromedia ; do ( [ -d $A ] && rm -rf $A ; ln -s -f /dev/null $A ) ; done

# get current hour (24 clock format i.e. 0-23)
hour=$(date +"%H")
# if it is midnight to midafternoon will say G'morning
if [ $hour -ge 0 -a $hour -lt 12 ]
then
   greet="Good Morning, $USER. Welcome back."
# if it is midafternoon to evening ( before 6 pm) will say G'noon
elif [ $hour -ge 12 -a $hour -lt 18 ]
then
greet="Good Afternoon, $USER. Welcome back."
else # it is good evening till midnight
   greet="Good Evening, $USER. Welcome back."
fi
# display greeting
   echo $greet

##################################################
# OpenPGP/GPG pubkeys stuff (for Launchpad / etc.#
##################################################

###### add keys
alias addkey='sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys'



###### autograb missing keys
alias autokey='sudo apt-get update 2> /tmp/keymissing; for key in $(grep "NO_PUBKEY" /tmp/keymissing |sed "s/.*NO_PUBKEY //"); do echo -e "\nProcessing key: $key"; gpg --keyserver pool.sks-keyservers.net --recv $key && gpg --export --armor $key | sudo apt-key add -; done'



###### create mykeys for use on Launchpad / etc.
alias createmykeys='gpg --gen-key'



###### show single repo key info using keyid found in 'sudo apt-key list'
alias exportkey='sudo apt-key export'



###### exports all repo keys info into single 'repokeys.txt' document
alias exportkeys='sudo apt-key exportall > repokeys.txt'



###### to export public OpenPGP keys to a file for safe keeping and potential restoration
alias exportmykeys='exportmykeys_private && exportmykeys_public'



###### to export private OpenPGP keys to a file for safe keeping and potential restoration
# using 'mykeys', put the appropriate GPG key after you type this function
function exportmykeys_private()
{
gpg --list-secret-keys
echo -n "Please enter the appropriate private key...
Look for the line that starts something like "sec 1024D/".
The part after the 1024D is the key_id.
...like this: '2942FE31'...

"
read MYKEYPRIV
gpg -ao Private_Keys-private.key --export-secret-keys "$MYKEYPRIV"
echo -n "All done."
}



###### to export public OpenPGP keys to a file for safe keeping and potential restoration
# using 'mykeys', put the appropriate GPG key after you type this function
function exportmykeys_public()
{
gpg --list-keys
echo -n "Please enter the appropriate public key...
Look for line that starts something like "pub 1024D/".
The part after the 1024D is the public key_id.
...like this: '2942FE31'...

"
read MYKEYPUB
gpg -ao Public_Keys-public.key --export "$MYKEYPUB"
echo -n "All done."
}



###### to get the new key fingerprint for use in the appropriate section on Launchpad.net to start verification process
alias fingerprintmykeys='gpg --fingerprint'



###### to automatically get all pubkeys (Launchpad PPA ones and others)
# requires: sudo apt-get install launchpad-getkeys
alias getkeys='sudo launchpad-getkeys'



###### to get a list of your public and private OpenPGP/GPG pubkeys
alias mykeys='gpg --list-keys && gpg --list-secret-keys'



###### publish newly-created mykeys for use on Launchpad / etc.
alias publishmykeys='gpg --keyserver hkp://keyserver.ubuntu.com --send-keys'



###### to restore your public and private OpenPGP keys
# from Public_Key-public.key and Private_Keys-private.key files:
function restoremykeys()
{
echo -n "Please enter the full path to Public keys (spaces are fine)...

Example: '/home/(your username)/Public_Key-public.key'...

"
read MYKEYS_PUBLIC_LOCATION
gpg --import "$MYKEYS_PUBLIC_LOCATION"
echo -n "Please enter the full path to Private keys (spaces are fine)...

Example: '/home/(your username)/Private_Keys-private.key'...

"
read MYKEYS_PRIVATE_LOCATION
gpg --import "$MYKEYS_PRIVATE_LOCATION"
echo -n "All done."
}



###### to setup new public and private OpenPGP keys
function setupmykeys()
{
# Generate new key
gpg --gen-key
# Publish new key to Ubuntu keyserver
gpg --keyserver hkp://keyserver.ubuntu.com --send-keys
# Import an OpenPGP key
gpg --fingerprint
# Verify new key
read -sn 1 -p "Before you continue, you must enter the fingerprint
in the appropriate place in your Launchpad PPA on their website...

Once you have successfully inputed it, wait for your email before
you press any key to continue...

"
gedit $HOME/file.txt
read -sn 1 -p "Once you have received your email from Launchpad to
verify your new key, copy and paste the email message received upon
import of OpenPGP key from "-----BEGIN PGP MESSAGE-----" till
"-----END PGP MESSAGE-----" to the 'file.txt' in your home folder
that was just opened for you

Once you have successfully copied and pasted it, save it and
press any key to continue...

"
gpg -d $HOME/file.txt
echo -n "All done."
}



###### shows list of repository keys
alias showkeys='sudo apt-key list'

###### check if a remote port is up using dnstools.com
# (i.e. from behind a firewall/proxy)
function cpo() { [[ $# -lt 2 ]] && echo 'need IP and port' && return 2; [[ `wget -q "http://dnstools.com/?count=3&checkp=on&portNum=$2&target=$1&submit=Go\!" -O - |grep -ic "Connected successfully to port $2"` -gt 0 ]] && echo OPEN || echo CLOSED; }

##### show tcp/ip ports #####
alias ports='netstat -tulanp'

##### 5 will do #####
alias ping='ping -c 5'

###### find an unused unprivileged TCP port
function findtcp()
{
(netstat  -atn | awk '{printf "%s\n%s\n", $4, $4}' | grep -oE '[0-9]*$'; seq 32768 61000) | sort -n | uniq -u | head -n 1
}

###### geoip lookup (need geoip database: sudo apt-get install geoip-bin)
function geoip() {
geoiplookup $1
}



###### geoip information
# requires 'html2text': sudo apt-get install html2text
function geoiplookup() { curl -A "Mozilla/5.0" -s "http://www.geody.com/geoip.php?ip=$1" | grep "^IP.*$1" | html2text; }



###### get IP address of a given interface
# Example: getip lo
# Example: getip eth0	# this is the default
function getip()		{ lynx -dump https://wtfismyip.com/text; }



###### display private IP
function ippriv()
{
    ifconfig eth0|grep "inet adr"|awk '{print $2}'|awk -F ':' '{print $2}'
}



###### ifconfig connection check
function ips()
{
    if [ "$OS" = "Linux" ]; then
        for i in $( /sbin/ifconfig | grep ^e | awk '{print $1}' | sed 's/://' ); do echo -n "$i: ";  /sbin/ifconfig $i | perl -nle'/dr:(\S+)/ && print $1'; done
    elif [ "$OS" = "Darwin" ]; then
        for i in $( /sbin/ifconfig | grep ^e | awk '{print $1}' | sed 's/://' ); do echo -n "$i: ";  /sbin/ifconfig $i | perl -nle'/inet (\S+)/ && print $1'; done
    fi
}



###### geolocate a given IP address
function ip2loc() { wget -qO - www.ip2location.com/$1 | grep "<span id=\"dgLookup__ctl2_lblICountry\">" | sed 's/<[^>]*>//g; s/^[\t]*//; s/&quot;/"/g; s/</</g; s/>/>/g; s/&amp;/\&/g'; }

###### find the IP addresses that are currently online in your network
function localIps()
{
for i in {1..254}; do
	x=`ping -c1 -w1 192.168.1.$i | grep "%" | cut -d"," -f3 | cut -d"%" -f1 | tr '\n' ' ' | sed 's/ //g'`
	if [ "$x" == "0" ]; then
		echo "192.168.1.$i"
	fi
done
}



###### myip - finds your current IP if your connected to the internet
function myip()
{
lynx -dump -hiddenlinks=ignore -nolist http://checkip.dyndns.org:8245/ | awk '{ print $4 }' | sed '/^$/d; s/^[ ]*//g; s/[ ]*$//g'
}



###### netinfo - shows network information for your system
function netinfo()
{
echo "--------------- Network Information ---------------"
/sbin/ifconfig | awk /'inet addr/ {print $2}'
/sbin/ifconfig | awk /'Bcast/ {print $3}'
/sbin/ifconfig | awk /'inet addr/ {print $4}'
/sbin/ifconfig | awk /'HWaddr/ {print $4,$5}'
myip=`lynx -dump -hiddenlinks=ignore -nolist http://checkip.dyndns.org:8245/ | sed '/^$/d; s/^[ ]*//g; s/[ ]*$//g' `
echo "${myip}"
echo "---------------------------------------------------"
}



###### check whether or not a port on your box is open
function portcheck() { for i in $@;do curl -s "deluge-torrent.org/test-port.php?port=$i" | sed '/^$/d;s/<br><br>/ /g';done; }

#============================================================
#
#  FUN STUFF
##============================================================

###### pretend to be busy in office to enjoy a cup of coffee
function grepcolor()
{
cat /dev/urandom | hexdump -C | grep --color=auto "ca fe"
}

###### a simple number guessing game
function hilow()
{
biggest=1000                            # maximum number possible
guess=0                                 # guessed by player
guesses=0                               # number of guesses made
number=$(( $$ % $biggest ))             # random number, 1 .. $biggest
while [ $guess -ne $number ] ; do
  echo -n "Guess? " ; read guess
  if [ "$guess" -lt $number ] ; then
    echo "... bigger!"
  elif [ "$guess" -gt $number ] ; then
    echo "... smaller!"
  fi
  guesses=$(( $guesses + 1 ))
done
echo "Right!! Guessed $number in $guesses guesses."
}


###### watch the National debt clock
function natdebt()
{
watch -n 10 "wget -q http://www.brillig.com/debt_clock -O - | grep debtiv.gif | sed -e 's/.*ALT=\"//' -e 's/\".*//' -e 's/ //g'"
}


function oneliners()
{
w3m -dump_source http://www.onelinerz.net/random-one-liners/1/ | awk ' /.*<div id=\"oneliner_[0-9].*/ {while (! /\/div/ ) { gsub("\n", ""); getline; }; gsub (/<[^>][^>]*>/, "", $0); print $0}'
}


###### random cowsay stuff
function random_cow()
{
  files=(/usr/share/cowsay/cows/*)
  printf "%s\n" "${files[RANDOM % ${#files}]}"
}


#============================================================
#
#  ALIASES AND FUNCTIONS
##============================================================

function lsofg()
{
    if [ $# -lt 1 ] || [ $# -gt 1 ]; then
        echo "grep lsof"
        echo "usage: losfg [port/program/whatever]"
    else
        lsof | grep -i $1 | less
    fi
}

function psg()
{
    if [ $# -lt 1 ] || [ $# -gt 1 ]; then
        echo "grep running processes"
        echo "usage: psg [process]"
    else
        ps aux | grep USER | grep -v grep
        ps aux | grep -i $1 | grep -v grep
    fi
}


###### convert arabic to roman numerals
# Copyright 2007 - 2010 Christopher Bratusek
function arabic2roman() {

  echo $1 | sed -e 's/1...$/M&/;s/2...$/MM&/;s/3...$/MMM&/;s/4...$/MMMM&/
s/6..$/DC&/;s/7..$/DCC&/;s/8..$/DCCC&/;s/9..$/CM&/
s/1..$/C&/;s/2..$/CC&/;s/3..$/CCC&/;s/4..$/CD&/;s/5..$/D&/
s/6.$/LX&/;s/7.$/LXX&/;s/8.$/LXXX&/;s/9.$/XC&/
s/1.$/X&/;s/2.$/XX&/;s/3.$/XXX&/;s/4.$/XL&/;s/5.$/L&/
s/1$/I/;s/2$/II/;s/3$/III/;s/4$/IV/;s/5$/V/
s/6$/VI/;s/7$/VII/;s/8$/VIII/;s/9$/IX/
s/[0-9]//g'

}



###### convert ascii
# copyright 2007 - 2010 Christopher Bratusek
function asc2all() {
	if [[ $1 ]]; then
		echo "ascii $1 = binary $(asc2bin $1)"
		echo "ascii $1 = octal $(asc2oct $1)"
		echo "ascii $1 = decimal $(asc2dec $1)"
		echo "ascii $1 = hexadecimal $(asc2hex $1)"
		echo "ascii $1 = base32 $(asc2b32 $1)"
		echo "ascii $1 = base64 $(asc2b64 $1)"
	fi
}



function asc2bin() {
	if [[ $1 ]]; then
		echo "obase=2 ; $(asc2dec $1)" | bc
	fi
}



function asc2b64() {
	if [[ $1 ]]; then
		echo "obase=64 ; $(asc2dec $1)" | bc
	fi
}



function asc2b32() {
	if [[ $1 ]]; then
		echo "obase=32 ; $(asc2dec $1)" | bc
	fi
}



function asc2dec() {
	if [[ $1 ]]; then
		printf '%d\n' "'$1'"
	fi
}



function asc2hex() {
	if [[ $1 ]]; then
		echo "obase=16 ; $(asc2dec $1)" | bc
	fi
}



function asc2oct() {
	if [[ $1 ]]; then
		echo "obase=8 ; $(asc2dec $1)" | bc
	fi
}

###### simple calculator to 4 decimals
function calc() {
echo "scale=4; $1" | bc
}


###### temperature conversion script that lets the user enter
# a temperature in any of Fahrenheit, Celsius or Kelvin and receive the
# equivalent temperature in the other two units as the output.
# usage:	convertatemp F100 (if don't put F,C, or K, default is F)
function convertatemp()
{
if uname | grep 'SunOS'>/dev/null ; then
  echo "Yep, SunOS, let\'s fix this baby"
  PATH="/usr/xpg4/bin:$PATH"
fi
if [ $# -eq 0 ] ; then
  cat << EOF >&2
Usage: $0 temperature[F|C|K]
where the suffix:
   F	indicates input is in Fahrenheit (default)
   C	indicates input is in Celsius
   K	indicates input is in Kelvin
EOF
fi
unit="$(echo $1|sed -e 's/[-[[:digit:]]*//g' | tr '[:lower:]' '[:upper:]' )"
temp="$(echo $1|sed -e 's/[^-[[:digit:]]*//g')"
case ${unit:=F}
in
  F ) # Fahrenheit to Celsius formula:  Tc = (F -32 ) / 1.8
  farn="$temp"
  cels="$(echo "scale=2;($farn - 32) / 1.8" | bc)"
  kelv="$(echo "scale=2;$cels + 273.15" | bc)"
  ;;
  C ) # Celsius to Fahrenheit formula: Tf = (9/5)*Tc+32
  cels=$temp
  kelv="$(echo "scale=2;$cels + 273.15" | bc)"
  farn="$(echo "scale=2;((9/5) * $cels) + 32" | bc)"
  ;;
  K ) # Celsius = Kelvin + 273.15, then use Cels -> Fahr formula
  kelv=$temp
  cels="$(echo "scale=2; $kelv - 273.15" | bc)"
  farn="$(echo "scale=2; ((9/5) * $cels) + 32" | bc)"
esac
echo "Fahrenheit = $farn"
echo "Celsius    = $cels"
echo "Kelvin     = $kelv"
}

#Docker shortcuts
alias drm="sudo docker rm"
alias dps="sudo docker ps"
alias drmall="sudo docker rm -v $(docker ps -a -q)"
alias drmiall="sudo docker rmi $(docker images -a -q)"
alias dps="sudo docker ps"
function dstop() { sudo docker stop "$@" ;}
alias dstopall="sudo docker stop $(docker ps -a -q)"
function dlogs() { sudo docker logs "$@" ;}

# Add Docker run function shortcuts here

# GIT shortcuts
alias gb='git branch'
alias gba='git branch -a'
alias gc='git commit -a -v'
alias gd='git diff | mate'
alias gl='git pull'
alias gp='git push'
alias gpp='git pull;git push'
alias gppd='git pull origin dev;git push origin dev'
alias gst='git status'
alias ga='git add . -v'
alias gs='git status'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gitrollback='git reset --hard; git clean -f'
alias gunadd='git reset HEAD'
alias gdiff='git diff HEAD~1 HEAD'

# git functions
function rbr {
 git checkout $1;
 git pull origin $1;
 git checkout $2;
 git rebase $1;
}

function mbr {
 git checkout $1;
 git merge $2
 git push origin $1;
 git checkout $2;
}

# list mounts in pretty column
alias mls='mount | column -t'

# Open chromium web browser
alias chrome='chromium-browser'

# Open giphyTV 
alias giphytv='chromium-browser --app="http://tv.giphy.com/giphytrending" --window-size=600,600'

# Open Slack in browser - set yourgroup to prefered group
alias slack='chromium-browser --app="https://yourgroup.slack.com/messages/general" --window-size=600,600'

# Show disk information
alias disk='df -h | grep -e /dev/sd -e Filesystem'


# Show terminal history
alias h='history'

#Oops forgot again
alias apt-get='sudo apt-get'
alias update='sudo apt-get update && sudo apt-get upgrade'

# if user is not root, pass all commands via sudo #
#if [ $UID -ne 0 ]; then
#    alias reboot='sudo reboot'
#    alias update='sudo apt-get upgrade'
#fi

# nginx if using it
# also pass it via sudo so whoever is admin can reload it without calling you #
#alias nginxreload='sudo /usr/local/nginx/sbin/nginx -s reload'
#alias nginxtest='sudo /usr/local/nginx/sbin/nginx -t'
#alias lightyload='sudo /etc/init.d/lighttpd reload'
#alias lightytest='sudo /usr/sbin/lighttpd -f /etc/lighttpd/lighttpd.conf -t'
#alias httpdreload='sudo /usr/sbin/apachectl -k graceful'
#alias httpdtest='sudo /usr/sbin/apachectl -t && /usr/sbin/apachectl -t -D DUMP_VHOSTS'

#Say no to cd hell
## a quick way to get out of current directory ##
alias ..='cd ..'
alias ...='cd ../../../'
alias ....='cd ../../../../'
alias .....='cd ../../../../'
alias .4='cd ../../../../'
alias .5='cd ../../../../..'

#OpenVPN connections change to your ovpn path
alias nmprod='sudo openvpn --client --up ~/.openvpn/ovpn-dns-fix --down ~/.openvpn/ovpn-dns-fix --script-security 2 --config ~/.openvpn/prod-client.ovpn'
alias vpndev='sudo openvpn --client --config ~/.openvpn/dev-client.ovpn'

## this one saved my ass many times ##
alias wget='wget -c'

#A clean screen is a clean screen
alias c='clear'

# List current jobs
alias j='jobs -l'

#It's just better need to install htop to use
alias top='htop'

#headers are helpful
# get web server headers #
alias header='curl -I'
 
# find out if remote server supports gzip / mod_deflate or not #
alias headerc='curl -I --compress'

function encode() { echo -n $@ | perl -pe's/([^-_.~A-Za-z0-9])/sprintf("%%%02X", ord($1))/seg'; }
# Search google by typing 'google argument' where argument is your search
function google() { chromium-browser http://www.google.com/search?hl=en#q="`encode $@`" ;}


# Search yahoo
function yahoo() { chromium-browser http://search.yahoo.com/search?p="`encode $@`" ;}


# Search bing
function bing() { chromium-browser http://www.bing.com/search?q="`encode $@`" ;}


# Search amazon
function amazon() { chromium-browser http://www.amazon.com/s/ref=nb_ss?field-keywords="`encode $@`" ;}


# Search wikipedia
function wiki() { chromium-browser http://en.wikipedia.org/w/index.php?search="`encode $@`" ;}


# Wikipedia in terminal
function wp() { wikipedia2text "`encode $@`" | more ;}

# destroy all docker containers..
docker-purge()
{
  docker ps -aq | while read x; do docker stop $x; docker rm $x; done
}
