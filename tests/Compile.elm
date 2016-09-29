module Compile exposing (all)

import Test exposing (..)
import WinnerTest
import MatrixTest
import HelpersTest


all : Test
all =
    describe "tic-tac-toe-extended"
        [ WinnerTest.suite
        , MatrixTest.suite
        , HelpersTest.suite
        ]
