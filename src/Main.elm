module Main exposing (..)

import Game
import Game.Debugger exposing (program)


main : Program Never
main =
    program
        { init = Game.init
        , update = Game.update
        , view = Game.view
        , subscriptions = \_ -> Sub.none
        }
