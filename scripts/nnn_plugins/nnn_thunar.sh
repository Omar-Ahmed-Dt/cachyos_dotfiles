#!/bin/sh

file="$(realpath "$1")"

setsid thunar --select "$file" >/dev/null 2>&1 &
