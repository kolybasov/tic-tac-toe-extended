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


update : Msg -> Store -> ( Store, Cmd Msg )
update msg store =
    case msg of
        BoardMsg msg' ->
            updateBoard msg' store


updateBoard : Board.Msg -> Store -> ( Store, Cmd Msg )
updateBoard msg store =
    let
        ( newBoard, boardCmd, nextCoords ) =
            Board.update msg store.currentPlayer store.board

        newPlayer =
            updatePlayer nextCoords store.currentPlayer
    in
        ( { store
            | board = newBoard
            , currentPlayer = newPlayer
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
