module Compile exposing (all)

import Test exposing (..)
import WinnerTest


all : Test
all =
    describe "tic-tac-toe-extended"
        [ WinnerTest.suite
        ]
