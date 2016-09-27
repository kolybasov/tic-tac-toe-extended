module Game.Types
    exposing
        ( Row
        , Col
        , Player(X, O)
        , Coords
        )


type alias Row =
    Int


type alias Col =
    Int


type alias Coords =
    ( Row, Col )


type Player
    = X
    | O
