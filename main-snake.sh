#!/bin/bash

set_border() {
   # Draw top
   tput setaf 7 #7-> setting foreground(text) color as White
   tput cup $ROW_BEG $COL_BEG
   x=$COL_BEG
   while [ "$x" -le "$COL_END" ];
   do
      echo -n "X"
      # x=$(( $x + 1 ));
      let x=x+1;
   done

   # Draw sides
   x=$ROW_BEG
   while [ "$x" -le "$ROW_END" ];
   do
      tput cup $x $COL_BEG
      echo -n "X"

      tput cup $x $COL_END
      echo -n "X"
      let x=x+1;
   done

   # Draw bottom
   tput cup $ROW_END $COL_BEG
   x=$COL_BEG
   while [ "$x" -le "$COL_END" ];
   do
      echo -n "X"
      let x=x+1;
   done
   # tput setf 9
   echo
}

reset_terminal(){
	clear
	set_border
}

set_snake_in_mid(){
	POSMX=$(($(($ROW_BEG+$ROW_END))/2))
	# echo $POSMX

	POSMY=$(($(($COL_BEG+$COL_END))/2))
	# echo $POSMY

	tput cup $POSMX $POSMY
	tput setaf 7 #7-> setting foreground(text) color as White
	echo "*"

	return
}

detect_collision(){
	if [ "$POSY" -le "$COL_BEG" ] || [ "$POSY" -ge "$COL_END" ] ; then
		reset_terminal
		set_snake_in_mid
		POSX=$POSMX
		POSY=$POSMY

   elif [ "$POSX" -le "$ROW_BEG" ] || [ "$POSX" -ge "$ROW_END" ] ; then
      	reset_terminal
		set_snake_in_mid
		POSX=$POSMX
		POSY=$POSMY
   fi

}

byebye(){
	# echo "in byebye"
	tput cvvis #makes cursor visible again
	# stty echo
	# tput reset --> clears everything on screen
	tput cup $((ROW_END + 3)) 0
	exit 0
}

move_snake(){
    detect_collision $POSX $POSY
    tput cup $POSX $POSY
    tput setaf $color
    echo -n "*"
}


#------------------------------> START HERE <----------------------------------------------
ROW_BEG=1
ROW_END=20
COL_BEG=11
COL_END=50

clear
# stty -echo
tput civis #hides the cursor
set_border
set_snake_in_mid

POSX=$POSMX
POSY=$POSMY

# trap byebye SIGINT

# echo $POSY
# c=w
# count=0

let color=$RANDOM%7

flag=1
 # flag:
 # 1-> "w" key i.e up direction
 # 2-> "s" key i.e down direction
 # 3-> "a" key i.e left
 # 4-> "d" key i.e right
 # flags have been set to handle coloring

read -s -t 1.25 -n 1 c
if [ "$c" == "w" ]; then
	let flag=1
elif [ "$c" == "s" ]; then
	let flag=2
elif [ "$c" == "a" ]; then
	let flag=3
elif [ "$c" == "d" ]; then
	let flag=4
fi

while [ true ]; do

	trap byebye 2
	
	if [ "$c" == "w" ]; then
		if [ $flag -ne 1 ]; then 
			let color=$RANDOM%7
		fi
		while [ true ] ; do
			read -s -t 0.25 -n 1 c
			if [ $? = 0 ] ; then
				break
			else
				POSX=$(( $POSX - 1 ))
				move_snake $POSX $POSY $color
			fi
			flag=1
		done

	elif [ "$c" == "s" ]; then
		if [ $flag -ne 2 ]; then 
			let color=$RANDOM%7
		fi
		while [ true ] ; do
			read -s -t 0.25 -n 1 c
			if [ $? = 0 ] ; then
				break
			else
				POSX=$(( $POSX + 1 ))
				move_snake $POSX $POSY $color
			fi
			flag=2
		done

	elif [ "$c" == "a" ]; then
		if [ $flag -ne 3 ]; then 
			let color=$RANDOM%7
		fi
		while [ true ] ; do
			read -s -t 0.25 -n 1 c
			if [ $? = 0 ] ; then
				break
			else
				POSY=$(( $POSY - 1 ))
				move_snake $POSX $POSY $color
			fi
			flag=3
		done

	elif [ "$c" == "d" ]; then
		if [ $flag -ne 4 ]; then 
			let color=$RANDOM%7
		fi
		while [ true ] ; do
			read -s -t 0.25 -n 1 c
			if [ $? = 0 ] ; then
				break
			else
				POSY=$(( $POSY + 1 ))
				move_snake $POSX $POSY $color
			fi
			flag=4
		done

	fi

done



