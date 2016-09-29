module Main exposing (..)

import Game
import Html.App exposing (program)


main : Program Never
main =
    program
        { init = Game.init
        , update = Game.update
        , view = Game.view
        , subscriptions = \_ -> Sub.none
        }
