module Check.Runner.Console
  ( runDisplay
  , runDisplayVerbose
  ) where
{-| Console test runner for elm-check. This module provides functions to
run tests in the console.

# Display Test Results
@docs runDisplay

-}

import Check exposing (Evidence (..), UnitEvidence, SuccessOptions, FailureOptions)
import List
import String

import IO.IO exposing (..)


{-| Display verbose test results in the console.
-}
runDisplayVerbose : Evidence -> IO ()
runDisplayVerbose = runDisplay' True


{-| Display test results in the console.
-}
runDisplay : Evidence -> IO ()
runDisplay = runDisplay' False


runDisplay' : Bool -> Evidence -> IO ()
runDisplay' verbose evidence =
  let
    allPassed = isOk evidence
    results = display' verbose 0 evidence
    out = String.concat << List.intersperse "\n" <| results
  in
    putStrLn out >>>
      case allPassed of
        True  -> exit 0
        False -> exit 1


display' : Bool -> Int -> Evidence -> List String
display' verbose n evidence = case evidence of
  Unit unitEvidence ->
    displayUnit verbose n unitEvidence
  Multiple name evidences ->
    displaySuite verbose n name evidences


displaySuite : Bool -> Int -> String -> List Evidence -> List String
displaySuite verbose n name evidences =
  let
    allPassed = areOk evidences
    msg = "Test Suite: " ++ name ++ ": "
        ++ if allPassed then "all tests passed" else "FAILED"
    subResults =
      if allPassed
      then []
      else List.concatMap (display' verbose (n + 2)) evidences
  in
    indent n msg :: subResults


isOk : Evidence -> Bool
isOk evidence = case evidence of
  Unit unitEvidence -> case unitEvidence of
    Ok _ -> True
    _ -> False
  Multiple _ evidences ->
    areOk evidences


areOk : List Evidence -> Bool
areOk evidences =
  List.all ((==) True) (List.map isOk evidences)


displayUnit : Bool -> Int -> UnitEvidence -> List String
displayUnit verbose n unitEvidence =
  case unitEvidence of
    Ok options ->
      [indent n (successMessage options)]

    Err options ->
      let
        n' = n + 2
        essentialParts =
          [ "Counter example: " ++ options.counterExample
          , "Actual: " ++ options.actual
          , "Expected: " ++ options.expected
          ]

        verboseParts =
          if not verbose then []
          else
            [ "Seed: " ++ (toString options.seed.state)
            , "Number of shrinking operations performed: " ++ (toString options.numberOfShrinks)
            , "Before shrinking: "
            ] ++
            (List.map (indent 2)
              [ "Counter example: " ++ options.original.counterExample
              , "Actual: " ++ options.original.actual
              , "Expected: " ++ options.original.expected
              ]
            )
      in
        failMessage options
        :: List.map (indent 2) (essentialParts ++ verboseParts)
        |> List.map (indent n)


failMessage : FailureOptions -> String
failMessage options =
  options.name ++ " FAILED after " ++ (toString options.numberOfChecks) ++ " check"++ (if options.numberOfChecks == 1 then "" else "s") ++ "!"


successMessage : SuccessOptions -> String
successMessage {name, seed, numberOfChecks} =
  name ++ " passed after " ++ (toString numberOfChecks) ++ " checks."


  -- | Some pretty printing stuff. Should be factored into a pretty printing library.
vcat : List String -> String
vcat = String.concat << List.intersperse "\n"


replicate : Int -> Char -> String
replicate n c = let go n = if n <= 0
                           then []
                           else c :: go (n - 1)
                in String.fromList << go <| n


indent : Int -> String -> String
indent n = let indents = replicate n ' '
           in vcat << List.map (String.append indents) << String.lines
