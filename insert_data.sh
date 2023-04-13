#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

TRUNCATE_TEAMS=$($PSQL "TRUNCATE teams CASCADE")
TRUNCATE_GAMES=$($PSQL "TRUNCATE games CASCADE")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $WINNER != "winner" ]]
  then 
    CHECK_TEAMS1=$($PSQL "SELECT name FROM teams WHERE name='$WINNER'")
    if [[ -z $CHECK_TEAMS1 ]]
    then
      INSERT_TEAM1_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      echo Inserted into teams $WINNER
    fi
  fi
  if [[ $OPPONENT != "opponent" ]]  
  then
    CHECK_TEAMS2=$($PSQL "SELECT name FROM teams WHERE name='$OPPONENT'")
    if [[ -z $CHECK_TEAMS2 ]]
    then
      INSERT_TEAM2_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
    fi
  fi
  
  if [[ $YEAR != "year" ]]
  then
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    INSERT_INFO=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES('$YEAR', '$ROUND', '$WINNER_ID', '$OPPONENT_ID', '$WINNER_GOALS', '$OPPONENT_GOALS')")
  fi
done
