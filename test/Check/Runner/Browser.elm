module Check.Runner.Browser exposing (display, displayVerbose)

{-| Browser test runner for elm-check. This module provides functions to
run and visualize tests in the browser.


# Display Test Results

@docs display, displayVerbose

-}

import Check exposing (Evidence(..), FailureOptions, SuccessOptions, UnitEvidence)
import Html exposing (Attribute, Html, div, li, ol, text, ul)
import Html.Attributes exposing (style)
import List


(:::) =
    \a b -> ( a, b )


type alias Style =
    List ( String, String )


pomegranate =
    "#c0392b"


backgroundBrown =
    "#DDCCA1"


midnightBlue =
    "#2c3e50"


nephritis =
    "#27ae60"


toColor : Bool -> String
toColor b =
    if b then
        nephritis

    else
        pomegranate


suiteStyle : Bool -> Style
suiteStyle b =
    [ "display" ::: "flex"
    , "flex-direction" ::: "column"
    , "color" ::: toColor b
    ]


displayStyle : Style
displayStyle =
    [ "width" ::: "100vw"
    , "min-height" ::: "100vh"
    , "background-color" ::: backgroundBrown
    ]


{-| Display test results in the browser.
-}
display : Evidence -> Html msg
display evidence =
    div
        [ style displayStyle ]
        [ display_ False evidence ]


{-| Verbose version of `display`. Contains additional information
about the test results.
-}
displayVerbose : Evidence -> Html msg
displayVerbose evidence =
    div
        [ style displayStyle ]
        [ display_ True evidence ]


display_ : Bool -> Evidence -> Html msg
display_ b evidence =
    case evidence of
        Unit unitEvidence ->
            displayUnit b unitEvidence

        Multiple name evidences ->
            displaySuite b name evidences


displaySuite : Bool -> String -> List Evidence -> Html msg
displaySuite b name evidences =
    li
        [ style (suiteStyle (areOk evidences)) ]
        [ text ("Suite: " ++ name)
        , ol
            []
            (List.map (display_ b) evidences)
        ]


isOk : Evidence -> Bool
isOk evidence =
    case evidence of
        Unit unitEvidence ->
            case unitEvidence of
                Ok _ ->
                    True

                _ ->
                    False

        Multiple _ evidences ->
            areOk evidences


areOk : List Evidence -> Bool
areOk evidences =
    List.all ((==) True) (List.map isOk evidences)


unitStyle : Bool -> Style
unitStyle b =
    [ "color" ::: toColor b
    , "margin-bottom" ::: "5px"
    , "margin-top" ::: "10px"
    ]


unitInnerStyle : Style
unitInnerStyle =
    [ "color" ::: midnightBlue ]


displayUnit : Bool -> UnitEvidence -> Html msg
displayUnit b unitEvidence =
    case unitEvidence of
        Ok options ->
            li
                [ style (unitStyle True) ]
                [ text (successMessage options) ]

        Err options ->
            let
                essentialParts =
                    [ li
                        []
                        [ text ("Counter example: " ++ options.counterExample) ]
                    , li
                        []
                        [ text ("Actual: " ++ options.actual) ]
                    , li
                        []
                        [ text ("Expected: " ++ options.expected) ]
                    ]

                verboseParts =
                    if not b then
                        []

                    else
                        [ li
                            []
                            [ text ("Seed: " ++ toString options.seed) ]
                        , li
                            []
                            [ text ("Number of shrinking operations performed: " ++ toString options.numberOfShrinks) ]
                        , li
                            []
                            [ text "Before shrinking: "
                            , ul
                                []
                                [ li
                                    []
                                    [ text ("Counter example: " ++ options.original.counterExample) ]
                                , li
                                    []
                                    [ text ("Actual: " ++ options.original.actual) ]
                                , li
                                    []
                                    [ text ("Expected: " ++ options.original.expected) ]
                                ]
                            ]
                        ]
            in
            li
                [ style (unitStyle False) ]
                [ text
                    (options.name
                        ++ " FAILED after "
                        ++ toString options.numberOfChecks
                        ++ " check"
                        ++ (if options.numberOfChecks == 1 then
                                ""

                            else
                                "s"
                           )
                        ++ "!"
                    )
                , ul
                    [ style unitInnerStyle ]
                    (essentialParts ++ verboseParts)
                ]


successMessage : SuccessOptions -> String
successMessage { name, seed, numberOfChecks } =
    name ++ " passed after " ++ toString numberOfChecks ++ " checks."
