#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
$PSQL "truncate table games, teams cascade"

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  # insert winner if not exists
  WINNER_ID=$($PSQL "select team_id from teams where name = '$WINNER'")
  if [[ $WINNER != 'winner' && -z $WINNER_ID ]]
  then
    $PSQL "insert into teams(name) values('$WINNER')"
  fi

  # insert opponent if not exists
  OPPONENT_ID=$($PSQL "select team_id from teams where name = '$OPPONENT'")
  if [[ $OPPONENT != 'opponent' && -z $OPPONENT_ID ]]
  then
    $PSQL "insert into teams(name) values('$OPPONENT')"
  fi

  # insert games
  WINNER_ID=$($PSQL "select team_id from teams where name = '$WINNER'")
  OPPONENT_ID=$($PSQL "select team_id from teams where name = '$OPPONENT'")
  if [[ ! -z $WINNER_ID && ! -z $OPPONENT_ID ]]
  then
    $PSQL "insert into games(year, round, winner_id, opponent_id, winner_goals, opponent_goals)
    values($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS);"
  fi
done
