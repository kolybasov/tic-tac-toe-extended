module Field exposing (..)

import Html exposing (Html, text, div, button)
import Html.Attributes exposing (class)
import Html.App as App
import Debug
import Array exposing (Array)
import Cell exposing (Cell, Player)
import Types exposing (Row, Col)
import Helpers


-- MODEL


type alias Field =
    { row : Row
    , col : Col
    , cells : Array (Array Cell)
    }


create : Row -> Col -> Field
create row col =
    let
        cells =
            Helpers.createMatrix 2
                (\cellRow cellCol ->
                    { row = cellRow
                    , col = cellCol
                    , player = Nothing
                    }
                )
    in
        { row = row
        , col = col
        , cells = cells
        }



-- UPDATE


type Msg
    = TakeCell Cell Player


update : Msg -> Field -> ( Field, Cmd Msg )
update msg field =
    case msg of
        TakeCell cell player ->
            updateCell field cell player


updateCell : Field -> Cell -> Player -> ( Field, Cmd Msg )
updateCell field cell player =
    let
        rowToChange =
            Array.get cell.row field.cells

        newCell =
            { cell | player = (Just player) }

        newRow =
            case rowToChange of
                Just row ->
                    Array.set cell.col newCell row

                Nothing ->
                    Debug.crash "Cannot find row"

        newCells =
            Array.set cell.row newRow field.cells
    in
        ( { field | cells = newCells }, Cmd.none )



-- VIEW


view : Field -> Html Msg
view field =
    div [ class "field" ] (Array.toList (Array.map rowView field.cells))


rowView : Array Cell -> Html Msg
rowView cells =
    div [ class "cell-row" ] (Array.toList (Array.map cellView cells))


cellView : Cell -> Html Msg
cellView cell =
    Cell.view (TakeCell cell Cell.X) cell
