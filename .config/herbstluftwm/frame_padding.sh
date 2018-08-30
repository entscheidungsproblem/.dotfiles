#!/bin/bash

case $1 in
    up)
	let "p= $(herbstclient get frame_padding) + 5"
	herbstclient set frame_padding $p
	;;
    down)
	let "p= $(herbstclient get frame_padding) - 5"
	herbstclient set frame_padding $p
	;;
esac
