module Main exposing (..)

import Framework.Button as Button
import Framework.Modifier exposing (Modifier(..))
import Element exposing (layout, text, width, height, px, spacing, centerX, centerY, fill, padding)
import Engine exposing (..)
import Types exposing (..)
import I18n exposing (..)
import Entry exposing (..)
import Framework.Typography exposing (h1, h4)
import Html
import List.Extra exposing (..)
import Dict exposing (..)
import Framework.Card as Card


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


type alias Model =
    { engine : Engine.Engine
    , language : Language
    , stepIndex : Int
    , languageData : LanguageData
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Noop ->
            ( model, Cmd.none )

        SelectOrderedOption option ->
            let
                ( newEngine, cmd ) =
                    Engine.selectOrderedOption model.engine option
                        |> checkOrderedEndGame
            in
                ( { model
                    | engine = newEngine
                  }
                , cmd
                )

        UndoOrderedOption option ->
            let
                newEngine =
                    Engine.unselectOrderedOption model.engine option
            in
                ( { model
                    | engine = newEngine
                  }
                , Cmd.none
                )

        SelectChooseOption ->
            ( { model
                | engine = Engine.passStep <| model.engine
              }
            , Cmd.none
            )

        EndGame ->
            ( model, Cmd.none )


view : Model -> Html.Html Msg
view model =
    let
        content =
            case List.head model.engine.steps of
                Just hd ->
                    entryForStep model.language model.languageData hd

                Nothing ->
                    h1 [] <| text "Game Over!"
    in
        layout [ centerX, centerY, (spacing 44), (spacing 44), width <| fill, height <| fill, padding <| 44] <| Card.simple <| content


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


init : ( Model, Cmd Msg )
init =
    ( { engine = initEngine
      , language = I18n.Macedonian
      , stepIndex = 0
      , languageData =
            { mk = I18n.mk
            , en = I18n.en
            , al = I18n.al
            }
      }
    , Cmd.none
    )
