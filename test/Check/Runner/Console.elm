module Check.Runner.Console
  ( runDisplay
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

(:::) = (,)


{-| Display test results in the console.
-}
runDisplay : Evidence -> IO ()
runDisplay evidence =
  let
    summary = ""
    allPassed = isOk evidence
    results = display' 0 evidence
    out = summary ++ "\n\n" ++ (String.concat << List.intersperse "\n" <| results)
  in
    putStrLn out >>>
      case allPassed of
        True  -> exit 0
        False -> exit 1


display' : Int -> Evidence -> List String
display' n evidence = case evidence of
  Unit unitEvidence ->
    displayUnit n unitEvidence
  Multiple name evidences ->
    displaySuite n name evidences


displaySuite : Int -> String -> List Evidence -> List String
displaySuite n name evidences =
  let
    allPassed = areOk evidences
    msg = "Test Suite: " ++ name ++ ": "
        ++ if allPassed then "all tests passed" else "FAILED"
    subResults =
      if allPassed
      then []
      else List.concatMap (display' (n + 2)) evidences
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


displayUnit : Int -> UnitEvidence -> List String
displayUnit n unitEvidence =
  case unitEvidence of
    Ok options ->
      [indent n (successMessage options)]

    Err options ->
      []
      --let
      --    essentialParts =
      --      [ li
      --          []
      --          [ text ("Counter example: " ++ options.counterExample) ]
      --      , li
      --          []
      --          [ text ("Actual: " ++ options.actual) ]
      --      , li
      --          []
      --          [ text ("Expected: " ++ options.expected)]

      --      ]

      --    verboseParts =
      --      if not b then []
      --      else
      --        [ li
      --            []
      --            [ text ("Seed: " ++ (toString options.seed.state)) ]
      --        , li
      --            []
      --            [ text ("Number of shrinking operations performed: " ++ (toString options.numberOfShrinks)) ]
      --        , li
      --            []
      --            [ text "Before shrinking: "
      --            , ul
      --                []
      --                [ li
      --                    []
      --                    [ text ("Counter example: " ++ options.original.counterExample) ]
      --                , li
      --                    []
      --                    [ text ("Actual: " ++ options.original.actual) ]
      --                , li
      --                    []
      --                    [ text ("Expected: " ++ options.original.expected) ]
      --                ]
      --            ]
      --        ]
      --in
      --    li
      --      [ style (unitStyle False) ]
      --      [ text (options.name ++ " FAILED after " ++ (toString options.numberOfChecks) ++ " check"++ (if options.numberOfChecks == 1 then "" else "s") ++ "!")
      --      , ul
      --          [ style unitInnerStyle ]
      --          (essentialParts ++ verboseParts)
      --      ]

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
