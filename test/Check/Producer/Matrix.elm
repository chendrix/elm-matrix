module Check.Producer.Matrix exposing (..)

import Check.Producer exposing (..)
import Matrix exposing (Location, Matrix)
import Matrix.Random
import Shrink exposing (noShrink)
import Shrink.Matrix as S


matrix : Producer a -> Producer (Matrix a)
matrix v =
    let
        width =
            rangeInt 0 50

        height =
            rangeInt 0 50
    in
    Producer
        (Matrix.Random.matrix width.generator height.generator v.generator)
        (S.matrix v.shrinker)


matrixUsing : (Location -> a) -> Producer (Matrix a)
matrixUsing f =
    let
        width =
            rangeInt 0 50

        height =
            rangeInt 0 50
    in
    Producer
        (Matrix.Random.matrixUsing width.generator height.generator f)
        noShrink


location : Producer Location
location =
    tuple ( rangeInt -10 50, rangeInt -10 50 )
