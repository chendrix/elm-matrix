module Random.Matrix where

import Random exposing (..)
import Matrix exposing (Matrix, Location)
import Array exposing (foldl)

matrix : Generator Int -> Generator Int -> Generator a -> Generator (Matrix a)
matrix widthGenerator heightGenerator elementGenerator =
  customGenerator <| \seed ->
    let
      (width, seed') = generate widthGenerator seed
      (height, seed'') = generate heightGenerator seed'
      matrixOfGenerators = Matrix.matrix width height (always elementGenerator)
    in
      convert matrixOfGenerators seed''

matrixUsing  : Generator Int -> Generator Int -> (Location -> a) -> Generator (Matrix a)
matrixUsing  widthGenerator heightGenerator f =
  customGenerator <| \seed ->
    let
      (width, seed') = generate widthGenerator seed
      (height, seed'') = generate heightGenerator seed'
    in
      (Matrix.matrix width height f, seed'')

convert : Matrix (Generator a) -> Seed -> (Matrix a, Seed)
convert m initialSeed =
  foldl (
    \row (curMatrix, curRowSeed) ->

      let
        (newRow, newRowSeed) =
          foldl (
            \generator (curRow, curCellSeed) ->
              let
                (newCell, newCellSeed) =
                  generate generator curCellSeed
              in
                (Array.push newCell curRow, newCellSeed)
            ) (Array.empty, curRowSeed) row
      in
        (Array.push newRow curMatrix, newRowSeed)
  ) (Array.empty, initialSeed) m
