#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

#TRUNCATE table
echo $($PSQL "TRUNCATE teams, games")

# insert unique team names to teams table

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do

    if [[ $YEAR != "year" ]]
      then
     
      # get winner names
        WINNER_NAMES=$($PSQL "SELECT name FROM teams WHERE name = '$WINNER'")
        
        # if not found
        if [[ -z $WINNER_NAMES ]]
          then
          # INSERT winner names to teams
          INSERT_WINNER_NAMES=$($PSQL "INSERT INTO teams(name) VALUES ('$WINNER')") 
        fi

      # get opponet names
        OPPONENT_NAMES=$($PSQL "SELECT name FROM teams WHERE name = '$OPPONENT'")

        #if not found
        if [[ -z $OPPONENT_NAMES ]]
          then
          #insert opponent names to teams
          INSERT_OPPONENT_NAMES=$($PSQL "INSERT INTO teams(name) VALUES ('$OPPONENT')")
        fi
    fi
done


# insert game info to games table

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do

  # get winner_id and opponent_id
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")
  
  # get game data from games table 
    GAME=$($PSQL "SELECT year, round, winner_id, opponent_id, winner_goals, opponent_goal FROM games")

  # if not found
    if [[ -z $GAME ]]
    then
      # insert data from games.csv, WINNER_ID and OPPONENT_ID to games table
      INSERT_GAME=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES ($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
    fi

done
