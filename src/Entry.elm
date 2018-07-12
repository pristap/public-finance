module Entry exposing (entryForStep)

import Framework.Button exposing (button)
import Framework.Modifier exposing (Modifier(..))
import Framework.Typography exposing (h1, h4)
import Element exposing (layout, row, column, spacing, text, Element, centerX, centerY, width, height, px, html, fill, padding)
import Types exposing (..)
import I18n exposing (..)
import LineChart exposing (..)
import Html exposing (div)
import LineChart
import LineChart.Colors as Colors
import LineChart.Junk as Junk
import LineChart.Area as Area
import LineChart.Axis as Axis
import LineChart.Junk as Junk
import LineChart.Dots as Dots
import LineChart.Grid as Grid
import LineChart.Dots as Dots
import LineChart.Line as Line
import LineChart.Colors as Colors
import LineChart.Events as Events
import LineChart.Legends as Legends
import LineChart.Container as Container
import LineChart.Interpolation as Interpolation
import LineChart.Axis.Intersection as Intersection


entryForStep : Language -> LanguageData -> Step -> Element Msg
entryForStep language data step =
    let
        content =
            entryForOptions language data step
                |> List.append
                    [ h1 [ centerX, centerY, spacing <| 20, width <| fill, height <| fill ] <| text <| (I18n.t language data step.title)
                    , h4 [ centerX, centerY, spacing <| 20, width <| fill, height <| fill ] <| text <| (I18n.t language data step.description)
                    ]
    in
        column
            [ centerX, centerY, spacing <| 20, width <| fill, height <| fill ]
            content


entryForOptions : Language -> LanguageData -> Step -> List (Element Msg)
entryForOptions language data step =
    case step.type_ of
        ChooseOption ->
            entryForChooseOption language data step

        OrderList ->
            entryForOrderedList language data step


entryForOrderedList : Language -> LanguageData -> Step -> List (Element Msg)
entryForOrderedList language data step =
    [ row [ centerX, centerY, spacing <| 20, width <| fill, height <| fill ]
    (List.map (renderUnorderedButton language data) step.options)
    , row [padding <| 44, centerX, centerY, spacing <| 20, width <| fill, height <| fill ]
    (List.map (renderOrderedButton language data) step.passedOptions)
    ]


entryForChooseOption : Language -> LanguageData -> Step -> List (Element Msg)
entryForChooseOption language data step =
    [ column [centerX, centerY, width <| fill, height <| fill]
        [ row [ centerX, centerY, width <| fill, height <| fill ] [ renderGraph <| step ]
        , row [ centerX, centerY, spacing <| 20, width <| fill, height <| fill ]
        (List.map (renderChooseButton language data) step.options)
        ]
    ]


renderUnorderedButton : Language -> LanguageData -> Option -> Element Msg
renderUnorderedButton language data option =
    button [ Primary, Outlined ] (Just <| SelectOrderedOption option) (I18n.t language data option.key)


renderOrderedButton : Language -> LanguageData -> Option -> Element Msg
renderOrderedButton language data option =
    button [ Primary, Outlined ] (Just <| UndoOrderedOption option) (I18n.t language data option.key)


renderChooseButton : Language -> LanguageData -> Option -> Element Msg
renderChooseButton language data option =
    button [ Primary, Outlined ] (Just SelectChooseOption) (I18n.t language data option.key)


renderGraph : Step -> Element msg
renderGraph step =
    case step.points of
        [] ->
            Element.html <| (div [] [])

        points ->
            (LineChart.viewCustom chartConfig [ LineChart.line Colors.blueLight Dots.none "Something" points ])
                |> Element.html


chartConfig : LineChart.Config Point msg
chartConfig =
    { x = Axis.none 700 .x
    , y = Axis.default 400 "Средства" .y
    , container = Container.default "line-chart-1"
    , interpolation = Interpolation.default
    , intersection = Intersection.default
    , legends = Legends.none
    , events = Events.default
    , junk = Junk.default
    , grid = Grid.default
    , area = Area.stacked 0.5 -- Changed from the default!
    , line = Line.default
    , dots = Dots.default
    }
