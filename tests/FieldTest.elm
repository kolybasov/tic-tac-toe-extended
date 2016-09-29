module FieldTest exposing (suite)

import Test exposing (Test, describe, test)
import Expect exposing (Expectation)
import Game.Field as Field exposing (Field, Msg(TakeCell))
import Game.Matrix as Matrix exposing (Matrix)
import Game.Types exposing (Player(X, O))


suite : Test
suite =
    describe "Field"
        [ create
        , setWinner
        , setFull
        , isFull
        , cellIsTaken
        , checkWinner
        , update
        ]


testField : Field
testField =
    { cells = Matrix.create 3 (\_ _ -> Nothing)
    , available = True
    , full = False
    , winner = Nothing
    }



-- CREATE


create : Test
create =
    test "#create" <|
        \() ->
            Expect.equal testField (Field.create)



-- SET WINNER


setWinner : Test
setWinner =
    test "#setWinner" <|
        \() ->
            let
                newField =
                    Field.setWinner X testField
            in
                Expect.equal (Just X) newField.winner



-- SET FULL


setFull : Test
setFull =
    test "#setFull" <|
        \() ->
            let
                newField =
                    Field.setFull testField
            in
                Expect.equal True newField.full



-- IS FULL


isFull : Test
isFull =
    describe "#isFull"
        [ test "should return true" <|
            \() ->
                let
                    newField =
                        { testField | cells = (Matrix.create 3 (\_ _ -> Just X)) }
                in
                    Expect.equal True (Field.isFull newField)
        , test "should return false" <|
            \() ->
                Expect.equal False (Field.isFull testField)
        ]



-- CELL IS TAKEN


cellIsTaken : Test
cellIsTaken =
    describe "#cellIsTaken"
        [ test "should return true" <|
            \() ->
                let
                    newField =
                        { testField | cells = (Matrix.set ( 0, 0 ) (Just X) testField.cells) }
                in
                    Expect.equal True (Field.cellIsTaken ( 0, 0 ) newField)
        , test "should return false" <|
            \() ->
                Expect.equal False (Field.cellIsTaken ( 0, 0 ) testField)
        ]



-- CHECK WINNER


checkWinner : Test
checkWinner =
    describe "#checkWinner"
        [ test "should return Just X" <|
            \() ->
                let
                    newCells =
                        Matrix.set ( 0, 0 ) (Just X) testField.cells
                            |> Matrix.set ( 0, 1 ) (Just X)
                            |> Matrix.set ( 0, 2 ) (Just X)

                    newField =
                        { testField | cells = newCells }
                in
                    Expect.equal (Just X) (Field.checkWinner ( 0, 0 ) newField)
        , test "should return Just O" <|
            \() ->
                let
                    newCells =
                        Matrix.set ( 0, 0 ) (Just O) testField.cells
                            |> Matrix.set ( 1, 1 ) (Just O)
                            |> Matrix.set ( 2, 2 ) (Just O)

                    newField =
                        { testField | cells = newCells }
                in
                    Expect.equal (Just O) (Field.checkWinner ( 1, 1 ) newField)
        , test "should return Nothing" <|
            \() ->
                Expect.equal Nothing (Field.checkWinner ( 2, 2 ) testField)
        ]



-- UPDATE


update : Test
update =
    describe "#update"
        [ describe "TakeCell"
            [ test "should take a free cell" <|
                \() ->
                    let
                        newField =
                            { testField | cells = (Matrix.set ( 0, 0 ) (Just X) testField.cells) }

                        expectedRetun =
                            ( newField, Cmd.none, Just ( 0, 0 ) )
                    in
                        Expect.equal expectedRetun (Field.update (TakeCell ( 0, 0 )) X testField)
            , test "should not change anything" <|
                \() ->
                    let
                        newField =
                            { testField | cells = (Matrix.set ( 0, 0 ) (Just X) testField.cells) }

                        expectedRetun =
                            ( newField, Cmd.none, Nothing )
                    in
                        Expect.equal expectedRetun (Field.update (TakeCell ( 0, 0 )) X newField)
            ]
        ]
