module WinnerTest exposing (suite)

import Test exposing (Test, describe, test)
import Expect exposing (Expectation)
import Game.Winner as Winner
import Game.Types exposing (Player(X, O), Coords)
import Game.Matrix as Matrix exposing (Matrix)


suite : Test
suite =
    describe "Game.Winner module" <|
        List.map
            (\( expected, lastMove, fixture ) ->
                test ("should return " ++ (toString expected) ++ "as winner") <|
                    \() -> checkWinner expected lastMove fixture
            )
            fixtures


checkWinner : Maybe Player -> Coords -> Matrix (Maybe Player) -> Expectation
checkWinner expected lastMove fixture =
    let
        winner =
            Winner.check
                (\patterns ->
                    List.map
                        (\coords ->
                            Matrix.get coords fixture
                                |> Maybe.withDefault Nothing
                        )
                        patterns
                )
                lastMove
    in
        Expect.equal winner expected


fixtures : List ( Maybe Player, Coords, Matrix (Maybe Player) )
fixtures =
    [ fixtureNoWinner ]



-- [ fixtureRowWinner
-- , fixtureColWinner
-- , fixtureDiagonalWinner
-- , fixtureNoWinner
-- ]


fixtureRowWinner : ( Maybe Player, Coords, Matrix (Maybe Player) )
fixtureRowWinner =
    let
        winner =
            Just X

        coords =
            ( 0, 0 )

        matrix =
            Matrix.fromList
                [ [ Just X, Just X, Just X ]
                , [ Nothing, Just O, Just X ]
                , [ Just O, Nothing, Nothing ]
                ]
    in
        ( winner, coords, matrix )


fixtureColWinner : ( Maybe Player, Coords, Matrix (Maybe Player) )
fixtureColWinner =
    let
        winner =
            Just O

        coords =
            ( 1, 2 )

        matrix =
            Matrix.fromList
                [ [ Just O, Just X, Just O ]
                , [ Nothing, Just X, Just O ]
                , [ Nothing, Nothing, Just O ]
                ]
    in
        ( winner, coords, matrix )


fixtureDiagonalWinner : ( Maybe Player, Coords, Matrix (Maybe Player) )
fixtureDiagonalWinner =
    let
        winner =
            Just X

        coords =
            ( 2, 2 )

        matrix =
            Matrix.fromList
                [ [ Just X, Just X, Just O ]
                , [ Nothing, Just X, Just O ]
                , [ Nothing, Nothing, Just X ]
                ]
    in
        ( winner, coords, matrix )


fixtureNoWinner : ( Maybe Player, Coords, Matrix (Maybe Player) )
fixtureNoWinner =
    let
        winner =
            Nothing

        coords =
            ( 1, 1 )

        matrix =
            Matrix.fromList
                [ [ Just X, Just X, Just O ]
                , [ Nothing, Nothing, Just O ]
                , [ Just O, Nothing, Just X ]
                ]
    in
        ( winner, coords, matrix )
