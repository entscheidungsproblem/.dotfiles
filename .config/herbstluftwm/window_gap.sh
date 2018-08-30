#!/bin/bash

case $1 in
    up)
	let "p= $(herbstclient get window_gap) + 5"
	herbstclient set window_gap $p
	;;
    down)
	let "p= $(herbstclient get window_gap) - 5"
	herbstclient set window_gap $p
	;;
esac
