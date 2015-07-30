module Random.Matrix where

import Random exposing (..)
import Matrix exposing (Matrix, Location)

matrix : Generator Int -> Generator Int -> (Location -> a) -> Generator (Matrix a)
matrix widthGenerator heightGenerator f =
  customGenerator <| \seed ->
    let
      (width, seed') = generate widthGenerator seed
      (height, seed'') = generate heightGenerator seed'
    in
      (Matrix.matrix width height f, seed'')