module Game.Winner
    exposing
        ( detect
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


isAllEqual : List a -> Bool
isAllEqual list =
    let
        head =
            List.head list
    in
        case head of
            Nothing ->
                False

            Just el ->
                List.filter (\val -> el == val) list
                    |> List.length
                    |> (>) 0


detect : (List Coords -> List (Maybe Player)) -> Maybe Player
detect func =
    let
        lines =
            List.map (\pattern -> func pattern) patterns

        wonLines =
            List.filter isAllEqual lines

        winner =
            List.concat wonLines
                |> List.head
    in
        case winner of
            Nothing ->
                Nothing

            Just player ->
                player
