module Main exposing (..)

import Game exposing (Store, Msg)
import Html exposing (program)


main : Program Never Store Msg
main =
    program
        { init = Game.init
        , update = Game.update
        , view = Game.view
        , subscriptions = \_ -> Sub.none
        }
