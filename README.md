# purescript-webapp

A simple PureScript application framework built from [Smolder](https://pursuit.purescript.org/packages/purescript-smolder/), [VDOM](https://pursuit.purescript.org/packages/purescript-vdom/) and [Store](https://pursuit.purescript.org/packages/purescript-store/).

## Usage

The `Web.App.app` function takes an initial application state, an update function and a render function, and assembles them into a web app.

```purescript
app :: ∀ e action state.
  (Generic action, Generic state) ⇒
    state →
    (action → state → state) →
    ((action → EffWeb e Unit) → state →
      Markup (Event → EffWeb e Unit)) →
    Node →
    EffWeb e (Store ( … | e) action state)
```

## Licence

Copyright 2016 Bodil Stokke

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Lesser General Public License as
published by the Free Software Foundation, either version 3 of the
License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but
WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this program. If not, see
<http://www.gnu.org/licenses/>.
