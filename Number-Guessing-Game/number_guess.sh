#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"
NUMBER=$(( RANDOM % (1000) + 1))
echo Enter your username:
read NAME
CHECK_NAME=$($PSQL "SELECT name FROM users WHERE name = '$NAME'")
if [[ -z $CHECK_NAME ]]
then
  echo Welcome, $NAME! It looks like this is your first time here.
  INSERT=$($PSQL "INSERT INTO users(name, games_played) VALUES('$NAME', 0)")
else
  IFS='|' read GAMES BEST < <($PSQL "SELECT games_played, best_game FROM users WHERE name = '$NAME'")
  echo Welcome back, $NAME! You have played $GAMES games, and your best game took $BEST guesses.
fi 
echo Guess the secret number between 1 and 1000:
read INPUT
GUESS=1
while [[ $INPUT -ne $NUMBER ]]
do
  ((GUESS++)) 
  if [[ "$INPUT" =~ ^-?[0-9]+$ ]]
  then
    if [[ $INPUT -lt $NUMBER ]]
    then
      echo "It's lower than that, guess again:"
    else
      echo "It's higher than that, guess again:"
    fi
  else
    echo "That is not an integer, guess again:"
  fi
  read INPUT
done
echo "You guessed it in $GUESS tries. The secret number was $INPUT. Nice job!"
BEST=$($PSQL "SELECT best_game FROM users WHERE name='$NAME'")
if [[ -z $BEST ]]
then
  BEST=$GUESS
else
  if [[ $GUESS -lt $BEST ]]
  then
    BEST=$GUESS
  fi
fi
UPDATE=$($PSQL "UPDATE users SET best_game = $BEST WHERE name = '$NAME'")
UPDATE=$($PSQL "UPDATE users SET games_played=games_played+1 WHERE name = '$NAME'")
