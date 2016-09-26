module Game.Helpers
    exposing
        ( createMatrix
        )

import Array exposing (Array)
import Game.Types exposing (Row, Col)


createMatrix : Int -> (Row -> Col -> a) -> Array (Array a)
createMatrix size callback =
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
