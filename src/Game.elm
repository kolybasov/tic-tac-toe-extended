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
import Game.Types exposing (Player(X, O))


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
        ( newBoard, boardCmd ) =
            Board.update msg store.board
    in
        ( { store | board = newBoard }, Cmd.map BoardMsg boardCmd )



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
