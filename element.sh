#! /bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"
#Lastly, you need to make a script that accepts an argument in the form of an atomic number, symbol, or name of an element and outputs some information about the given element.
#If you run ./element.sh, it should output only Please provide an element as an argument. and finish running.
#If you run ./element.sh 1, ./element.sh H, or ./element.sh Hydrogen, it should output only The element with atomic number 1 is Hydrogen (H). It's a nonmetal, with a mass of 1.008 amu. Hydrogen has a melting point of -259.1 celsius and a boiling point of -252.9 celsius.
ARG=$1
if [[ -z $1 ]]
then
 echo Please provide an element as an argument.
 exit 0
fi

if [[ $1 =~ ^[0-9] ]]
then
  MATCH=$($PSQL "SELECT * FROM elements JOIN properties USING(atomic_number) JOIN types USING(type_id) WHERE atomic_number=$1")
  if [[ -z $MATCH ]]
  then
    echo "I could not find that element in the database."
  else
    IFS='|' read X NUM SYMBOL NAME MASS MELT BOIL TYPE <<< "$MATCH"
    echo "The element with atomic number $NUM is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
  fi
  elif [[ ${#ARG} -le 2 ]]
  then
    MATCH=$($PSQL "SELECT * FROM elements JOIN properties USING(atomic_number) JOIN types USING(type_id) WHERE symbol='$1'")
    if [[ -z $MATCH ]]
    then
      echo "I could not find that element in the database."
      exit 0
    fi
    IFS='|' read X NUM SYMBOL NAME MASS MELT BOIL TYPE <<< "$MATCH"
    echo "The element with atomic number $NUM is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
  else
    MATCH=$($PSQL "SELECT * FROM elements JOIN properties USING(atomic_number) JOIN types USING(type_id) WHERE name='$1'")
    if [[ -z $MATCH ]]
    then
      echo "I could not find that element in the database."
      exit 0
    fi
    IFS='|' read X NUM SYMBOL NAME MASS MELT BOIL TYPE <<< "$MATCH"
    echo "The element with atomic number $NUM is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
fi
