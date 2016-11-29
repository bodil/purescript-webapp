module Web.App.Types where

import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Timer (TIMER)
import DOM (DOM)
import Data.Store (STORE)
import Signal.Channel (CHANNEL)

type EffWeb e a = Eff (channel :: CHANNEL, store :: STORE, dom :: DOM, timer :: TIMER | e) a
