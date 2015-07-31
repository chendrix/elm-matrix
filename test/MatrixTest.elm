module MatrixTest where

import Check exposing (..)
import Check.Investigator exposing (..)
import Check.Investigator.Matrix exposing (..)
import Maybe as M exposing (..)
import Debug

import Matrix

tests = suite "Matrix Test Suite"
  [ claim_map_with_location_is_idempotent
  , claim_get_and_set_are_inverses
  , claim_to_list_and_from_list_are_inverses
  , claim_square_makes_the_right_sized_matrix
  ]

claim_map_with_location_is_idempotent =
  claim
    "Creating a new map and generating a map from locations is the same"
  `that`
    (\matrix -> Matrix.mapWithLocation (\loc _ -> loc) matrix)
  `is`
    (identity)
  `for`
    matrixUsing identity

claim_get_and_set_are_inverses =
  claim
    "Get and set are inverses"
  `that`
    (\(location, matrix, value) -> Matrix.set location value matrix |> Matrix.get location)
  `is`
    (\(location, matrix, value) -> Matrix.get location matrix |> M.map (always value))
  `for`
    tuple3 (location, matrix int, int)

claim_square_makes_the_right_sized_matrix =
  claim
    "Square makes the right sized matrix"
  `true`
    (\size ->
      let
        matrix = Matrix.square size identity
      in
        Matrix.rowCount matrix == size && Matrix.colCount matrix == size
    )
  `for`
    rangeInt 0 50

claim_to_list_and_from_list_are_inverses =
  claim
    "toList and fromList are inverses"
  `that`
    (Matrix.toList >> Matrix.fromList)
  `is`
    identity
  `for`
    matrix float