module MatrixTest where

import Check exposing (..)
import Check.Investigator.Matrix exposing (matrix)
import Matrix

tests = suite "Matrix Test Suite"
  [ claim_map_with_location_is_idempotent
  ]

claim_map_with_location_is_idempotent =
  claim
    "Creating a new map and generating a map from locations is the same"
  `that`
    (\matrix -> Matrix.mapWithLocation (\loc _ -> loc) matrix)
  `is`
    (identity)
  `for`
    matrix identity

