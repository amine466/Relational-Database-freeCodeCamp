#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=periodic_table -t --no-align -c"
if [[ -z $1 ]]
then
  echo Please provide an element as an argument.
else
  CHECK_ARGUMENT=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number::VARCHAR(2) = '$1' OR symbol = '$1' OR name = '$1'")
  if [[ -z $CHECK_ARGUMENT ]]
  then
    echo I could not find that element in the database.
  else
    NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number = $CHECK_ARGUMENT")
    SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number = $CHECK_ARGUMENT")
    TYPE_ID=$($PSQL "SELECT type_id FROM properties WHERE atomic_number = $CHECK_ARGUMENT")
    TYPE=$($PSQL "SELECT type FROM types WHERE type_id = $TYPE_ID")
    MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number = $CHECK_ARGUMENT")
    MELT_POINT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number = $CHECK_ARGUMENT")
    BOIL_POINT=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number = $CHECK_ARGUMENT")
    echo "The element with atomic number $CHECK_ARGUMENT is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT_POINT celsius and a boiling point of $BOIL_POINT celsius."
  fi
fi

