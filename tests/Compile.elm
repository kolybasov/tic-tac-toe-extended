module Compile exposing (all)

import Test exposing (..)
import WinnerTest
import MatrixTest
import HelpersTest
import FieldTest
import BoardTest


all : Test
all =
    describe "tic-tac-toe-extended"
        [ WinnerTest.suite
        , MatrixTest.suite
        , HelpersTest.suite
        , FieldTest.suite
        , BoardTest.suite
        ]
