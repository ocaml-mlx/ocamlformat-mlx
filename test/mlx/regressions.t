Setup:
  $ alias fmt="ocamlformat-mlx - --impl --enable-outside-detected-project"

Ordinary override expressions parse and format without special parentheses:

  $ echo 'let _ = {<x = true && false>}' | fmt
  let _ = {<x = true && false>}
  $ echo 'let _ = {<x = (true && false)>}' | fmt | fmt
  let _ = {<x = true && false>}
  $ echo 'let _ = {<x = if true then 1 else 2>}' | fmt
  let _ = {<x = if true then 1 else 2>}
  $ echo 'let _ = {<x = (if true then 1 else 2)>}' | fmt | fmt
  let _ = {<x = if true then 1 else 2>}
  $ echo 'let _ = {<x = let a = 1 in a > 2>}' | fmt
  let _ =
    {<x = let a = 1 in
          a > 2>}
  $ echo 'let _ = {<x = 1 > 2 && true; y = false || 3 > 4>}' | fmt | fmt
  let _ = {<x = 1 > 2 && true; y = false || 3 > 4>}
  $ echo 'let _ = {<x = fun a -> a > 2>}' | fmt
  let _ = {<x = fun a -> a > 2>}
  $ echo 'let _ = {<x = match a with Some x -> x > 2 | None -> false>}' | fmt
  let _ = {<x = match a with Some x -> x > 2 | None -> false>}
  $ echo 'let _ = {<x = try f () > 2 with _ -> false>}' | fmt
  let _ = {<x = try f () > 2 with _ -> false>}

Empty/local overrides and whitespace before the brace remain supported:

  $ echo 'let _ = {<>} let _ = M.{<x = 1 > 2>}' | fmt
  let _ = {<>}
  let _ = M.({<x = 1 > 2>})
  $ printf 'let _ = {<x = true && false>\n}\n' | fmt
  let _ = {<x = true && false>}
  $ echo 'let _ = {x = {<y = true && false>}}' | fmt
  let _ = { x = {<y = true && false>} }

JSX and object types still close directly before braces:

  $ echo 'let _ = {x = <div>...xs</div>}' | fmt | fmt
  let _ = { x = <div>...xs</div> }
  $ echo 'type t = {x : <m : int>}' | fmt | fmt
  type t = { x : < m : int > }

Comments on the unit argument must not disappear when sugaring an application into JSX:

  $ echo 'let _ = (App.createElement ~children:xs (* keep *) ()) [@JSX]' | fmt | fmt
  let _ = App.createElement ~children:xs (* keep *) () [@JSX]
  $ echo 'let _ = (App.createElement ~children:xs ((* keep *))) [@JSX]' | fmt | fmt
  let _ = App.createElement ~children:xs ( (* keep *) ) [@JSX]
  $ echo 'let _ = (App.createElement ~children:xs () (* keep *)) [@JSX]' | fmt | fmt
  let _ = (* keep *) <App>...xs</App>
  $ echo 'let _ = (App.createElement ((* keep *)) ~children:xs) [@JSX]' | fmt | fmt
  let _ = App.createElement ( (* keep *) ) ~children:xs [@JSX]
  $ echo 'let _ = (App.createElement ~children:[] (* keep *) ()) [@JSX]' | fmt | fmt
  let _ = App.createElement ~children:[] (* keep *) () [@JSX]

Uncommented applications still normalize to a children spread:

  $ echo 'let _ = (App.createElement ~children:xs ()) [@JSX]' | fmt | fmt
  let _ = <App>...xs</App>

Applications retained for their comments need parentheses inside JSX as well:

  $ echo 'let _ = <div>((App.createElement ~children:xs (* keep *) ()) [@JSX])</div>' | fmt | fmt
  let _ = <div>(App.createElement ~children:xs (* keep *) () [@JSX])</div>
  $ echo 'let _ = <div>...((App.createElement ~children:xs (* keep *) ()) [@JSX])</div>' | fmt | fmt
  let _ = <div>...(App.createElement ~children:xs (* keep *) () [@JSX])</div>
  $ echo 'let _ = <div prop=((App.createElement ~children:xs (* keep *) ()) [@JSX]) />' | fmt | fmt
  let _ = <div prop=(App.createElement ~children:xs (* keep *) () [@JSX]) />
