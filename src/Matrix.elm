module Matrix where

import Array
import List
import Maybe exposing (..)

type alias Matrix a = Array.Array (Array.Array a)
type alias Location = (Int, Int)

loc : Int -> Int -> Location
loc = (,)

square : Int -> (Location -> a) -> Matrix a
square size = initialize size size

initialize : Int -> Int -> (Location -> a) -> Matrix a
initialize numRows numCols f =
  Array.initialize numRows (
    \row -> Array.initialize numCols (
      \col -> f (loc row col)))

map : (a -> b) -> Matrix a -> Matrix b
map f m =
  Array.map (Array.map f) m

mapWithLocation : (Location -> a -> b) -> Matrix a -> Matrix b
mapWithLocation f m =
  Array.indexedMap (
    \rowNum row -> Array.indexedMap (
      \colNum element ->
        f (loc rowNum colNum)) element
    ) row
  ) m

toList : Matrix a -> List (List a)
toList m =
  Array.map Array.toList m
  |> Array.toList

flatten : Matrix a -> List a
flatten m =
  List.concat <| toList m

elementAt : Matrix a -> Location ->  Maybe a
elementAt m (rowNum, colNum) =
  Array.get rowNum m `andThen` Array.get colNum