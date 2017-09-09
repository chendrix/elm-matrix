module Tests exposing (..)

import Test exposing (..)
import Expect
import Matrix


suite : Test
suite =
  describe "Matrix"
    [ test "Matrix.square" <|
      \() ->
        let
          actual = Matrix.square 2 (\_ -> "T")
          expected = Matrix.fromList [["T","T"],["T","T"]]
        in
          Expect.equal actual expected

    , test "Matrix.matrix" <|
      \() ->
        let
          actual = Matrix.matrix 3 2 (\_ -> "T")
          expected = Matrix.fromList [["T","T"],["T","T"],["T","T"]]
        in
          Expect.equal actual expected

    , test "Matrix.map" <|
      \() ->
        let
          actual = Matrix.map ((+) 1) <| Matrix.fromList [[1,2],[3,4]]
          expected = Matrix.fromList [[2,3],[4,5]]
        in
          Expect.equal actual expected

    , test "Matrix.mapWithLocation" <|
      \() ->
        let
          original = Matrix.fromList [[1,1],[1,1],[1,1]]
          fn = (\(row, col) element -> row + col + element)
          actual = Matrix.mapWithLocation fn original
          expected = Matrix.fromList [[1,2],[2,3],[3,4]]
        in
          Expect.equal actual expected

    , test "Matrix.zip" <|
      \() ->
        let
          numbers = Matrix.fromList [[1,2],[3,4]]
          letters = Matrix.fromList [["A","B"],["C","D"]]
          actual = Matrix.zip numbers letters
          expected = Matrix.fromList [[(1,"A"),(2,"B")],[(3,"C"),(4,"D")]]
        in
          Expect.equal actual expected

    , test "Matrix.unzip" <|
      \() ->
        let
          zipped = Matrix.fromList [[(1,"A"),(2,"B")],[(3,"C"),(4,"D")]]
          actual = Matrix.unzip zipped
          numbers = Matrix.fromList [[1,2],[3,4]]
          letters = Matrix.fromList [["A","B"],["C","D"]]
          expected = (numbers, letters)
        in
          Expect.equal actual expected

    , test "Matrix.toList" <|
      \() ->
        let
          actual = Matrix.toList <| Matrix.square 2 (\_ -> "T")
          expected = [["T","T"],["T","T"]]
        in
          Expect.equal actual expected

    , test "Matrix.fromList" <|
      \() ->
        let
          actual = Matrix.fromList [["T","T"],["T","T"]]
          expected = Matrix.square 2 (\_ -> "T")
        in
          Expect.equal actual expected

    , test "Matrix.flatten" <|
      \() ->
        let
          actual = Matrix.flatten <| Matrix.square 2 (\_ -> "T")
          expected = ["T","T","T","T"]
        in
          Expect.equal actual expected

    , test "Matrix.get - Element Present" <|
      \() ->
        let
          actual = Matrix.get (0,0) <| Matrix.fromList [[1,2],[3,4]]
          expected = Just 1
        in
          Expect.equal actual expected

    , test "Matrix.get - Element Absent" <|
      \() ->
        let
          actual = Matrix.get (5,7) <| Matrix.fromList [[1,2],[3,4]]
          expected = Nothing
        in
          Expect.equal actual expected

    , test "Matrix.set" <|
      \() ->
        let
          actual = Matrix.set (0,0) 42 <| Matrix.fromList [[1,2],[3,4]]
          expected = Matrix.fromList [[42,2],[3,4]]
        in
          Expect.equal actual expected

    , test "Matrix.update" <|
      \() ->
        let
          actual = Matrix.update (0,0) ((+) 9) <| Matrix.fromList [[1,2],[3,4]]
          expected = Matrix.fromList [[10,2],[3,4]]
        in
          Expect.equal actual expected

    , test "Matrix.colCount" <|
      \() ->
        let
          actual = Matrix.colCount <| Matrix.square 5 (\_ -> "T")
          expected = 5
        in
          Expect.equal actual expected

    , test "Matrix.rowCount" <|
      \() ->
        let
          actual = Matrix.rowCount <| Matrix.square 5 (\_ -> "T")
          expected = 5
        in
          Expect.equal actual expected
    ]
