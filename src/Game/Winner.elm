module Game.Winner
    exposing
        ( check
        )

import Game.Types exposing (Coords, Player)
import List


{-| FIELD
   _________________
  |     |     |     |
  | 0,0 | 0,1 | 0,2 |
  |_____|_____|_____|
  |     |     |     |
  | 1,0 | 1,1 | 1,2 |
  |_____|_____|_____|
  |     |     |     |
  | 2,0 | 2,1 | 2,2 |
  |_____|_____|_____|
-}
patterns : List (List Coords)
patterns =
    -- ROWS
    [ [ ( 0, 0 ), ( 0, 1 ), ( 0, 2 ) ]
    , [ ( 1, 0 ), ( 1, 1 ), ( 1, 2 ) ]
    , [ ( 2, 0 ), ( 2, 1 ), ( 2, 2 ) ]
      -- COLUMNS
    , [ ( 0, 0 ), ( 1, 0 ), ( 2, 0 ) ]
    , [ ( 0, 1 ), ( 1, 1 ), ( 2, 1 ) ]
    , [ ( 0, 2 ), ( 1, 2 ), ( 2, 2 ) ]
      -- DIAGONALS
    , [ ( 0, 0 ), ( 1, 1 ), ( 2, 2 ) ]
    , [ ( 2, 0 ), ( 1, 1 ), ( 0, 2 ) ]
    ]


filteredPatterns : Coords -> List (List Coords)
filteredPatterns coords =
    List.filter (List.any ((==) coords)) patterns


allAreTheSame : List a -> Bool
allAreTheSame list =
    case List.head list of
        Just el ->
            List.all ((==) el) list

        Nothing ->
            True


check : (List Coords -> List (Maybe Player)) -> Coords -> Maybe Player
check func coords =
    let
        lines =
            List.map (\pattern -> func pattern) (filteredPatterns coords)

        wonLines =
            List.filter allAreTheSame lines

        winner =
            List.concat wonLines
                |> List.head
                |> Maybe.withDefault Nothing
    in
        winner
