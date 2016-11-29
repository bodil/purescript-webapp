module Web.App where

import Prelude
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Exception (EXCEPTION, error, throwException)
import Control.Monad.Eff.Timer (TIMER)
import DOM (DOM)
import DOM.Event.Types (Event)
import DOM.HTML (window)
import DOM.HTML.Types (htmlDocumentToParentNode)
import DOM.HTML.Window (document)
import DOM.Node.ParentNode (querySelector)
import DOM.Node.Types (Node, elementToNode)
import Data.Generic (class Generic)
import Data.Maybe (Maybe(Nothing, Just))
import Data.Nullable (toMaybe)
import Data.Store (createStore, Store)
import Data.Tuple (Tuple(Tuple))
import Data.VirtualDOM (patch)
import Data.VirtualDOM.DOM (api)
import Signal (runSignal, foldp, sampleOn)
import Signal.Channel (CHANNEL, subscribe, send, channel)
import Signal.DOM (animationFrame)
import Text.Smolder.Markup (Markup)
import Text.Smolder.Renderer.VDOM (render)
import Web.App.Types (EffWeb)

into :: ∀ e. String → Eff (err :: EXCEPTION, dom :: DOM | e) Node
into selector = do
  doc ← window >>= document >>= htmlDocumentToParentNode >>> pure
  elem ← toMaybe <$> querySelector "#content" doc
  case elem of
    Just elem' → pure (elementToNode elem')
    Nothing → throwException (error ("Web.App.into: No element matching " <> show selector))

app :: ∀ e s a. (Generic a, Generic s) ⇒ s → (a → s → s) → ((a → EffWeb e Unit) → s → Markup (Event → EffWeb e Unit)) → Node → EffWeb e (Store (channel :: CHANNEL, dom :: DOM, timer :: TIMER | e) a s)
app seed update view target = do
  tick ← animationFrame
  output ← channel seed
  store ← createStore update seed
  store.subscribe (send output)
  let tickedOutput = sampleOn tick (subscribe output)
      go state (Tuple _ prev) = Tuple prev (render $ view store.dispatch state)
      vdomStream = foldp go (Tuple Nothing Nothing) tickedOutput
      write (Tuple prev next) = patch api target prev next
  runSignal $ (write <$> vdomStream)
  pure store
