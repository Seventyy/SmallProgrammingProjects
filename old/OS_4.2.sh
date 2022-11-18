#!/usr/bin/bash
if [ $# -gt 3 ]
then
  echo "Error: Incorrect number of arguments. Write rps_game -h to display the help page." 1>&2
  exit 0
fi

for i in "$@"
do
  if [ "$i" == "-h" ]
  then
    echo "Usage: rps_game [FILE1] [FILE2] [NICK]
Launch a game of paper and scissors between two terminals.
NICK specifies nickname of the current player.
FILE1 stores moves of current player and FILE2 stores moves of the another player.

With no FILE, or when FILE is -, read standard input.

  -v,					   output version information and exit
  -h,					   print help page and exit

Examples:
  rps_game f g n Play with this terminal's moves in f, the other player's moves in g and nickname n"
    exit 0
  elif [ "$i" == "-v" ]
  then
    echo "Version: 1.0.0"
    exit 0
  fi
done



PlayerName="$USER"
MovesPath="/home/$PlayerName/$1"
EnemyPath="/home/$PlayerName/$2"

if [ $# == 3 ] && [[ "$3" =~ [a-zA-Z0-9] ]]
then
	PlayerName="$3"
fi

> $MovesPath
#chmod u=rw,g=rw,o=r $MovesPath

while [ true ]
do
  test -e $EnemyPath
  if [ $? == 0 ] # if exists
  then
    test -s $EnemyPath
    if [ $? == 0 ] 
    then 
      break
    fi
  fi
  sleep 1
done

TurnNum=1
while [ true ]
do
	read PlayerInput
  case "$PlayerInput" in
  	"rock") "$PlayerName rock" >> $MovesPath;;
  	"paper") "$PlayerName paper" >> $MovesPath;;
  	"scissors") "$PlayerName scissors" >> $MovesPath;;
  	"end") "$PlayerName end" >> $MovesPath;;
    *) echo "illegal input"; continue;;
  ecas

  while [ ${wc -l $EnemyPath} != $TurnNum ]
  do
    sleep 1
  done

  PlayerMove=${tail -n 1 $EnemyPath}
  EnemyMove${tail -n 1 $EnemyPath}

  if [ $PlayerMove == $EnemyMove ]
  then
    echo "It's a Tie!"
  elif [ $PlayerMove == "end" ] || [[ $PlayerMove == "paper" ] && [ $EnemyMove == "scissors" ]] || [[ $PlayerMove == "scissors" ] && [ $EnemyMove == "rock" ]] || [[ $PlayerMove == "rock" ] && [ $EnemyMove == "paper" ]]
  then  
    echo "Game Over!"
  elif [ $EnemyMove == "end" ] || [[ $EnemyMove == "paper" ] && [ $PlayerMove == "scissors" ]] || [[ $EnemyMove == "scissors" ] && [ $PlayerMove == "rock" ]] || [[ $EnemyMove == "rock" ] && [ $PlayerMove == "paper" ]]
  then
    echo "You Win!"
  fi
done