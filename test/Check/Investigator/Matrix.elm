module Check.Investigator.Matrix where

import Check.Investigator exposing (..)
import Shrink exposing (noShrink)

import Random.Matrix
import Matrix exposing (Matrix, Location)

matrix : Investigator a -> Investigator (Matrix a)
matrix v =
  let
    width = rangeInt 0 50
    height = rangeInt 0 50
  in
    investigator
      (Random.Matrix.matrix width.generator height.generator v.generator)
      (noShrink)

matrixUsing : (Location -> a) -> Investigator (Matrix a)
matrixUsing f =
  let
    width = rangeInt 0 50
    height = rangeInt 0 50
  in
    investigator
      (Random.Matrix.matrixUsing width.generator height.generator f)
      (noShrink)

location : Investigator Location
location =
  tuple (rangeInt -100 100, rangeInt -100 100)