module Main exposing (..)

import Check exposing (..)
import Check.Runner.Browser exposing (display)
import MatrixTest


tests : Claim
tests =
    suite "Matrix Tests"
        [ MatrixTest.tests
        ]


result : Evidence
result =
    quickCheck tests


main =
    display result
