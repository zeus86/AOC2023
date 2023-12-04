#!/bin/bash

INPUT=input
max_blue=14
max_red=12
max_green=13

# clear logs
> s2_max
> s2_final

while read -r line
	do 
		ID=$(echo "$line" | cut -f 2 -d " " | cut -f 1 -d ":" ); 
		for color in blue green red; do
			value=$(echo "$line" | cut -f 2- -d ":" | sed s/\;/\\n/g | sed s/\,/\\n/g | grep $color | sed s/$color//g)
			echo "Game $ID $color:"
			echo $value
			sum=$(echo "$value" | paste -sd+ | bc)
			highest=$(echo "$value" | paste  -d\ | sort -nr | head -n1 | tr -d [:space:])
			echo "sum: $sum"
			echo "highest: $highest"
			echo "$ID $color $highest" >> s2_max
		done
		grep ^"$ID " s2_max | cut -f 3 -d " " | paste -sd* | bc >> s2_final
	done < $INPUT
			echo "final score:"
			paste -sd+ s2_final| bc
exit 0
