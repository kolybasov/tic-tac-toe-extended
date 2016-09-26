module Game.Types
    exposing
        ( Row
        , Col
        , Player(X, O)
        )


type alias Row =
    Int


type alias Col =
    Int


type Player
    = X
    | O
