#!/bin/bash
RESTORE='\033[0m'
RED='\033[00;31m'
GREEN='\033[00;32m'
YELLOW='\e[0;33m'


# Because nobody wants to keep forgetting commands
# Instructions:
# 1) "source dev.sh"
# 2) "devhelp"
# 3) be happy


workon djangular3  # Change this to your project's virtualenv name

export PROJ_BASE="$(dirname ${BASH_SOURCE[0]})"
CD=$(pwd)
cd $PROJ_BASE
export PROJ_BASE=$(pwd)
cd $CD

#. ci/funcs.sh

function devhelp {
    echo -e "${GREEN}devhelp${RESTORE}           Print this ${RED}help${RESTORE}"
    echo -e ""
    echo -e "${GREEN}pytests${RESTORE}           Runs python ${RED}tests${RESTORE}"
    echo -e ""
    echo -e "${GREEN}djangorun${RESTORE}         Starts the ${RED}django${RESTORE} backend"
    echo -e ""
    echo -e "${GREEN}frontdev${RESTORE}          Builds the frontend in the ${RED}'frontend/dist'${RESTORE} folder,"
    echo -e "                  The resulting html will look for js files inside 'frontend/src'"
    echo -e "                  Parameters:"
    echo -e "                  --mock <true|false> Use mock api (default: true)"
    echo -e ""
    echo -e "${GREEN}frontrun${RESTORE}          Runs the "front-end playground" on port ${RED}9001${RESTORE}"
    echo -e ""
    echo -e "${GREEN}frontprodmock${RESTORE}     Builds the frontend in the ${RED}'frontend/dist'${RESTORE} folder,"
    echo -e "                  The resulting html will look for the concatenated js files inside 'frontend/src'"
    echo -e "                  Uses the ${RED}mock${RESTORE} API"
    echo -e ""
    echo -e "${GREEN}frontprod${RESTORE}         Builds the frontend in the ${RED}'frontend/dist'${RESTORE} folder,"
    echo -e "                  The resulting html will look for the concatenated js files inside 'frontend/src'"
    echo -e "                  Uses the ${RED}real${RESTORE} API"
    echo -e ""
    echo -e "${GREEN}copy2www${RESTORE}          Does a ${RED}prodbuild${RESTORE} copies the resulting css+js"
    echo -e "                  to django's static files folder"
    echo -e ""
    echo -e "${GREEN}runjshint${RESTORE}         Displays a few topics where your ${RED}javascript${RESTORE} can be improved"
    echo -e ""
    echo -e "${GREEN}jstests${RESTORE}           Runs ${RED}javascript tests${RESTORE} (which should be in src/**/docs/test_*.js)"
    echo -e "                  Parameters:"
    echo -e "                  --singleRun <true|false> Runs tests ${RED}just once${RESTORE}; Default=false (run again everytime a file changes)"
    echo -e "                  --coverage <true|false> generate test coverage report on folder ${GREEN}frontend/coverage/${RESTORE} (default: false)"
    echo -e ""
    echo -e "${GREEN}produce_alias${RESTORE}     Prints instructions to create a permanent shortcut"
    echo -e "                  for this project's development environment"
    echo -e ""
}

function pytests {
    CD=$(pwd)
    cd $PROJ_BASE
    dorun "./manage.py test cameras" "Python tests"
    exitcode=$?
    cd $CD
    return $exitcode
}

function djangorun {
    CD=$(pwd)
    cd $PROJ_BASE
    dorun "./manage.py runserver" "Django server"
    exitcode=$?
    cd $CD
    return $exitcode
}

function frontdev {
    CD=$(pwd)
    cd $PROJ_BASE/frontend
    dorun "gulp dev $*" "Dev Build"
    exitcode=$?
    cd $CD
    return $exitcode
}

function frontprodmock {
    CD=$(pwd)
    cd $PROJ_BASE/frontend
    dorun "gulp prod --mock true" "Prod build with mock API"
    exitcode=$?
    cd $CD
    return $exitcode
}

function frontprod {
    CD=$(pwd)
    cd $PROJ_BASE/frontend
    dorun "gulp prod --mock false" "Prod build - real deal"
    exitcode=$?
    cd $CD
    return $exitcode
}

function copy2www {
    CCD=$(pwd)
    cd $PROJ_BASE/frontend
    frontprod
    mkdir -p ../cameras/static/
    cp -Rf dist/js dist/css ../cameras/static/
    cd $CCD
    return $exitcode
}

function frontrun {
    CD=$(pwd)
    cd $PROJ_BASE/frontend
    gulp runserver
    exitcode=$?
    cd $CD
    return $exitcode
}

function runjshint {
    CD=$(pwd)
    cd $PROJ_BASE/frontend
    dorun "gulp jshintall" "JS Hint"
    exitcode=$?
    cd $CD
    return $exitcode
}

function jstests {
    CD=$(pwd)
    cd $PROJ_BASE/frontend
    dorun "gulp test $*" "JS tests"
    exitcode=$?
    cd $CD
    return $exitcode
}

function produce_alias {
    echo "------------------------------------------------------------------------"
    echo "This green command will create an alias that you can use"
    echo "to drop on this project's environment from anywhere in your terminal"
    echo "Tip: add it to your ~/.bashrc"
    echo "Tip2: Rename this alias according to your project's name"
    echo "------------------------------------------------------------------------"
    echo_green "alias dj3='cd $(readlink -e $PROJ_BASE) && . dev.sh'"
    echo "------------------------------------------------------------------------"
}

function echo_red {
    echo -e "\e[31m$1\e[0m";
}

function echo_green {
    echo -e "\e[32m$1\e[0m";
}

function echo_yellow {
    echo -e "${YELLOW}$1${RESTORE}";
}

function now_milis {
    date +%s%N | cut -b1-13
}

function dorun {
    cmd="$1"
    name="$2"
    echo ----------------------------------
    echo_green "STARTING $name ..."
    echo "$cmd"
    t1=$(now_milis)
    $cmd
    exitcode=$?
    t2=$(now_milis)
    delta_t=$(expr $t2 - $t1)
    if [ $exitcode == 0 ]
    then
        echo_green "FINISHED $name in $delta_t ms"
        echo ----------------------------------
    else
        echo_red "ERROR! $name (status: $exitcode, time: $delta_t ms)"
        echo ----------------------------------
        return $exitcode
    fi
}

echo_green "Welcome, blablabla, customize this message as desired:"
echo_green "Tip: You have autocomplete for the commands below ;)"
echo_red   "------------------------------------------------------------------------"
devhelp
