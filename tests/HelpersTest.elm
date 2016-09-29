module HelpersTest exposing (suite)

import Test exposing (Test, describe, test)
import Expect exposing (Expectation)
import Game.Helpers as Helpers
import Game.Types exposing (Player(X, O))


suite : Test
suite =
    describe "Helpers"
        [ switchPlayer
        ]



-- SWITCH PLAYER


switchPlayer : Test
switchPlayer =
    describe "#switchPlayer"
        [ test "should return O" <|
            \() ->
                Expect.equal O (Helpers.switchPlayer X)
        , test "should return X" <|
            \() ->
                Expect.equal X (Helpers.switchPlayer O)
        ]
