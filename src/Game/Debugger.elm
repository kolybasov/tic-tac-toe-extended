module Game.Debugger
    exposing
        ( program
        )

import Html exposing (Html)
import Html.App as App
import TimeTravel.Html.App as TimeTravel


program : { init : ( model, Cmd msg ), update : msg -> model -> ( model, Cmd msg ), subscriptions : model -> Sub msg, view : model -> Html msg } -> Program Never
program =
    let
        debug =
            True
    in
        if debug then
            TimeTravel.program
        else
            App.program
