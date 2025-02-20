#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

tail -n +2 games.csv | while IFS=',' read -r year round winner opponent winner_goals opponent_goals
do
  CHECK_WINNER_ID="$($PSQL "SELECT team_id from teams WHERE name='$winner'")"
  CHECK_OPPONENT_ID="$($PSQL "SELECT team_id from teams WHERE name='$opponent'")"

  if [[ -z $CHECK_WINNER_ID ]]
  then
    echo "$($PSQL "INSERT INTO teams(name) Values('$winner')")" 
    CHECK_WINNER_ID="$($PSQL "SELECT team_id from teams WHERE name='$winner'")"
  fi

  if [[ -z $CHECK_OPPONENT_ID ]]
  then
    echo "$($PSQL "INSERT INTO teams(name) Values('$opponent')")" 
    CHECK_OPPONENT_ID="$($PSQL "SELECT team_id from teams WHERE name='$opponent'")"
  fi

  echo "$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($year, '$round', $CHECK_WINNER_ID, $CHECK_OPPONENT_ID, $winner_goals, $opponent_goals)")"
done