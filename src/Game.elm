module Game
    exposing
        ( Store
        , init
        , update
        , view
        , Msg
        )

import Html exposing (Html, text, h2, div, span, button, map)
import Html.Events exposing (onClick)
import Html.Attributes exposing (class)
import Game.Board as Board exposing (Board)
import Game.Types exposing (Player(X), Coords)
import Game.Helpers as Helpers


type alias Store =
    { board : Board
    , currentPlayer : Player
    , winner : Maybe Player
    }


initialStore : Store
initialStore =
    { board = Board.create
    , currentPlayer = X
    , winner = Nothing
    }


init : ( Store, Cmd Msg )
init =
    ( initialStore, Cmd.none )



-- UPDATE


type Msg
    = BoardMsg Board.Msg
    | NewGame


update : Msg -> Store -> ( Store, Cmd Msg )
update msg store =
    case msg of
        BoardMsg msg_ ->
            if store.winner == Nothing then
                updateBoard msg_ store
            else
                ( store, Cmd.none )

        NewGame ->
            init


updateBoard : Board.Msg -> Store -> ( Store, Cmd Msg )
updateBoard msg store =
    let
        ( newBoard, boardCmd, nextCoords, lastFieldCoords ) =
            Board.update msg store.currentPlayer store.board

        newPlayer =
            updatePlayer nextCoords store.currentPlayer

        winner =
            updateWinner lastFieldCoords newBoard
    in
        ( { store
            | board = newBoard
            , currentPlayer = newPlayer
            , winner = winner
          }
        , Cmd.map BoardMsg boardCmd
        )


updatePlayer : Maybe Coords -> Player -> Player
updatePlayer coords player =
    case coords of
        Just _ ->
            Helpers.switchPlayer player

        Nothing ->
            player


updateWinner : Maybe Coords -> Board -> Maybe Player
updateWinner coords board =
    case coords of
        Just coords_ ->
            Board.checkWinner coords_ board

        Nothing ->
            Nothing



-- VIEW


view : Store -> Html Msg
view store =
    div []
        [ div [ class "wrapper" ]
            [ boardView store.board store.winner
            , controlsView store.currentPlayer
            ]
        ]


boardView : Board -> Maybe Player -> Html Msg
boardView board winner =
    map BoardMsg (Board.view board winner)


controlsView : Player -> Html Msg
controlsView player =
    div [ class "control-panel" ]
        [ h2
            [ class "current-player" ]
            [ span [] [ text "Current move: " ]
            , text (toString player)
            ]
        , div
            [ class "buttons" ]
            [ button [ onClick NewGame ] [ text "Start new game" ]
            ]
        ]
