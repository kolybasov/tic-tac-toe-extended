module MatrixTest exposing (suite)

import Test exposing (Test, describe, test)
import Expect exposing (Expectation)
import Array exposing (Array)
import Game.Matrix as Matrix exposing (Matrix)


suite : Test
suite =
    describe "Matrix"
        [ create
        , flatten
        , all
        , map
        , indexedMap
        , toList
        , fromList
        , get
        , set
        ]


testMatrix : Matrix Int
testMatrix =
    Array.fromList
        [ Array.fromList [ 0, 1, 2 ]
        , Array.fromList [ 1, 2, 3 ]
        , Array.fromList [ 2, 3, 4 ]
        ]



-- CREATE


create : Test
create =
    test "#create" <|
        \() ->
            let
                matrix =
                    Matrix.create 3 (\row col -> row + col)
            in
                Expect.equal matrix testMatrix



-- FLATTEN


flatten : Test
flatten =
    test "#flatten" <|
        \() ->
            let
                flatMatrix =
                    Array.fromList [ 0, 1, 2, 1, 2, 3, 2, 3, 4 ]

                matrix =
                    Matrix.flatten testMatrix
            in
                Expect.equal matrix flatMatrix



-- ALL


all : Test
all =
    describe "#all"
        [ test "should return true" <|
            \() ->
                let
                    trueMatrix =
                        Matrix.fromList
                            [ [ 0, 0, 0 ]
                            , [ 0, 0, 0 ]
                            , [ 0, 0, 0 ]
                            ]
                in
                    Expect.equal True (Matrix.all (\el -> el == 0) trueMatrix)
        , test "should return false" <|
            \() ->
                let
                    falseMatrix =
                        Matrix.fromList
                            [ [ 1, 0, 1 ]
                            , [ 0, 1, 1 ]
                            , [ 0, 0, 0 ]
                            ]
                in
                    Expect.equal False (Matrix.all (\el -> el == 0) falseMatrix)
        ]



-- MAP


map : Test
map =
    test "#map" <|
        \() ->
            let
                matrix =
                    Matrix.map (\el -> el + 1) testMatrix

                expectedMatrix =
                    Matrix.fromList
                        [ [ 1, 2, 3 ]
                        , [ 2, 3, 4 ]
                        , [ 3, 4, 5 ]
                        ]
            in
                Expect.equal matrix expectedMatrix



-- INDEXED MAP


indexedMap : Test
indexedMap =
    test "#indexedMap" <|
        \() ->
            let
                matrix =
                    Matrix.indexedMap
                        (\row col el ->
                            "row:" ++ (toString row) ++ ";col:" ++ (toString col) ++ ";el:" ++ (toString el)
                        )
                        testMatrix

                expectedMatrix =
                    Matrix.fromList
                        [ [ "row:0;col:0;el:0", "row:0;col:1;el:1", "row:0;col:2;el:2" ]
                        , [ "row:1;col:0;el:1", "row:1;col:1;el:2", "row:1;col:2;el:3" ]
                        , [ "row:2;col:0;el:2", "row:2;col:1;el:3", "row:2;col:2;el:4" ]
                        ]
            in
                Expect.equal matrix expectedMatrix



-- TO LIST


toList : Test
toList =
    test "#toList" <|
        \() ->
            let
                list =
                    [ [ 0, 1, 2 ]
                    , [ 1, 2, 3 ]
                    , [ 2, 3, 4 ]
                    ]
            in
                Expect.equal list (Matrix.toList testMatrix)



-- FROM LIST


fromList : Test
fromList =
    test "#fromList" <|
        \() ->
            let
                list =
                    [ [ 0, 1, 2 ]
                    , [ 1, 2, 3 ]
                    , [ 2, 3, 4 ]
                    ]
            in
                Expect.equal testMatrix (Matrix.fromList list)



-- GET


get : Test
get =
    describe "#get"
        [ test "should return Just 4" <|
            \() ->
                Expect.equal (Just 4) (Matrix.get ( 2, 2 ) testMatrix)
        , test "should return Nothing" <|
            \() ->
                Expect.equal Nothing (Matrix.get ( 5, 5 ) testMatrix)
        ]



-- SET


set : Test
set =
    describe "#set"
        [ test "should return updated matrix" <|
            \() ->
                let
                    matrix =
                        Matrix.fromList
                            [ [ 0, 1, 2 ]
                            , [ 1, 2, 3 ]
                            , [ 2, 3, 10 ]
                            ]
                in
                    Expect.equal matrix (Matrix.set ( 2, 2 ) 10 testMatrix)
        , test "should return the same matrix" <|
            \() ->
                Expect.equal testMatrix (Matrix.set ( 10, 10 ) 10 testMatrix)
        ]
