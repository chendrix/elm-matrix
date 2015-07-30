import Check.Runner.Browser exposing (display)
import Check exposing (..)

import MatrixTest

result = quickCheck tests

main = display result

tests = suite "Matrix Tests"
        [ MatrixTest.tests
        ]


