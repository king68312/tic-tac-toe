module Main exposing (main)

import Browser
import Html exposing (Html, button, div, text)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)
import List exposing (drop, take)
import String exposing (join)



--import String exposing (concat)


type alias Model =
    { count : Int, board : List Cell, turn : Cell, flag : Bool }


initialBoard : Model
initialBoard =
    { count = 0
    , board =
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


update : Msg -> Model -> Model
update msg model =
    case msg of
        Clicked index ->
            -- placeAt       Cell->Int->Int->Cell->Cell
            -- indexedMap : (Int -> a -> b) -> List a -> List b
            -- placeAt model.turn index  Cell->Int->Cell->Cell　これはindexecMapの引数(Int->a->b)と一致する。
            -- model.boardはList cellなので正しい
            -- markを入れた状態のマスのCellを返す
            let
                newBoard =
                    List.indexedMap (placeAt model.turn index) model.board
            in
            if newBoard == model.board then
                model

            else
                { model | board = newBoard, turn = nextTurn model.turn }

        {-
           case List.head (List.drop index model.board) of
               Just cell ->
                   case cell of
                       Empty ->
                           { model | board = List.indexedMap (\i c -> if i == index then X else c) model.board}
                       _ ->
                               model
               Nothing ->
                   model
        -}
        PrintBoard ->
            { model | flag = True }

        Reset ->
            initialBoard



-- placeAt indexで targetは入っている状態。マスの番号とマスはList.indexedMapで1マスずつ渡していく
-- indexedMapは(Int -> a -> b) -> List a -> List b


placeAt : Cell -> Int -> Int -> Cell -> Cell
placeAt mark target i c =
    if i == target && c == Empty then
        mark

    else
        c


nextTurn : Cell -> Cell
nextTurn cell =
    case cell of
        X ->
            O

        O ->
            X

        Empty ->
            O



-- modelで画面を構成する要素として必要


view : Model -> Html Msg



-- 出たMsgをうけてupdateで新しく画面を作る


view model =
    div []
        [ viewboard model.board
        , div [ style "height" "2em" ] [ text (resultText model.board) ]
        , button [ onClick Reset ] [ text "リセット" ]
        ]


resultText : List Cell -> String
resultText board =
    if judge X board then
        "x の勝ち"

    else if judge O board then
        "o の勝ち"

    else if List.member Empty board then
        ""

    else
        "引き分け"



{-
   viewboard: List Cell -> Html msg
   viewboard board =
       let
           -- List Cell内部のCellをcellToStringでCell->Stringに変換
           cells = List.map cellToString board
       in
       text
           (String.join "\n"
               [ String.join "|" (take 3 cells)
               , "------"
               , String.join "|" (take 3 (drop 3 cells))
               , "------"
               , String.join "|" (take 3 (drop 6 cells))
               ]
           )

-}


viewboard : List Cell -> Html Msg
viewboard board =
    let
        --indexedMapは(Int -> a -> b) -> List a -> List b boardはList Cell
        cells =
            List.indexedMap viewCell board
    in
    div []
        [ div [ style "display" "flex" ] (take 3 cells)
        , div [ style "display" "flex" ] (take 3 (drop 3 cells))
        , div [ style "display" "flex" ] (take 3 (drop 6 cells))
        ]


viewCell : Int -> Cell -> Html Msg
viewCell index cell =
    button [ style "width" "3em", style "height" "3em", style "padding" "0", onClick (Clicked index) ] [ text (cellToString cell) ]


cellAt : Int -> List Cell -> Cell
cellAt i board =
    List.drop i board
        |> List.head
        |> Maybe.withDefault Empty


judge : Cell -> List Cell -> Bool
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
