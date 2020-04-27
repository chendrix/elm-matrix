module Shrink.Matrix exposing (..)

import Matrix exposing (Matrix)
import Shrink exposing (Shrinker, array)


matrix : Shrinker a -> Shrinker (Matrix a)
matrix =
    array >> array
