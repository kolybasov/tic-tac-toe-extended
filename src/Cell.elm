module Cell exposing (..)

import Html exposing (Html, Attribute, text, button)
import Html.Attributes exposing (class, disabled, title)
import Html.Events exposing (onClick)
import Types exposing (Row, Col)


-- MODEL


type alias Cell =
    { row : Row
    , col : Col
    , player : Maybe Player
    }


type Player
    = X
    | O



-- HELPERS


taken : Cell -> Bool
taken cell =
    cell.player /= Nothing



-- VIEW


view : msg -> Cell -> Html msg
view msg cell =
    button
        [ class "cell"
        , disabled (taken cell)
        , onClick msg
        ]
        [ case cell.player of
            Just X ->
                xPlayerView

            Just O ->
                oPlayerView

            Nothing ->
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
