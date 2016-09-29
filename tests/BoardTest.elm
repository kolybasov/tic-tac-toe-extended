module BoardTest exposing (suite)

import Test exposing (Test, describe, test)
import Expect exposing (Expectation)
import Game.Board as Board exposing (Board)
import Game.Field as Field exposing (Field)
import Game.Matrix as Matrix exposing (Matrix)


suite : Test
suite =
    describe "Board"
        [ create
        ]


testBoard : Board
testBoard =
    Matrix.create 3 (\_ _ -> Field.create)



-- CREATE


create : Test
create =
    test "#create" <|
        \() ->
            Expect.equal testBoard Board.create
