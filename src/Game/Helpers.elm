module Game.Helpers
    exposing
        ( switchPlayer
        )

import Game.Types exposing (Player(X, O, Draw))


switchPlayer : Player -> Player
switchPlayer player =
    case player of
        X ->
            O

        O ->
            X

        Draw ->
            Draw
