module WinnerTest exposing (suite)

import Test exposing (Test, describe, test)
import Expect


suite : Test
suite =
    describe "Game.Winner module"
        [ test "example" <|
            \() ->
                Expect.equal 1 1
        ]
