module Test.Main where

import Control.Monad.Eff.Exception (EXCEPTION)
import DOM.Event.Types (Event)
import Data.Generic (class Generic)
import Text.Smolder.HTML (button, h1, div)
import Text.Smolder.HTML.Attributes (style)
import Text.Smolder.Markup (Markup, (!), (#!), text, on)
import Web.App (into, app)
import Web.App.Types (EffWeb)
import Prelude hiding (div)

type State = Int

initialState :: State
initialState = 0

data Action = Pred | Succ
derive instance genericAction :: Generic Action

nat :: Int → String
nat 0 = "Z"
nat n = "S " <> nat (n - 1)

view :: forall e. (Action → EffWeb e Unit) -> State -> Markup (Event -> EffWeb e Unit)
view dispatch state = div do
  h1 ! style ("color: rgb(" <> show (min (state * 8) 256) <> ",0,0)") $ text ("Number " <> nat state)
  button #! on "click" (\_ → dispatch Pred) $ text "pred"
  button #! on "click" (\_ → dispatch Succ) $ text "succ"

update :: Action → State → State
update action state = case action of
  Pred → max (state - 1) 0
  Succ → state + 1

main :: ∀ e. EffWeb (err :: EXCEPTION | e) Unit
main =
  void $ into "#content" >>= app initialState update view
