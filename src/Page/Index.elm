module Page.Index exposing (Data, Model, Msg, page)

import DataSource exposing (DataSource)
import Element exposing (..)
import Element.Border as Border
import Element.Font as Font
import Head
import Head.Seo as Seo
import Html.Attributes exposing (class)
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


type alias Data =
    { profilePictureUri : Pages.Url.Url
    , profilePictureSize : Int
    }


data : DataSource Data
data =
    DataSource.succeed
        { profilePictureUri = "/profile.jpg" |> Path.fromString |> Pages.Url.fromPath
        , profilePictureSize = 200
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


type Social
    = Email
    | GitHub
    | Twitter
    | Instagram


socialLink : Social -> Element msg
socialLink social =
    let
        socialElement =
            case social of
                Instagram ->
                    [ image [ width <| px 20 ]
                        { src = Path.toAbsolute <| Path.fromString "/assets/instagram.svg", description = "Instagram icon" }
                    , newTabLink
                        [ htmlAttribute <| class "underline" ]
                        { url = "https://www.instagram.com/picsbytommi/", label = text "@picsbytommi" }
                    ]

                Email ->
                    [ image [ width <| px 20 ]
                        { src = Path.toAbsolute <| Path.fromString "/assets/email.svg", description = "Email icon" }
                    , newTabLink
                        [ htmlAttribute <| class "underline" ]
                        { url = "mailto:tommaso.bonomo.97@gmail.com", label = text "tommaso.bonomo.97@gmail.com" }
                    ]

                GitHub ->
                    [ image [ width <| px 20 ]
                        { src = Path.toAbsolute <| Path.fromString "/assets/github.png", description = "GitHub icon" }
                    , newTabLink
                        [ htmlAttribute <| class "underline" ]
                        { url = "https://github.com/tommasobonomo", label = text "@tommasobonomo" }
                    ]

                Twitter ->
                    [ image [ width <| px 20 ]
                        { src = Path.toAbsolute <| Path.fromString "/assets/twitter.svg", description = "Twitter icon" }
                    , newTabLink
                        [ htmlAttribute <| class "underline" ]
                        { url = "https://twitter.com/tommybonomo", label = text "@tommybonomo" }
                    ]
    in
    row [ spacing 10, centerY ] socialElement


profilePicture : Pages.Url.Url -> Int -> Element msg
profilePicture url size =
    column
        [ height fill
        , width <| fillPortion 1
        ]
        [ el
            [ width <| px size
            , height <| px size
            , Border.rounded (size // 2)
            , Border.color (rgb255 0 128 128)
            , Border.width 10
            , clip
            ]
          <|
            image
                [ width fill, height fill ]
                { src = url |> Pages.Url.toString
                , description = "Profile picture of Tommaso Bonomo"
                }
        ]


landingText : Element msg
landingText =
    textColumn
        [ height fill
        , width <| fillPortion 5
        , spacing 20
        , Font.family [ Font.serif ]
        ]
        [ paragraph [ Font.size 50 ]
            [ text "Hey!" ]
        , paragraph [] [ text "My name is Tommaso Bonomo, welcome to my website!" ]
        , paragraph [] [ text "Here I want to share a bit of all my passions, such as NLP research blogposts and analog photographs. " ]
        , paragraph []
            [ text "Feel free to reach out at any of my contacts below :) "
            , text "Plain old email is probably the best way for NLP and ML/DL related matters, while my Instagram is the most appropriate contact if you are interested in my photography."
            ]
        , column [ spacing 10 ]
            [ socialLink Email, socialLink Twitter, socialLink GitHub, socialLink Instagram ]
        ]


view :
    Maybe PageUrl
    -> Shared.Model
    -> StaticPayload Data RouteParams
    -> View Msg
view _ _ static =
    { title = "Tommaso Bonomo"
    , body =
        row
            [ width (fill |> maximum 1024)
            , centerX
            , paddingXY 0 200
            , spacing 50
            ]
            [ profilePicture static.data.profilePictureUri static.data.profilePictureSize, landingText ]
    }
