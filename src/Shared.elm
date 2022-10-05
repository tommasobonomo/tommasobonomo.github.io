module Shared exposing (Data, Model, Msg(..), SharedMsg(..), template)

import Browser.Events as Events
import Browser.Navigation
import DataSource
import Element exposing (..)
import Html exposing (Html)
import Json.Decode exposing (decodeValue, field, int, map2)
import Pages.Flags exposing (Flags(..))
import Pages.PageUrl exposing (PageUrl)
import Path exposing (Path)
import Route exposing (Route)
import SharedTemplate exposing (SharedTemplate)
import View exposing (View)


template : SharedTemplate Msg Model Data msg
template =
    { init = init
    , update = update
    , view = view
    , data = data
    , subscriptions = subscriptions
    , onPageChange = Just OnPageChange
    }


type Msg
    = OnPageChange
        { path : Path
        , query : Maybe String
        , fragment : Maybe String
        }
    | SharedMsg SharedMsg
    | SetScreenSize Int Int


type alias Data =
    ()


type SharedMsg
    = NoOp


type alias Model =
    { classifiedDevice : Device }


type alias Viewport =
    { width : Int, height : Int }


viewportDecoder : Json.Decode.Decoder Viewport
viewportDecoder =
    map2 Viewport
        (field "width" int)
        (field "height" int)


init :
    Maybe Browser.Navigation.Key
    -> Pages.Flags.Flags
    ->
        Maybe
            { path :
                { path : Path
                , query : Maybe String
                , fragment : Maybe String
                }
            , metadata : route
            , pageUrl : Maybe PageUrl
            }
    -> ( Model, Cmd Msg )
init _ flags _ =
    let
        defaultModel =
            ( { classifiedDevice = { class = Desktop, orientation = Landscape } }, Cmd.none )
    in
    case flags of
        BrowserFlags value ->
            let
                resultViewport =
                    decodeValue viewportDecoder value
            in
            case resultViewport of
                Ok viewport ->
                    ( { classifiedDevice = classifyDevice { width = viewport.width, height = viewport.height }
                      }
                    , Cmd.none
                    )

                Err _ ->
                    defaultModel

        PreRenderFlags ->
            defaultModel


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnPageChange _ ->
            ( model, Cmd.none )

        SharedMsg _ ->
            ( model, Cmd.none )

        SetScreenSize width height ->
            let
                classifiedDevice =
                    classifyDevice { width = width, height = height }
            in
            ( { model | classifiedDevice = classifiedDevice }, Cmd.none )


subscriptions : Path -> Model -> Sub Msg
subscriptions _ _ =
    Sub.batch [ Events.onResize (\w h -> SetScreenSize w h) ]


data : DataSource.DataSource Data
data =
    DataSource.succeed ()


view :
    Data
    ->
        { path : Path
        , route : Maybe Route
        }
    -> Model
    -> (Msg -> msg)
    -> View msg
    -> { body : Html msg, title : String }
view _ _ _ _ pageView =
    { body =
        layout [] <|
            pageView.body
    , title = pageView.title
    }
