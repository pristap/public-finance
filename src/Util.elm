module Util exposing (..)

import Task exposing (..)


send : msg -> Cmd msg
send msg =
    Task.succeed msg
        |> Task.perform identity
