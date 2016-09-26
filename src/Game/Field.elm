module Game.Field
    exposing
        ( Field
        , Msg
        , create
        , update
        , view
        )

import Html exposing (Html, div)
import Html.Attributes exposing (class)
import Debug
import Array exposing (Array)
import Game.Cell as Cell exposing (Cell)
import Game.Types exposing (Row, Col, Player(X, O))
import Game.Helpers as Helpers


-- MODEL


type alias Field =
    { row : Row
    , col : Col
    , cells : Array (Array Cell)
    , available : Bool
    }


create : Row -> Col -> Field
create row col =
    let
        cells =
            Helpers.createMatrix 3
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
        , available = True
        }



-- UPDATE


type Msg
    = TakeCell Cell


update : Msg -> Field -> ( Field, Cmd Msg )
update msg field =
    case msg of
        TakeCell cell ->
            if field.available then
                updateCell field cell X
            else
                ( field, Cmd.none )


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
                    Debug.crash "Row with cell is not found"

        newCells =
            Array.set cell.row newRow field.cells
    in
        ( { field | cells = newCells }, Cmd.none )



-- VIEW


view : Field -> Html Msg
view field =
    div
        [ class "field"
        ]
        (Array.toList (Array.map rowView field.cells))


rowView : Array Cell -> Html Msg
rowView cells =
    div [ class "cell-row" ] (Array.toList (Array.map cellView cells))


cellView : Cell -> Html Msg
cellView cell =
    Cell.view (TakeCell cell) cell
