# Example of gamestate parsed from JSON
%{"gameState" =>
   %{"finishedPlayers" => [],
     "items" =>
       [%{"discountPercent" => 23, "isUsable" => false, "position" => %{"x" => 60, "y" => 5},
          "price" => 391, "type" => "JUST_SOME_JUNK"},
        %{"discountPercent" => 52, "isUsable" => false, "position" => %{"x" => 41, "y" => 20},
          "price" => 1525, "type" => "JUST_SOME_JUNK"},
        %{"discountPercent" => 89, "isUsable" => true, "position" => %{"x" => 87, "y" => 23},
          "price" => 4646, "type" => "WEAPON"},
        %{"discountPercent" => 40, "isUsable" => false, "position" => %{"x" => 51, "y" => 11},
          "price" => 2456, "type" => "JUST_SOME_JUNK"},
        %{"discountPercent" => 62, "isUsable" => false, "position" => %{"x" => 27, "y" => 19},
          "price" => 1888, "type" => "JUST_SOME_JUNK"}],
     "map" =>
       %{"exit" => %{"x" => 9, "y" => 4},
         "height" => 28,
         "maxItemCount" => 5,
         "name" => "sauli city",
         "tiles" => ["xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
                     "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
                     "xx________________________________________________________________________________________xx",
                     "xx________________________________________________________________________________________xx",
                     "xx_______o___________________________________xx___________________________________________xx",
                     "xx___________________________________________xx___________________________________________xx",
                     "xx___________________________________________xx___________________________________________xx",
                     "xx___________________________________________xx___________________________________________xx",
                     "xx___________________________________________xx___________________________________________xx",
                     "xx___________________________________________xx___________________________________________xx",
                     "xx___________________________________________xx___________________________________________xx",
                     "xx___________________________________________xx___________________________________________xx",
                     "xx___________________________________________xx___________________________________________xx",
                     "xx___________________________________________xx___________________________________________xx",
                     "xx___________________________________________xx___________________________________________xx",
                     "xx___________________________________________xx___________________________________________xx",
                     "xx___________________________________________xx___________________________________________xx",
                     "xx___________________________________________xx___________________________________________xx",
                     "xx___________________________________________xx___________________________________________xx",
                     "xx___________________________________________xx___________________________________________xx",
                     "xx___________________________________________xx___________________________________________xx",
                     "xx___________________________________________xx___________________________________________xx",
                     "xx___________________________________________xx___________________________________________xx",
                     "xx___________________________________________xx___________________________________________xx",
                     "xx________________________________________________________________________________________xx",
                     "xx________________________________________________________________________________________xx",
                     "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
                     "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"],
         "width" => 92},

     "players" =>
       [%{"actionCount" => 14, "health" => 20, "money" => 5000, "name" => "Bender1278225",
          "position" => %{"x" => 89, "y" => 24},
          "score" => 0, "state" => "MOVE", "timeInState" => 0, "url" => "http://localhost:4000/",
          "usableItems" => []}],
     "round" => 40562,
     "shootingLines" => []}, # end of "gameState"

  "playerId" => "0da841a1-b3ba-4dc4-bbe6-3b275402ef8f",
  "playerState" => %{"actionCount" => 14,
                     "health" => 20,
                     "money" => 5000,
                     "name" => "Bender1278225",
                     "position" => %{"x" => 89, "y" => 24},
                     "score" => 0,
                     "state" => "MOVE",
                     "timeInState" => 0,
                     "url" => "http://localhost:4000/",
                     "usableItems" => []},
  "reason" => "new turn"}