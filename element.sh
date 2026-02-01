#!/bin/bash

#PSQL variable
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

#Check the argument
if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else
  if [[ $1 =~ ^-?[0-9]+$ ]]
  then
    ELEMENT_NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number=$1")
  fi
  ELEMENT_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$1'")
  ELEMENT_SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE name='$1'")
  if [[ ! -z  $ELEMENT_NAME ]] #if the user provided the atomic_number
  then
    ELEMENT_SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE name='$ELEMENT_NAME'")
    ELEMENT_NUMBER=$1
  elif [[ ! -z $ELEMENT_SYMBOL ]] #if the user provided the name of the element
  then
    ELEMENT_NAME=$1
    ELEMENT_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE name='$ELEMENT_NAME'")
  elif [[ ! -z $ELEMENT_NUMBER ]]
  then
    ELEMENT_SYMBOL=$1
    ELEMENT_NAME=$($PSQL "SELECT name FROM elements WHERE symbol='$ELEMENT_SYMBOL'")
  else #Case that the user provided an element that's not part of the database
    echo "I could not find that element in the database."
  fi
  if [[ ! -z $ELEMENT_NUMBER ]]
  then
    TYPE_ID=$($PSQL "SELECT type_id FROM properties WHERE atomic_number=$ELEMENT_NUMBER")
    ELEMENT_MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$ELEMENT_NUMBER")
    ELEMENT_MELTING_P=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$ELEMENT_NUMBER")
    ELEMENT_BOILING_P=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$ELEMENT_NUMBER")
    ELEMENT_TYPE=$($PSQL "SELECT type FROM types WHERE type_id=$TYPE_ID")
    echo "The element with atomic number $ELEMENT_NUMBER is $ELEMENT_NAME ($ELEMENT_SYMBOL). It's a $ELEMENT_TYPE, with a mass of $ELEMENT_MASS amu. $ELEMENT_NAME has a melting point of $ELEMENT_MELTING_P celsius and a boiling point of $ELEMENT_BOILING_P celsius."
  fi
fi