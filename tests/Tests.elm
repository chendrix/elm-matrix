module Tests exposing (..)

import Test exposing (..)
import Expect
import Fuzz exposing (int, tuple, Fuzzer, intRange, tuple3, custom)
import String
import Matrix exposing (Matrix, Location)
import Random.Pcg as Random
import Shrink
import Shrink.Matrix
import Matrix.Random


all : Test
all =
    describe "Matrix Test Suite"
        [ fuzz (matrixUsing identity) "Creating a new map and generating a map from locations is the same" <|
            \aMatrix ->
                aMatrix |> Expect.equal (Matrix.mapWithLocation (\loc _ -> loc) aMatrix)
        , fuzz (tuple3 ( location, matrix (Random.int -50 50) Shrink.int, int )) "Get and set are inverses" <|
            \( location, m, value ) ->
                Matrix.set location value m |> Matrix.get location |> Maybe.map (always value) |> Expect.equal value
        ]


matrix : Random.Generator a -> Shrink.Shrinker a -> Fuzzer (Matrix a)
matrix v s =
    let
        width =
            Random.int 0 50

        height =
            Random.int 0 50
    in
        custom (Matrix.Random.matrix width height v) (Shrink.Matrix.matrix s)


matrixUsing : (Location -> a) -> Fuzzer (Matrix a)
matrixUsing f =
    let
        width =
            Random.int 0 50

        height =
            Random.int 0 50
    in
        custom (Matrix.Random.matrixUsing width height f) (Shrink.noShrink)


location : Fuzzer Location
location =
    tuple ( intRange -10 50, intRange -10 50 )



--
--tests =
--    suite "Matrix Test Suite"
--        [ claim_map_with_location_is_idempotent
--        , claim_get_and_set_are_inverses
--        , claim_to_list_and_from_list_are_inverses
--        , claim_square_makes_the_right_sized_matrix
--        ]
--
--
--claim_map_with_location_is_idempotent =
--    for
--        (is
--            (that
--                (claim
--                    "Creating a new map and generating a map from locations is the same"
--                )
--                (\matrix -> Matrix.mapWithLocation (\loc _ -> loc) matrix)
--            )
--            (identity)
--        )
--        matrixUsing
--        identity
--
--
--claim_get_and_set_are_inverses =
--    for
--        (is
--            (that
--                (claim
--                    "Get and set are inverses"
--                )
--                (\( location, matrix, value ) -> Matrix.set location value matrix |> Matrix.get location)
--            )
--            (\( location, matrix, value ) -> Matrix.get location matrix |> M.map (always value))
--        )
--        tuple3
--        ( location, matrix int, int )
--
--
--claim_square_makes_the_right_sized_matrix =
--    for
--        (true
--            (claim
--                "Square makes the right sized matrix"
--            )
--            (\size ->
--                let
--                    matrix =
--                        Matrix.square size identity
--                in
--                    Matrix.rowCount matrix == size && Matrix.colCount matrix == size
--            )
--        )
--        rangeInt
--        0
--        50
--
--
--claim_to_list_and_from_list_are_inverses =
--    for
--        (is
--            (that
--                (claim
--                    "toList and fromList are inverses"
--                )
--                (Matrix.toList >> Matrix.fromList)
--            )
--            identity
--        )
--        matrix
--        float
