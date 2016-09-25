module Board exposing (..)

import Html exposing (Html, text, div)
import Html.Attributes exposing (class)
import Html.App as App
import Debug
import Array exposing (Array)
import Field exposing (Field)
import Helpers


-- MODEL


type alias Board =
    Array (Array Field)


emptyBoard : Board
emptyBoard =
    Helpers.createMatrix 2 Field.create



-- UPDATE


type Msg
    = FieldMsg Field Field.Msg


update : Msg -> Board -> ( Board, Cmd Msg )
update msg board =
    case msg of
        FieldMsg field msg' ->
            updateField msg' field board


updateField : Field.Msg -> Field -> Board -> ( Board, Cmd Msg )
updateField msg field board =
    let
        rowToChange =
            Array.get field.row board

        ( newField, fieldCmd ) =
            Field.update msg field

        newRow =
            case rowToChange of
                Just row ->
                    Array.set field.col newField row

                Nothing ->
                    Debug.crash "Row is not found"

        newBoard =
            Array.set field.row newRow board
    in
        ( newBoard, Cmd.none )



-- VIEW


view : Board -> Html Msg
view board =
    div [ class "board" ] (Array.toList (Array.map rowView board))


rowView : Array Field -> Html Msg
rowView fields =
    div [ class "board-row" ] (Array.toList (Array.map fieldView fields))


fieldView : Field -> Html Msg
fieldView field =
    App.map (FieldMsg field) (Field.view field)
