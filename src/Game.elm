module Game
    exposing
        ( Store
        , init
        , update
        , view
        )

import Html exposing (Html, text, h2, div)
import Html.App as App
import Game.Board as Board exposing (Board)
import Game.Types exposing (Row, Col, Player(X))
import Game.Helpers as Helpers
import Game.Cell exposing (Cell)


type alias Store =
    { board : Board
    , currentPlayer : Player
    }


initialStore : Store
initialStore =
    { board = Board.emptyBoard
    , currentPlayer = X
    }


init : ( Store, Cmd Msg )
init =
    ( initialStore, Cmd.none )



-- UPDATE


type Msg
    = BoardMsg Board.Msg
    | ResetStore


update : Msg -> Store -> ( Store, Cmd Msg )
update msg store =
    case msg of
        BoardMsg msg' ->
            updateBoard msg' store

        ResetStore ->
            init


updateBoard : Board.Msg -> Store -> ( Store, Cmd Msg )
updateBoard msg store =
    let
        ( newBoard, boardCmd, updatedCell ) =
            Board.update msg store.currentPlayer store.board

        newPlayer =
            updatePlayer updatedCell store.currentPlayer
    in
        ( { store
            | board = newBoard
            , currentPlayer = newPlayer
          }
        , Cmd.map BoardMsg boardCmd
        )


updatePlayer : Maybe Cell -> Player -> Player
updatePlayer cell player =
    case cell of
        Nothing ->
            player

        Just cell' ->
            Helpers.switchPlayer player



-- VIEW


view : Store -> Html Msg
view store =
    div []
        [ h2 [] [ text "Tic Tac Toe Extended" ]
        , boardView store.board
        ]


boardView : Board -> Html Msg
boardView board =
    App.map BoardMsg (Board.view board)
