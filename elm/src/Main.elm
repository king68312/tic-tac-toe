module Main exposing (main)

import Array exposing (Array)
import Browser
import Html exposing (Html, button, div, text)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)
import List exposing (drop, take)



-- MODEL


type alias Model =
    { board : Array Cell, turn : Cell, flag : Bool }


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
    , turn = X
    , flag = False
    }


type Msg
    = Clicked Int
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
    case winner board of
        Just X ->
            "x の勝ち"

        Just O ->
            "o の勝ち"

        _ ->
            --リストのメンバ関数にEmptyが含まれるか
            if List.member Empty (Array.toList board) then
                ""

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



-- インデックスとその盤面を投げることでCellのマークがわかる


cellAt : Int -> Array Cell -> Cell
cellAt i board =
    Array.get i board
        |> Maybe.withDefault Empty


winnerOfLine : List Cell -> Maybe Cell
winnerOfLine board =
    case board of
        [ X, X, X ] ->
            Just X

        [ O, O, O ] ->
            Just O

        _ ->
            Nothing


winner : Array Cell -> Maybe Cell
winner board =
    winLines
        |> List.map (\line -> List.map (\i -> cellAt i board) line)
        |> List.filterMap winnerOfLine
        |> List.head


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
