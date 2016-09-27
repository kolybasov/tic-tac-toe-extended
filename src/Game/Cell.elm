module Game.Cell
    exposing
        ( taken
        , view
        )

import Html exposing (Html, text, button)
import Html.Attributes exposing (class, disabled)
import Html.Events exposing (onClick)
import Game.Types exposing (Player(X, O))


-- HELPERS


taken : Maybe Player -> Bool
taken player =
    player /= Nothing



-- VIEW


view : msg -> Maybe Player -> Html msg
view msg player =
    button
        [ class "cell"
        , disabled (taken player)
        , onClick msg
        ]
        [ case player of
            Just X ->
                xPlayerView

            Just O ->
                oPlayerView

            _ ->
                emptyView
        ]


xPlayerView : Html msg
xPlayerView =
    text "X"


oPlayerView : Html msg
oPlayerView =
    text "O"


emptyView : Html msg
emptyView =
    text " "
