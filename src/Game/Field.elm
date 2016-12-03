module Game.Field
    exposing
        ( Field
        , Msg(TakeCell)
        , create
        , update
        , view
        , isFull
        , cellIsTaken
        , setWinner
        , setFull
        , checkWinner
        )

import Html exposing (Html, div, text)
import Html.Attributes exposing (class, classList)
import Array exposing (Array)
import Game.Cell as Cell
import Game.Types exposing (Row, Col, Player, Coords)
import Game.Matrix as Matrix exposing (Matrix)
import Game.Winner as Winner


-- MODEL


type alias Field =
    { cells : Matrix (Maybe Player)
    , available : Bool
    , winner : Maybe Player
    , full : Bool
    }


create : Field
create =
    { cells = Matrix.create 3 (\_ _ -> Nothing)
    , available = True
    , winner = Nothing
    , full = False
    }



-- UPDATE


type Msg
    = TakeCell Coords


update : Msg -> Player -> Field -> ( Field, Cmd Msg, Maybe Coords )
update msg player field =
    case msg of
        TakeCell coords ->
            if field.available && not (cellIsTaken coords field) then
                updateCell field coords player
            else
                ( field, Cmd.none, Nothing )


updateCell : Field -> Coords -> Player -> ( Field, Cmd Msg, Maybe Coords )
updateCell field coords player =
    let
        newCells =
            Matrix.set coords (Just player) field.cells
    in
        ( { field | cells = newCells }, Cmd.none, Just coords )


setWinner : Player -> Field -> Field
setWinner player field =
    { field | winner = Just player }


setFull : Field -> Field
setFull field =
    { field | available = False, full = True }


cellIsTaken : Coords -> Field -> Bool
cellIsTaken coords field =
    case (Matrix.get coords field.cells) of
        Just cell ->
            cell /= Nothing

        Nothing ->
            False


isFull : Field -> Bool
isFull field =
    Matrix.all (\player -> player /= Nothing) field.cells


checkWinner : Coords -> Field -> Maybe Player
checkWinner lastMove field =
    Winner.check
        (\pattern ->
            List.map
                (\coords ->
                    Matrix.get coords field.cells
                        |> Maybe.withDefault Nothing
                )
                pattern
        )
        lastMove



-- VIEW


view : Field -> Html Msg
view field =
    div
        [ classList
            [ ( "field", True )
            , ( "disabled", not field.available )
            , ( "no-winner", field.winner == Nothing )
            ]
        ]
        (fieldContent field)


fieldContent : Field -> List (Html Msg)
fieldContent field =
    let
        winner =
            winnerView field.winner

        cells =
            Array.toList (Array.indexedMap rowView field.cells)
    in
        winner :: cells


winnerView : Maybe Player -> Html Msg
winnerView player =
    div
        [ class "field-winner" ]
        [ case player of
            Just player_ ->
                text (toString player_)

            Nothing ->
                text ""
        ]


rowView : Row -> Array (Maybe Player) -> Html Msg
rowView row cells =
    div [ class "cell-row" ] (Array.toList (Array.indexedMap (cellView row) cells))


cellView : Row -> Col -> Maybe Player -> Html Msg
cellView row col player =
    Cell.view (TakeCell ( row, col )) player
