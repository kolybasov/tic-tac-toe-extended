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
import Game.Types exposing (Row, Col, Player, Coords)
import Game.Matrix as Matrix exposing (Matrix)


-- MODEL


type alias Board =
    Matrix Field


emptyBoard : Board
emptyBoard =
    Matrix.create 3 (\_ _ -> Field.create)



-- UPDATE


type Msg
    = FieldMsg Coords Field Field.Msg


update : Msg -> Player -> Board -> ( Board, Cmd Msg, Maybe Coords )
update msg player board =
    case msg of
        FieldMsg coords field msg' ->
            updateField msg' coords player field board


updateField : Field.Msg -> Coords -> Player -> Field -> Board -> ( Board, Cmd Msg, Maybe Coords )
updateField msg ( row, col ) player field board =
    let
        ( newField, fieldCmd, nextCoords ) =
            Field.update msg player field

        newBoard =
            Matrix.set ( row, col ) newField board

        updatedBoard =
            case nextCoords of
                Nothing ->
                    newBoard

                Just coords ->
                    updateFieldsAvailability coords newBoard
    in
        ( updatedBoard, Cmd.none, nextCoords )


updateFieldsAvailability : Coords -> Board -> Board
updateFieldsAvailability ( row, col ) board =
    Matrix.indexedMap
        (\boardRow boardCol field ->
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
        board



-- VIEW


view : Board -> Html Msg
view board =
    div [ class "board" ] (Array.toList (Array.indexedMap rowView board))


rowView : Row -> Array Field -> Html Msg
rowView row fields =
    div [ class "board-row" ] (Array.toList (Array.indexedMap (fieldView row) fields))


fieldView : Row -> Col -> Field -> Html Msg
fieldView row col field =
    App.map (FieldMsg ( row, col ) field) (Field.view field)
