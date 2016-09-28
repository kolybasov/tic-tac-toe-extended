module Tests exposing (..)

import Test exposing (..)
import Compile


all : Test
all =
    describe "tic-tac-toe-extended"
        [ Compile.all
        ]
