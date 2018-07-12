module Engine exposing (Engine, initEngine, passStep, selectOrderedOption, unselectOrderedOption, checkOrderedEndGame)

import Types exposing (..)
import List.Extra exposing (..)
import Util exposing (..)


type alias Engine =
    { steps : List Step
    , passed : List Step
    }


initEngine : Engine
initEngine =
    { steps = initSteps
    , passed = []
    }


passStep : Engine -> Engine
passStep engine =
    case uncons engine.steps of
        Just ( hd, tl ) ->
            let
                newPassed =
                    hd :: engine.passed
            in
                { engine
                    | passed = newPassed
                    , steps = tl
                }

        Nothing ->
            engine


checkOrderedEndGame : Engine -> ( Engine, Cmd Msg )
checkOrderedEndGame engine =
    case List.head engine.steps of
        Nothing ->
            ( engine
            , send EndGame
            )

        Just step ->
            case step.options of
                [] ->
                    let
                        passedEngine =
                            passStep engine
                    in
                        ( passedEngine
                        , Cmd.none
                        )

                _ ->
                    ( engine
                    , Cmd.none
                    )


selectOrderedOption : Engine -> Option -> Engine
selectOrderedOption engine option =
    case List.head engine.steps of
        Just step ->
            let
                newStep =
                    passOrderedOption option step
            in
                { engine | steps = (List.Extra.setAt 0 newStep engine.steps) }

        Nothing ->
            engine


unselectOrderedOption : Engine -> Option -> Engine
unselectOrderedOption engine option =
    case List.head engine.steps of
        Just step ->
            let
                newStep =
                    undoOrderedOption option step
            in
                { engine | steps = (List.Extra.setAt 0 newStep engine.steps) }

        Nothing ->
            engine


passOrderedOption : Option -> Step -> Step
passOrderedOption option step =
    let
        newOptions =
            List.Extra.remove option step.options
    in
        { step
            | options = newOptions
            , passedOptions = step.passedOptions ++ [ option ]
        }


undoOrderedOption : Option -> Step -> Step
undoOrderedOption option step =
    let
        newOptions =
            List.Extra.remove option step.passedOptions
    in
        { step
            | passedOptions = newOptions
            , options = step.options ++ [ option ]
        }


initSteps : List Step
initSteps =
    [ { title = "Државни хартии од вредност, обврзници и записи директно може да купат:"
      , description = "Изберете опција од понудените"
      , type_ = ChooseOption
      , options =
            [ Option "Банките во РМ" 10.0
            , Option "Правни лица" 3.0
            , Option "Правни и физички лица" 0.0
            ]
      , passedOptions = []
      , points = [ { x = 2015, y = 1000000 }, { x = 2016, y = 4126125 }, { x = 2017, y = 12656234 } ]
      }
    , { title = "Расходи од Функционална Област"
      , description = "Распоредете ги областите според приоритет."
      , type_ = OrderList
      , options =
            [ Option "Пензии, Социјална и Детска Заштита" 1.0
            , Option "Економски Развој и Финансиски Работи" 2.0
            , Option "Здравство" 3.0
            , Option "Образование, Наука и Спорт" 4.0
            , Option "Јавен Ред и Безбедност" 5.0
            , Option "Градежништво, Транспорт, Комуникација и Екологија" 6.0
            , Option "Земјоделство" 7.0
            , Option "Одбрана" 8.0
            , Option "Надворешни Работи и ЕУ Интеграција" 9.0
            , Option "Култура" 10.0
            , Option "Регионален Развој" 11.0
            , Option "Судство" 12.0
            ]
      , passedOptions = []
      , points = []
      }
    , { title = "Државни хартии од вредност, обврзници и записи директно може да купат:"
      , description = "Изберете опција од понудените"
      , type_ = ChooseOption
      , options =
            [ Option "Банките во РМ" 10.0
            , Option "Правни лица" 3.0
            , Option "Правни и физички лица" 0.0
            ]
      , passedOptions = []
      , points = [ { x = 1, y = 10.2 }, { x = 2, y = 27.8 }, { x = 3, y = 12.2 } ]
      }
    , { title = "Расходи од Функционална Област"
      , description = "Распоредете ги областите според приоритет."
      , type_ = OrderList
      , options =
            [ Option "Пензии, Социјална и Детска Заштита" 1.0
            , Option "Економски Развој и Финансиски Работи" 2.0
            , Option "Здравство" 3.0
            , Option "Образование, Наука и Спорт" 4.0
            , Option "Јавен Ред и Безбедност" 5.0
            , Option "Градежништво, Транспорт, Комуникација и Екологија" 6.0
            , Option "Земјоделство" 7.0
            , Option "Одбрана" 8.0
            , Option "Надворешни Работи и ЕУ Интеграција" 9.0
            , Option "Култура" 10.0
            , Option "Регионален Развој" 11.0
            , Option "Судство" 12.0
            ]
      , passedOptions = []
      , points = []
      }
      , { title = "obrazovanie_nauka_i_sport"
      , description = "Изберете опција од понудените за проекција за буџетот за 2019"
      , type_ = ChooseOption
      , options =
            [ Option "17093922000" 10.0
            , Option "100972752000" 3.0
            , Option "26093900" 0.0
            ]
      , passedOptions = []
      , points = [ { x = 2016, y = 9618700 }, { x = 2017, y = 26093922000 }, { x = 2018, y = 100972752000 } ]
      }
    ]
