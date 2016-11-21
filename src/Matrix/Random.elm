module Matrix.Random exposing (..)

{-| This module lets you generate random Matrices.

@docs matrix, matrixUsing

-}

import Random exposing (..)
import Matrix exposing (Matrix, Location)
import Array exposing (foldl, Array)


{-| Generate a matrix with a random width and height, filled with random elements.

    matrix (Random.int 1 4) (Random.int 2 5) (Random.bool)

The example above will generate you a matrix anywhere between 1-4 rows, 2-5 columns, filled with random Booleans.

-}
matrix : Generator Int -> Generator Int -> Generator a -> Generator (Matrix a)
matrix widthGenerator heightGenerator elementGenerator =
    widthGenerator
        |> andThen
            (\width ->
                heightGenerator
                    |> andThen
                        (\height ->
                            let
                                rowGenerator =
                                    list width elementGenerator
                                        |> map Array.fromList

                                matrixAsArrayGenerator =
                                    list height rowGenerator
                                        |> map Array.fromList
                            in
                                matrixAsArrayGenerator
                        )
            )


{-| Generate a matrix of a random width and height, but whose elements are generated via a function given the location of that element in the matrix.

    matrix
      (Random.int 1 4)
      (Random.int 1 2)
      (\location ->
        if (row loc % 2 == 0) then
          True
        else
          False
      )

In the example above, if it makes a 4x2 matrix, it will be

    T T T T
    F F F F

-}
matrixUsing : Generator Int -> Generator Int -> (Location -> a) -> Generator (Matrix a)
matrixUsing widthGenerator heightGenerator f =
    map2
        (\width height ->
            Matrix.matrix width height f
        )
        widthGenerator
        heightGenerator
