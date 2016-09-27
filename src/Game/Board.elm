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
import Game.Types exposing (Player, Coords)
import Game.Matrix as Matrix exposing (Matrix)


-- MODEL


type alias Board =
    Matrix Field


emptyBoard : Board
emptyBoard =
    Matrix.create 3 Field.create



-- UPDATE


type Msg
    = FieldMsg Field Field.Msg


update : Msg -> Player -> Board -> ( Board, Cmd Msg, Maybe Coords )
update msg player board =
    case msg of
        FieldMsg field msg' ->
            updateField msg' player field board


updateField : Field.Msg -> Player -> Field -> Board -> ( Board, Cmd Msg, Maybe Coords )
updateField msg player field board =
    let
        ( newField, fieldCmd, nextCoords ) =
            Field.update msg player field

        newBoard =
            Matrix.set ( field.row, field.col ) newField board

        updatedBoard =
            case nextCoords of
                Nothing ->
                    newBoard

                Just coords ->
                    updateFieldsAvailability newBoard coords
    in
        ( updatedBoard, Cmd.none, nextCoords )


updateFieldsAvailability : Board -> Coords -> Board
updateFieldsAvailability board ( row, col ) =
    Array.indexedMap
        (\boardRow cellsRow ->
            Array.indexedMap
                (\boardCol field ->
                    let
                        coordsAreEqual =
                            (boardCol == col) && (boardRow == row)

                        availability =
                            coordsAreEqual

                        newField =
                            { field | available = availability }
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
