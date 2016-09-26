module Game.Debugger
    exposing
        ( view
        )

import Html exposing (Html, button, text, div)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)


view : msg -> Bool -> a -> Html msg
view msg debug store =
    if debug then
        div [ class "debugger" ]
            [ button [ onClick msg ] [ text "Reset store" ]
            , div [ class "debug-store" ] [ text (toString store) ]
            ]
    else
        text ""
