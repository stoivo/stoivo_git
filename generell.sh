
function echo_red_text {
  echo -e ${Red}$1${NC} $2
}
function echo_blue_text {
  echo -e ${Blue}$1${NC} $2
}
function echo_yellow_text {
  echo -e "${Yellow}$1${NC} $2"
}
function echo_ligth_blue_text {
  echo -e "${Light_Blue}$1${NC} $2"
}

function parse_yaml {
  local prefix=$2
  local s='[[:space:]]*' w='[a-zA-Z0-9_]*' fs=$(echo @|tr @ '\034')
  sed -ne "s|^\($s\):|\1|" \
      -e "s|^\($s\)\($w\)$s:$s[\"']\(.*\)[\"']$s\$|\1$fs\2$fs\3|p" \
      -e "s|^\($s\)\($w\)$s:$s\(.*\)$s\$|\1$fs\2$fs\3|p"  $1 |
  awk -F$fs '{
    indent = length($1)/2;
    vname[indent] = $2;
    for (i in vname) {if (i > indent) {delete vname[i]}}
    if (length($3) > 0) {
       vn=""; for (i=0; i<indent; i++) {vn=(vn)(vname[i])("_")}
       printf("%s%s%s=\"%s\"\n", "'$prefix'",vn, $2, $3);
    }
  }'
}

Black='\e[0;30m'
Dark_Gray='\e[1;30m'
Blue='\e[0;34m'
Light_Blue='\e[1;34m'
Green='\e[0;32m'
Light_Green='\e[1;32m'
Cyan='\e[0;36m'
Light_Cyan='\e[1;36m'
Red='\e[0;31m'
Light_Red='\e[1;31m'
Purple='\e[0;35m'
Light_Purple='\e[1;35m'
Brown_Orange='\e[0;33m'
Yellow='\e[1;33m'
Light_Gray='\e[0;37m'
White='\e[1;37m'
NC='\e[0m'

function load_all_extra_fils {
  startPATH=`pwd`
  cd /home/simon/.bash
  if [[ -f fakturabank_function.sh ]]; then
    source fakturabank_function.sh
  fi
  if [[ -f toivo_line.sh ]]; then
    source toivo_line.sh
  fi
  if [[ -f awsome_git_voodoo.sh ]]; then
    source awsome_git_voodoo.sh
  fi
  if [[ -f alias.sh ]]; then
    source alias.sh
  fi
  if [[ -f dark_git_voodoo.sh ]]; then
    source dark_git_voodoo.sh
  fi
  notify-send -i info 'Du er klar for alt, alle filer er lastet, Det er nye eventyr i dag'
  cd $startPATH
}

function truncate_file {
  if [[ -f $1 ]]; then
    rm $1
  fi
  touch $1
}
