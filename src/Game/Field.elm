module Game.Field
    exposing
        ( Field
        , Msg
        , create
        , update
        , view
        , isFull
        , cellIsTaken
        )

import Html exposing (Html, div)
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
    let
        cells =
            Matrix.create 3 (\_ _ -> Nothing)
    in
        { cells = cells
        , available = True
        , winner = Nothing
        , full = False
        }



-- UPDATE


type Msg
    = TakeCell Coords
    | MakeFull
    | SetWinner Player


update : Msg -> Player -> Field -> ( Field, Cmd Msg, Maybe Coords )
update msg player field =
    case msg of
        TakeCell coords ->
            if field.available && not (cellIsTaken coords field) then
                updateCell field coords player
            else
                ( field, Cmd.none, Nothing )

        MakeFull ->
            ( { field | full = True, available = False }, Cmd.none, Nothing )

        SetWinner player ->
            ( { field | winner = (Just player) }, Cmd.none, Nothing )


updateCell : Field -> Coords -> Player -> ( Field, Cmd Msg, Maybe Coords )
updateCell field coords player =
    let
        newCells =
            Matrix.set coords (Just player) field.cells
    in
        ( { field | cells = newCells }, Cmd.none, Just coords )


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
            ]
        ]
        (Array.toList (Array.indexedMap rowView field.cells))


rowView : Row -> Array (Maybe Player) -> Html Msg
rowView row cells =
    div [ class "cell-row" ] (Array.toList (Array.indexedMap (cellView row) cells))


cellView : Row -> Col -> Maybe Player -> Html Msg
cellView row col player =
    Cell.view (TakeCell ( row, col )) player
