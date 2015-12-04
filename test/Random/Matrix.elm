module Random.Matrix where

import Random exposing (..)
import Matrix exposing (Matrix, Location)
import Array exposing (foldl, Array)

matrix : Generator Int -> Generator Int -> Generator a -> Generator (Matrix a)
matrix widthGenerator heightGenerator elementGenerator =
  widthGenerator `andThen` \width ->
    heightGenerator `andThen` \height ->
      let
        rowGenerator = 
          list width elementGenerator
          |> map Array.fromList
        
        matrixAsArrayGenerator = 
          list height rowGenerator
          |> map Array.fromList 
        
      in
        matrixAsArrayGenerator

matrixUsing  : Generator Int -> Generator Int -> (Location -> a) -> Generator (Matrix a)
matrixUsing  widthGenerator heightGenerator f =
  map2 (\width height -> 
    Matrix.matrix width height f
  ) widthGenerator heightGenerator