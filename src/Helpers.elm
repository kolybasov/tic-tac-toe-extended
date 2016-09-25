module Helpers exposing (..)

import Array exposing (Array)
import Types exposing (Row, Col)


createMatrix : Int -> (Row -> Col -> a) -> Array (Array a)
createMatrix size callback =
    let
        arrToMap =
            Array.fromList [0..size]
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
