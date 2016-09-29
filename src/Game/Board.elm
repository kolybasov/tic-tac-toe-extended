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
                Just coords ->
                    updateFieldsAvailability coords ( row, col ) field newBoard

                Nothing ->
                    newBoard
    in
        ( updatedBoard, Cmd.none, nextCoords )


updateFieldsAvailability : Coords -> Coords -> Field -> Board -> Board
updateFieldsAvailability ( nextRow, nextCol ) previousCoords field board =
    let
        winner =
            Field.checkWinner ( nextRow, nextCol ) field

        fieldWithWinner =
            case winner of
                Just player ->
                    Field.setWinner player field

                Nothing ->
                    field

        fieldIsFull =
            if Field.isFull fieldWithWinner then
                Field.setFull fieldWithWinner
            else
                fieldWithWinner

        nextField =
            Matrix.get ( nextRow, nextCol ) board

        nextIsAvailable =
            case nextField of
                Just field' ->
                    field'.full == False

                Nothing ->
                    False

        updatedBoard =
            Matrix.set previousCoords fieldIsFull board
    in
        if nextIsAvailable then
            makeAllFieldsAvailable updatedBoard
        else
            makeFieldAvailableByCoords ( nextRow, nextCol ) updatedBoard


makeAllFieldsAvailable : Board -> Board
makeAllFieldsAvailable board =
    Matrix.map
        (\field ->
            if field.full then
                field
            else
                { field | available = True }
        )
        board


makeFieldAvailableByCoords : Coords -> Board -> Board
makeFieldAvailableByCoords ( boardRow, boardCol ) board =
    Matrix.indexedMap
        (\row col field ->
            if (boardRow == row) && (boardCol == col) then
                { field | available = True }
            else
                { field | available = False }
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
