module Page.Index exposing (Data, Model, Msg, page)

import DataSource exposing (DataSource)
import Element exposing (..)
import Element.Border as Border
import Element.Font as Font
import Head
import Head.Seo as Seo
import Html.Attributes exposing (class, style)
import Page exposing (Page, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
import Pages.Url
import Path
import Shared
import View exposing (View)


type alias Model =
    ()


type alias Msg =
    Never


type alias RouteParams =
    {}


page : Page RouteParams Data
page =
    Page.single
        { head = head
        , data = data
        }
        |> Page.buildNoState { view = view }


type alias Social =
    { iconPath : String
    , altDescription : String
    , url : String
    , label : String
    }


type alias Data =
    { profilePictureUri : Pages.Url.Url
    , profilePictureSize : Int
    , email : Social
    , github : Social
    , twitter : Social
    , instagram : Social
    , mastodon : Social
    }


data : DataSource Data
data =
    DataSource.succeed
        { profilePictureUri = "/profile.jpg" |> Path.fromString |> Pages.Url.fromPath
        , profilePictureSize = 200
        , email =
            Social
                (Path.toAbsolute <| Path.fromString "/assets/email.svg")
                "Email icon"
                "mailto:bonomo@diag.uniroma1.it"
                "bonomo@diag.uniroma1.it"
        , github =
            Social
                (Path.toAbsolute <| Path.fromString "/assets/github.png")
                "GitHub icon"
                "https://github.com/tommasobonomo"
                "@tommasobonomo"
        , twitter =
            Social
                (Path.toAbsolute <| Path.fromString "/assets/twitter.svg")
                "Twitter icon"
                "https://twitter.com/tommybonomo"
                "@tommybonomo"
        , instagram =
            Social
                (Path.toAbsolute <| Path.fromString "/assets/instagram.svg")
                "Instagram icon"
                "https://www.instagram.com/picsbytommi/"
                "@picsbytommi"
        , mastodon =
            Social
                (Path.toAbsolute <| Path.fromString "/assets/mastodon.svg")
                "Mastodon icon"
                "https://sigmoid.social/@tommasobonomo"
                "@tommasobonomo@sigmoid.social"
        }


head :
    StaticPayload Data RouteParams
    -> List Head.Tag
head static =
    Seo.summary
        { canonicalUrlOverride = Nothing
        , siteName = "Tommaso Bonomo"
        , image =
            { url = static.data.profilePictureUri
            , alt = "Tommaso Bonomo's logo"
            , dimensions = Just { width = static.data.profilePictureSize, height = static.data.profilePictureSize }
            , mimeType = Just "image/jpeg"
            }
        , description = "Personal website of Tommaso Bonomo"
        , locale = Nothing
        , title = "Tommaso Bonomo"
        }
        |> Seo.website


underlineAttribute : DeviceClass -> Attribute msg
underlineAttribute deviceClass =
    case deviceClass of
        Phone ->
            htmlAttribute <| style "text-decoration" "underline teal solid 3px"

        Tablet ->
            htmlAttribute <| style "text-decoration" "underline teal solid 3px"

        Desktop ->
            htmlAttribute <| class "underline"

        BigDesktop ->
            htmlAttribute <| class "underline"


socialLink : Social -> DeviceClass -> Element msg
socialLink social deviceClass =
    row [ spacing 10, centerY ]
        [ image [ width <| px 20 ]
            { src = social.iconPath, description = social.altDescription }
        , newTabLink [ underlineAttribute <| deviceClass ] { url = social.url, label = text social.label }
        ]


setWidth : Bool -> Bool -> Attribute msg
setWidth isVertical isPanel =
    if isVertical == True then
        if isPanel == True then
            width <| fillPortion 1

        else
            width <| fillPortion 5

    else
        width fill


profilePicture : Data -> Bool -> Element msg
profilePicture dataRecord isVertical =
    column
        [ height fill
        , setWidth isVertical True
        ]
        [ el
            [ width <| px dataRecord.profilePictureSize
            , height <| px dataRecord.profilePictureSize
            , Border.rounded (dataRecord.profilePictureSize // 2)
            , Border.color (rgb255 0 128 128)
            , Border.width 10
            , clip
            ]
          <|
            image
                [ width fill, height fill ]
                { src = dataRecord.profilePictureUri |> Pages.Url.toString
                , description = "Profile picture of Tommaso Bonomo"
                }
        ]


landingText : Data -> Bool -> Device -> Element msg
landingText dataRecord isVertical device =
    textColumn
        [ height fill
        , setWidth isVertical False
        , spacing 20
        , Font.family [ Font.serif ]
        ]
        [ paragraph [ Font.size 50 ]
            [ text "Hey!" ]
        , paragraph [] [ text "My name is Tommaso Bonomo, welcome to my (very work-in-progress) website!" ]
        , paragraph []
            [ text "I am a PhD student at "
            , newTabLink [ underlineAttribute <| device.class ] { url = "https://nlp.uniroma1.it/", label = text "SapienzaNLP" }
            , text ", starting from 1st November 2022."
            ]
        , paragraph [] [ text "Here I want to share a bit of all my passions, such as NLP research blogposts and analog photographs. " ]
        , paragraph []
            [ text "Feel free to reach out through any of my contacts below :) "
            , text "Plain old email is probably the best way for NLP and ML/DL related matters, while my Instagram is the most appropriate contact if you are interested in my photography."
            ]
        , column [ spacing 10 ]
            [ socialLink dataRecord.email device.class
            , socialLink dataRecord.twitter device.class
            , socialLink dataRecord.mastodon device.class
            , socialLink dataRecord.github device.class
            , socialLink dataRecord.instagram device.class
            ]
        ]


view :
    Maybe PageUrl
    -> Shared.Model
    -> StaticPayload Data RouteParams
    -> View Msg
view _ sharedModel static =
    { title = "Tommaso Bonomo"
    , body =
        let
            wideView =
                row
                    [ width (fill |> maximum 1024)
                    , centerX
                    , paddingXY 0 200
                    , spacing 50
                    ]
                    [ profilePicture static.data False
                    , landingText static.data True sharedModel.classifiedDevice
                    ]

            narrowView =
                column [ spacing 20, paddingXY 10 50 ]
                    [ el [ centerX ] <| profilePicture static.data True
                    , el [ centerX ] <| landingText static.data False sharedModel.classifiedDevice
                    ]
        in
        case sharedModel.classifiedDevice.class of
            BigDesktop ->
                wideView

            Desktop ->
                wideView

            Tablet ->
                case sharedModel.classifiedDevice.orientation of
                    Portrait ->
                        narrowView

                    Landscape ->
                        wideView

            Phone ->
                case sharedModel.classifiedDevice.orientation of
                    Portrait ->
                        narrowView

                    Landscape ->
                        wideView
    }
