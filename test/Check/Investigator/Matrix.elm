module Check.Investigator.Matrix where

import Check.Investigator exposing (..)
import Shrink.Matrix as S
import Shrink exposing (noShrink)

import Matrix.Random
import Matrix exposing (Matrix, Location)

matrix : Investigator a -> Investigator (Matrix a)
matrix v =
  let
    width = rangeInt 0 50
    height = rangeInt 0 50
  in
    investigator
      (Matrix.Random.matrix width.generator height.generator v.generator)
      (S.matrix v.shrinker)

matrixUsing : (Location -> a) -> Investigator (Matrix a)
matrixUsing f =
  let
    width = rangeInt 0 50
    height = rangeInt 0 50
  in
    investigator
      (Matrix.Random.matrixUsing width.generator height.generator f)
      (noShrink)

location : Investigator Location
location =
  tuple (rangeInt -10 50, rangeInt -10 50)