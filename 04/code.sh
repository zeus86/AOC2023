#!/bin/bash

INPUT=input
DEBUG=0
TMPFILE=counter
# clear logs
> s1
> s1_1
while read -r line
        do 
                ID=$(echo "$line" | tr -s [:space:] | cut -f 2 -d " " | cut -f 1 -d ":" );
		HAVENUMS=$(echo "$line" | cut -f 2 -d ":" | cut -f 2 -d "|" | sed s/\ /\\n/g | sort -n | sed s/\\n/\ /g);
		WINNUMS=$(echo "$line" | cut -f 2 -d ":" | cut -f 1 -d "|" | sed s/\ /\\n/g | sort -n | sed s/\\n/\ /g);
		[[ $DEBUG -eq 1 ]] && echo "Card $ID"
		[[ $DEBUG -eq 1 ]] && echo "have-numbers:" && echo $HAVENUMS
		[[ $DEBUG -eq 1 ]] && echo "win-numbers:" && echo $WINNUMS
		echo 0 > $TMPFILE
		for num in $WINNUMS; do
			HITCOUNT=$(cat $TMPFILE)
			[[ $DEBUG -eq 1 ]] && echo "NUM: $num"
			echo $HAVENUMS | grep -q -e " $num " -e ^"$num " -e " $num"$ && \
			HITCOUNT=$[$(cat $TMPFILE) + 1] && echo $HITCOUNT > $TMPFILE && \
			[[ $DEBUG -eq 1 ]] && echo hit && echo "new HITCOUNT: $HITCOUNT" 
	done
	# note number of hits to s1
	echo "Card $ID $(cat $TMPFILE)" >> s1
	# note score-value to s1_1
	[[ $HITCOUNT -ne 0 ]] && \
		echo -n "Card $ID " >> s1_1 && \
		echo $(echo "2"; echo "^"; cat $TMPFILE )| \
		tr -d [:space:] | paste -sd "" | bc >> s1_1
	unlink $TMPFILE
	done < $INPUT 

# calculate final point-value
echo "final score:"
echo $(cat s1_1 | cut -d " " -f 3 | paste -sd+ | bc)/2 | bc

exit 0
