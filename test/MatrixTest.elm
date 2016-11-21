module MatrixTest exposing (..)

import Check exposing (..)
import Check.Producer exposing (..)
import Check.Producer.Matrix exposing (..)
import Maybe as M exposing (..)
import Debug
import Matrix


tests =
    suite "Matrix Test Suite"
        [ claim_map_with_location_is_idempotent
        , claim_get_and_set_are_inverses
        , claim_to_list_and_from_list_are_inverses
        , claim_square_makes_the_right_sized_matrix
        ]


claim_map_with_location_is_idempotent =
    for
        (is
            (that
                (claim
                    "Creating a new map and generating a map from locations is the same"
                )
                (\matrix -> Matrix.mapWithLocation (\loc _ -> loc) matrix)
            )
            (identity)
        )
        (matrixUsing identity)


claim_get_and_set_are_inverses =
    for
        (is
            (that
                (claim
                    "Get and set are inverses"
                )
                (\( location, matrix, value ) -> Matrix.set location value matrix |> Matrix.get location)
            )
            (\( location, matrix, value ) -> Matrix.get location matrix |> M.map (always value))
        )
        (tuple3 ( location, matrix int, int ))


claim_square_makes_the_right_sized_matrix =
    for
        (true
            (claim
                "Square makes the right sized matrix"
            )
            (\size ->
                let
                    matrix =
                        Matrix.square size identity
                in
                    Matrix.rowCount matrix == size && Matrix.colCount matrix == size
            )
        )
        (rangeInt 0 50)


claim_to_list_and_from_list_are_inverses =
    for
        (is
            (that
                (claim
                    "toList and fromList are inverses"
                )
                (Matrix.toList >> Matrix.fromList)
            )
            identity
        )
        (matrix float)
