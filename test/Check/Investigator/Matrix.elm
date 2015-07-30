module Check.Investigator.Matrix where

import Check.Investigator exposing (..)
import Shrink exposing (..)

import Random.Matrix
import Matrix exposing (Matrix, Location)

{-| Investigator array constructor. Generates random arrays of values of size
between 0 and 10 from a given investigator generator using the `rangeLengthArray`
generator constructor from elm-random-extra and the `array` shrinker constructor
from elm-shrink. Ideal for local testing.
-}
matrix : (Location -> a) -> Investigator (Matrix a)
matrix f =
  let
    width = rangeInt 0 50
    height = rangeInt 0 50
  in
    investigator
      (Random.Matrix.matrix width.generator height.generator f)
      (noShrink)

