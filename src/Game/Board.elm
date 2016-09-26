module Game.Board
    exposing
        ( Board
        , Msg
        , emptyBoard
        , update
        , view
        )

import Html exposing (Html, div)
import Html.Attributes exposing (class)
import Html.App as App
import Array exposing (Array)
import Game.Field as Field exposing (Field)
import Game.Helpers as Helpers
import Game.Types exposing (Player)
import Game.Cell exposing (Cell)


-- MODEL


type alias Board =
    Array (Array Field)


emptyBoard : Board
emptyBoard =
    Helpers.createMatrix 3 Field.create



-- UPDATE


type Msg
    = FieldMsg Field Field.Msg


update : Msg -> Player -> Board -> ( Board, Cmd Msg, Maybe Cell )
update msg player board =
    case msg of
        FieldMsg field msg' ->
            updateField msg' player field board


updateField : Field.Msg -> Player -> Field -> Board -> ( Board, Cmd Msg, Maybe Cell )
updateField msg player field board =
    let
        ( newField, fieldCmd, updatedCell ) =
            Field.update msg player field

        rowToChange =
            Array.get field.row board

        newRow =
            case rowToChange of
                Just row ->
                    Array.set field.col newField row

                Nothing ->
                    Array.fromList []

        newBoard =
            Array.set field.row newRow board

        updatedBoard =
            case updatedCell of
                Nothing ->
                    newBoard

                Just cell ->
                    updateFieldsAvailability newBoard cell
    in
        ( updatedBoard, Cmd.none, updatedCell )


updateFieldsAvailability : Board -> Cell -> Board
updateFieldsAvailability board cell =
    Array.indexedMap
        (\boardRow cellsRow ->
            Array.indexedMap
                (\boardCol field ->
                    let
                        coordsAreEqual =
                            (boardCol == cell.col) && (boardRow == cell.row)

                        newField =
                            { field | available = coordsAreEqual }
                    in
                        newField
                )
                cellsRow
        )
        board



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
