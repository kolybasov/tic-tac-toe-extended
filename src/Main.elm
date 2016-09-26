module Main exposing (..)

import Html.App exposing (program)
import Game


main : Program Never
main =
    program
        { init = Game.init
        , update = Game.update
        , view = Game.view
        , subscriptions = \_ -> Sub.none
        }
