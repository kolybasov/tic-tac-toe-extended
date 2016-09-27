module Game.Matrix
    exposing
        ( Matrix
        , create
        , flatten
        , get
        , set
        , all
        )

import Array exposing (Array)
import Game.Types exposing (Row, Col, Coords)
import List


type alias Matrix a =
    Array (Array a)


{-| Create square matrix from given size.

    create 2 (\row col -> ( row, col ))
    --  ____________
    -- |     |     |
    -- |(0,0)|(0,1)|
    -- |_____|_____|
    -- |     |     |
    -- |(1,0)|(1,1)|
    -- |_____|_____|
-}
create : Int -> (Row -> Col -> a) -> Matrix a
create size callback =
    let
        arrToMap =
            Array.fromList [0..(size - 1)]
    in
        Array.map
            (\row ->
                Array.map
                    (\col ->
                        callback row col
                    )
                    arrToMap
            )
            arrToMap


flatten : Matrix a -> Array a
flatten arr =
    Array.toList (Array.map (\child -> Array.toList child) arr)
        |> List.concat
        |> Array.fromList


all : (a -> Bool) -> Matrix a -> Bool
all func matrix =
    flatten matrix
        |> Array.filter func
        |> Array.isEmpty


get : Coords -> Matrix a -> Maybe a
get ( row, col ) matrix =
    Array.get row matrix `Maybe.andThen` Array.get col


set : Coords -> a -> Matrix a -> Matrix a
set ( row, col ) el matrix =
    let
        rowToChange =
            Array.get row matrix

        newRow =
            case rowToChange of
                Just row' ->
                    Just (Array.set col el row')

                Nothing ->
                    Nothing
    in
        case newRow of
            Just row' ->
                Array.set row row' matrix

            Nothing ->
                matrix
