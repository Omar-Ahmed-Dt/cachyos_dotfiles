#!/bin/bash
command=$(uptime -p | sed 's/^up //; s/days/d/; s/hours/h/; s/minutes/m/')
echo "  $command"
