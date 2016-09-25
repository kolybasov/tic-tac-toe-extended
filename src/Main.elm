module TicTacToeExtended exposing (..)

import Html exposing (Html, text, h2, div)
import Html.Attributes exposing (class)
import Html.App as App
import Board exposing (Board)
import Cell exposing (Player(X))


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


update : Msg -> Store -> ( Store, Cmd Msg )
update msg store =
    case msg of
        BoardMsg msg' ->
            updateBoard msg' store


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



-- MAIN


main : Program Never
main =
    App.program
        { init = init
        , update = update
        , view = view
        , subscriptions = \_ -> Sub.none
        }
