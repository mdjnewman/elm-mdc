module Material
    exposing
        ( Model
        , defaultModel
        , Msg
        , update
        , subscriptions
        , init
        , top
        )

import Dict
import Html.Attributes as Html
import Html exposing (Html, text)
import Material.Component as Component exposing (Indexed)
import Material.Helpers exposing (map1st)
import Material.Msg exposing (Msg(..))

import Material.Button as Button
import Material.Checkbox as Checkbox
import Material.Dispatch as Dispatch
import Material.Drawer as Drawer
import Material.Fab as Fab
import Material.GridList as GridList
import Material.IconToggle as IconToggle
import Material.Menu as Menu
import Material.RadioButton as RadioButton
import Material.Ripple as Ripple
import Material.Select as Select
import Material.Slider as Slider
import Material.Snackbar as Snackbar
import Material.Switch as Switch
import Material.Tabs as Tabs
import Material.Textfield as Textfield
import Material.Toolbar as Toolbar


type alias Model = 
    { button : Indexed Button.Model
    , checkbox : Indexed Checkbox.Model
    , drawer : Indexed Drawer.Model
    , fab : Indexed Fab.Model
    , gridList : Indexed GridList.Model
    , iconToggle : Indexed IconToggle.Model
    , menu : Indexed Menu.Model
    , radio : Indexed RadioButton.Model
    , ripple : Indexed Ripple.Model
    , select : Indexed Select.Model
    , slider : Indexed Slider.Model
    , snackbar : Indexed Snackbar.Model
    , switch : Indexed Switch.Model
    , tabs : Indexed Tabs.Model
    , textfield : Indexed Textfield.Model
    , toolbar : Indexed Toolbar.Model
    }


defaultModel : Model
defaultModel = 
    { button = Dict.empty
    , checkbox = Dict.empty
    , drawer = Dict.empty
    , fab = Dict.empty
    , gridList = Dict.empty
    , iconToggle = Dict.empty
    , menu = Dict.empty
    , radio = Dict.empty
    , ripple = Dict.empty
    , select = Dict.empty
    , slider = Dict.empty
    , snackbar = Dict.empty
    , switch = Dict.empty
    , tabs = Dict.empty
    , textfield = Dict.empty
    , toolbar = Dict.empty
    }


type alias Msg m =
    Material.Msg.Msg m


update : (Msg m -> m) -> Msg m -> { c | mdl : Model } -> (  { c | mdl : Model }, Cmd m )
update lift msg container =
  update_ lift msg (.mdl container)
      |> map1st (Maybe.map (\mdl -> { container | mdl = mdl }))
      |> map1st (Maybe.withDefault container)


update_ : (Msg m -> m) -> Msg m -> Model -> ( Maybe Model, Cmd m )
update_ lift msg store =
    -- TODO: Make all components use react
    -- TODO: Make component Msgs uniform
    case msg of
        Dispatch msgs -> 
            (Nothing, Dispatch.forward msgs)

        ButtonMsg idx msg ->
            Button.react lift msg idx store

        CheckboxMsg idx msg ->
            Checkbox.react lift msg idx store

        DrawerMsg idx msg ->
            Drawer.react lift msg idx store

        FabMsg idx msg ->
            Fab.react lift msg idx store

        GridListMsg idx msg ->
            GridList.react lift msg idx store

        IconToggleMsg idx msg ->
            IconToggle.react lift msg idx store

        MenuMsg idx msg ->
            Menu.react (MenuMsg idx >> lift) msg idx store

        RadioButtonMsg idx msg ->
            RadioButton.react lift msg idx store

        RippleMsg idx msg ->
            Ripple.react lift msg idx store

        SelectMsg idx msg ->
            Select.react (SelectMsg idx >> lift) msg idx store

        SliderMsg idx msg ->
            Slider.react (SliderMsg idx >> lift) msg idx store

        SnackbarMsg idx msg ->
            Snackbar.react (SnackbarMsg idx >> lift) msg idx store

        SwitchMsg idx msg ->
            Switch.react lift msg idx store

        TabsMsg idx msg ->
            Tabs.react (TabsMsg idx >> lift) msg idx store

        TextfieldMsg idx msg ->
            Textfield.react lift msg idx store

        ToolbarMsg idx msg ->
            Toolbar.react lift msg idx store


subscriptions : (Msg m -> m) -> { model | mdl : Model } -> Sub m
subscriptions lift model =
    Sub.batch
        [ Drawer.subs lift model.mdl
        , Menu.subs lift model.mdl
        , Select.subs lift model.mdl
        ]


init : (Msg m -> m) -> Cmd m
init lift =
    Cmd.none
    -- TODO: Layout init, etc.

--    Task.perform (\_ -> lift (Scroll { pageX = 0, pageY = 0 })) <|
--    Dom.onDocument
--      "scroll"
--      ( Json.map (Scroll >> lift) <|
--        Json.map2 (\pageX pageY -> { pageX = pageX, pageY = pageY })
--          ( Json.at [ "pageX" ] Json.int )
--          ( Json.at [ "pageY" ] Json.int )
--      )
--      ( \_ -> Task.succeed () )


-- TODO:

top : Html a -> Html a
top content =
    Html.div []
    [
      content

    , Html.node "style"
      [ Html.type_ "text/css"
      ]
      [ [ "https://fonts.googleapis.com/css?family=Roboto+Mono"
        , "https://fonts.googleapis.com/icon?family=Material+Icons"
        , "https://fonts.googleapis.com/css?family=Roboto:300,400,500"
        , "https://aforemny.github.io/elm-mdc/material-components-web.css"
        , "https://aforemny.github.io/elm-mdc/assets/dialog/dialog-polyfill.css"
        ]
        |> List.map (\url ->
               "@import url(" ++ url ++ ");"
           )
        |> String.join "\n"
        |> text
      ]

    , Html.node "script"
      [ Html.type_ "text/javascript"
      , Html.src "https://aforemny.github.io/elm-mdc/assets/dialog/dialog-polyfill.js"
      ]
      []
    ]
