module Game.Board
    exposing
        ( Board
        , Msg
        , create
        , update
        , view
        , checkWinner
        )

import Html exposing (Html, div, text, span, h2, map)
import Html.Attributes exposing (class, classList)
import Array exposing (Array)
import Game.Field as Field exposing (Field)
import Game.Types exposing (Row, Col, Player, Coords)
import Game.Matrix as Matrix exposing (Matrix)
import Game.Winner as Winner


-- MODEL


type alias Board =
    Matrix Field


create : Board
create =
    Matrix.create 3 (\_ _ -> Field.create)



-- UPDATE


type Msg
    = FieldMsg Coords Field Field.Msg


update : Msg -> Player -> Board -> ( Board, Cmd Msg, Maybe Coords, Maybe Coords )
update msg player board =
    case msg of
        FieldMsg coords field msg_ ->
            updateField msg_ coords player field board


updateField : Field.Msg -> Coords -> Player -> Field -> Board -> ( Board, Cmd Msg, Maybe Coords, Maybe Coords )
updateField msg ( row, col ) player field board =
    let
        ( newField, fieldCmd, nextCoords ) =
            Field.update msg player field

        newBoard =
            Matrix.set ( row, col ) newField board

        updatedBoard =
            case nextCoords of
                Just coords ->
                    updateFieldsAvailability coords ( row, col ) newField newBoard

                Nothing ->
                    newBoard

        lastFieldCoords =
            case nextCoords of
                Just _ ->
                    Just ( row, col )

                Nothing ->
                    Nothing
    in
        ( updatedBoard, Cmd.map (FieldMsg ( row, col ) field) fieldCmd, nextCoords, lastFieldCoords )


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
                Just field_ ->
                    field_.full == False

                Nothing ->
                    False

        updatedBoard =
            Matrix.set previousCoords fieldIsFull board
    in
        if nextIsAvailable then
            makeFieldAvailableByCoords ( nextRow, nextCol ) updatedBoard
        else
            makeAllFieldsAvailable updatedBoard


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


checkWinner : Coords -> Board -> Maybe Player
checkWinner lastMove board =
    Winner.check
        (\pattern ->
            List.map
                (\coords ->
                    Matrix.get coords board |> Maybe.andThen .winner
                )
                pattern
        )
        lastMove



-- VIEW


view : Board -> Maybe Player -> Html Msg
view board winner =
    div []
        [ h2 [] [ text "Tic Tac Toe Extended" ]
        , div
            [ classList
                [ ( "board", True )
                , ( "no-winner", winner == Nothing )
                ]
            ]
            (boardContent winner board)
        ]


boardContent : Maybe Player -> Board -> List (Html Msg)
boardContent winner board =
    let
        winnerBlock =
            winnerView winner

        fields =
            Array.toList (Array.indexedMap rowView board)
    in
        winnerBlock :: fields


winnerView : Maybe Player -> Html Msg
winnerView winner =
    let
        content =
            case winner of
                Just player ->
                    [ span [ class "board-winner-player" ] [ text (toString player) ]
                    , span [ class "board-winner-words" ] [ text "won!" ]
                    ]

                Nothing ->
                    [ text "" ]
    in
        div [ class "board-winner" ] content


rowView : Row -> Array Field -> Html Msg
rowView row fields =
    div [ class "board-row" ] (Array.toList (Array.indexedMap (fieldView row) fields))


fieldView : Row -> Col -> Field -> Html Msg
fieldView row col field =
    map (FieldMsg ( row, col ) field) (Field.view field)
