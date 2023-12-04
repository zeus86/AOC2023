#!/bin/bash

INPUT=input
max_blue=14
max_red=12
max_green=13

# clear logs
> s1_possible
> s1_impossible
> s1_final

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
			declare "max=max_$color"
			echo "max: ${!max}"
			[[ $highest -gt $max ]] && possible=1
			[[ $highest -le $max ]] && possible=0
			[[ $possible -eq 1 ]] && echo "impossible for $color";
			[[ $possible -eq 1 ]] && echo "$ID $color" >> s1_impossible
			[[ $possible -eq 0 ]] && echo "possible for $color";
			[[ $possible -eq 0 ]] && echo "$ID $color" >> s1_possible
		done
		grep -q ^"$ID red"$ s1_possible && grep -q ^"$ID green"$ s1_possible && grep -q ^"$ID blue"$ s1_possible && echo "$ID" >> s1_final
	done < $INPUT
			echo "final score:"
			paste -sd+ s1_final| bc
exit 0
