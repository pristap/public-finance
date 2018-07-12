module Types exposing (..)

import Dict exposing (..)


type Msg
    = Noop
    | SelectOrderedOption Option
    | UndoOrderedOption Option
    | SelectChooseOption
    | EndGame


type StepType
    = OrderList
    | ChooseOption


type alias Option =
    { key : String
    , value : Float
    }


type alias Point =
    { x : Float
    , y : Float
    }


type alias LanguageData =
    { mk : Dict String String, en : Dict String String, al : Dict String String }


type alias Step =
    { title : String
    , description : String
    , type_ : StepType
    , options : List Option
    , passedOptions : List Option
    , points : List Point
    }
