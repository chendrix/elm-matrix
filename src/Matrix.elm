module Matrix where

{-| A library for creating and using 2-D matrices/grids. Geared towards
2-D games.

# Locations

@docs Location, loc, row, col

# Matrices

@docs Matrix

## Create
@docs matrix, square, fromList

## Transform
@docs map, mapWithLocation, flatten

## Access
@docs elementAt

## Convert to other types
@docs toList

-}

import Array
import List
import Maybe exposing (..)


{-| An ordered collection of elements, all of a particular type, arranged into `m` rows and `n` columns.

Matrices are 1-indexed.
-}
type alias Matrix a = Array.Array (Array.Array a)


{-| A representation of a row number and a column number, used to locate and access elements in a matrix.
-}
type alias Location = (Int, Int)


{-| Turn two integers into a location
-}
loc : Int -> Int -> Location
loc = (,)


{-| Extract the row number from a location

    row (loc 3 5) == 3

-}
row : Location -> Int
row = fst


{-| Extract the col number from a location

    col (loc 3 5) == 5

-}
col : Location -> Int
col = snd


{-| Create a square matrix of a certain size

    square 2 (\_ -> 'H') == H H
                            H H
-}
square : Int -> (Location -> a) -> Matrix a
square size = matrix size size


{-| Initialize a new matrix of size `m x n`.
Delegates to a function of type `Location -> a` to determine value to
place at each element in the matrix.

A reminder that matrices are 1-indexed.

    matrix 3 5 (\location ->
      if (isEven row location) then "Hello" else "World")

will give back the matrix

    World World World World World
    Hello Hello Hello Hello Hello
    World World World World World
-}
matrix : Int -> Int -> (Location -> a) -> Matrix a
matrix numRows numCols f =
  Array.initialize numRows (
    \row -> Array.initialize numCols (
      \col -> f (loc row col)))


{-| Apply the function to every element in the matrix

    map not (fromList [[True, False], [False, True]]) == fromList [[False, True], [True, False]]
-}
map : (a -> b) -> Matrix a -> Matrix b
map f m =
  Array.map (Array.map f) m


{-| Apply the function to every element in the list, where the first function argument
is the location of the element. Reminder that matrices are 1 indexed.

    let
      m = (square 2 (\_ -> 1))
      f location element = if row location == col location
                            then element * 2
                            else element
    in
      mapWithLocation f m == fromList [[2, 1], [1, 2]]

-}
mapWithLocation : (Location -> a -> b) -> Matrix a -> Matrix b
mapWithLocation f m =
  Array.indexedMap (
    \rowNum row -> Array.indexedMap (
      \colNum element ->
        f (loc (rowNum + 1) (colNum + 1)) element
    ) row
  ) m


{-| Convert a matrix to a list of lists

    toList (fromList [[1, 0], [0, 1]]) == [[1, 0], [0, 1]]

-}
toList : Matrix a -> List (List a)
toList m =
  Array.map Array.toList m
  |> Array.toList


{-| Convert a list of lists into a matrix

    fromList [[1, 0], [0, 1]] == square 2 (\l -> if row l == col l then 1 else 0)
-}
fromList : List (List a) -> Matrix a
fromList l =
  List.map Array.fromList l
  |> Array.fromList


{-| Convert a matrix to a single list

    let
      m = fromList [[0, 1], [2, 3], [4, 5]]
    in
      flatten m == [0, 1, 2, 3, 4, 5]
-}
flatten : Matrix a -> List a
flatten m =
  List.concat <| toList m


{-| Get the element at a particular location

    elementAt (loc -1 2) (square 2 (\_ -> True)) == Nothing

    elementAt (loc 2 2) (fromList [[0, 1], [2, 3]]) == Just 3
-}
elementAt : Location -> Matrix a -> Maybe a
elementAt location m =
  Array.get (row location) m `andThen` Array.get (col location)