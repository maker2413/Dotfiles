#!/usr/bin/env bash

function run {
    if ! pgrep -f $1 ;
    then
	$@&
    fi
}

run nitrogen --restore
run xset b off
