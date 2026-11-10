module Main exposing (main)

import Array exposing (Array)
import Browser
import Html exposing (Html, button, div, text)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)
import List exposing (drop, take)
import String exposing (join)



-- MODEL


type alias Model =
    { count : Int, board : Array Cell, turn : Cell, flag : Bool }


initialBoard : Model
initialBoard =
    { board =
        Array.fromList
            [ Empty
            , Empty
            , Empty
            , Empty
            , O
            , Empty
            , Empty
            , Empty
            , Empty
            ]
    , count = 0
    , turn = X
    , flag = False
    }


type Msg
    = Clicked Int
    | PrintBoard
    | Reset


type Cell
    = Empty
    | X
    | O


cellToString : Cell -> String
cellToString cell =
    case cell of
        Empty ->
            " "

        X ->
            "x"

        O ->
            "o"



-- UPDATE


update : Msg -> Model -> Model
update msg model =
    case msg of
        Clicked index ->
            case Array.get index model.board of
                Just Empty ->
                    { model | board = Array.set index model.turn model.board, turn = nextTurn model.turn }

                _ ->
                    model

        PrintBoard ->
            { model | flag = True }

        Reset ->
            initialBoard


nextTurn : Cell -> Cell
nextTurn cell =
    case cell of
        X ->
            O

        O ->
            X

        -- O or X is OK
        Empty ->
            O



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ viewboard model.board
        , div [ style "height" "2em" ] [ text (resultText model.board) ]
        , button [ onClick Reset ] [ text "リセット" ]
        ]


resultText : Array Cell -> String
resultText board =
    if judge X board then
        "x の勝ち"

    else if judge O board then
        "o の勝ち"

    else if List.member Empty (Array.toList board) then
        ""
        --default

    else
        "引き分け"


viewboard : Array Cell -> Html Msg
viewboard board =
    let
        --indexedMapは(Int -> a -> b) -> List a -> List b boardはList Cell
        cells =
            Array.indexedMap viewCell board
    in
    div []
        [ div [ style "display" "flex" ] (take 3 (Array.toList cells))
        , div [ style "display" "flex" ] (take 3 (drop 3 (Array.toList cells)))
        , div [ style "display" "flex" ] (take 3 (drop 6 (Array.toList cells)))
        ]


viewCell : Int -> Cell -> Html Msg
viewCell index cell =
    button [ style "width" "3em", style "height" "3em", style "padding" "0", onClick (Clicked index) ] [ text (cellToString cell) ]


cellAt : Int -> Array Cell -> Cell



-- cellAt i board =
--     drop i (Array.toList board)
--         |> List.head
--         |> Maybe.withDefault Empty
-- cellAt : Int -> Array Cell -> Cell


cellAt i board =
    Array.get i board
        |> Maybe.withDefault Empty


judge : Cell -> Array Cell -> Bool
judge mark board =
    List.any (\line -> List.all (\i -> cellAt i board == mark) line) winLines


winLines : List (List Int)
winLines =
    [ [ 0, 1, 2 ]
    , [ 3, 4, 5 ]
    , [ 6, 7, 8 ]
    , [ 0, 3, 6 ]
    , [ 1, 4, 7 ]
    , [ 2, 5, 8 ]
    , [ 0, 4, 8 ]
    , [ 2, 4, 6 ]
    ]


main =
    Browser.sandbox
        { init = initialBoard
        , view = view
        , update = update
        }
