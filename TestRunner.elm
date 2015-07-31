import IO.IO exposing (..)
import IO.Runner exposing (Request, Response, run)
import Check.Runner.Console exposing (runDisplay, runDisplayVerbose)
import Check exposing (..)

import MatrixTest

tests : Claim
tests = suite "Matrix Tests"
        [ MatrixTest.tests
        ]

result : Evidence
result = quickCheck tests


port requests : Signal Request
port requests = run responses (runDisplay result)

port responses : Signal Response