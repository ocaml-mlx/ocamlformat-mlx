Setup:
  $ alias fmt="ocamlformat-mlx - --impl --enable-outside-detected-project"

Basics:
  $ echo '<div />' | fmt
  <div />

  $ echo '<div className="some" />' | fmt
  <div className="some" />

  $ echo '<div>child</div>' | fmt
  <div>child</div>

  $ echo '<div>child1 child2</div>' | fmt
  <div>child1 child2</div>

Prop wrapping:
  $ echo '<div className="some" className="another" className="third" />' | fmt --margin=50
  <div className="some"
       className="another"
       className="third" />

Prop punning:
  $ echo '<div className />' | fmt --margin=50
  <div className />

  $ echo '<div className=className />' | fmt --margin=50
  <div className />

Optional props:
  $ echo '<div ?className />' | fmt --margin=50
  <div ?className />

  $ echo '<div ?className=className />' | fmt --margin=50
  <div ?className />

Children wrapping:
  $ echo '<div><div className="some" className="another" />some child</div>' | fmt --margin=50
  <div>
    <div className="some" className="another" />
    some
    child
  </div>

Children wrapping:
  $ echo '<div><div className="some" className="another" />some child</div>' | fmt --margin=60
  <div>
    <div className="some" className="another" /> some child
  </div>

Uident:
  $ echo '<App />' | fmt
  <App />

Uident:
  $ echo '<App.component />' | fmt
  <App.component />

Modident:
  $ echo '<App.Component />' | fmt
  <App.Component />

Comments:
  $ echo '<div> a  (* 1 *)  </div>' | fmt
  <div>a (* 1 *)</div>
  $ echo '<div> (* 1 *) b </div>' | fmt
  <div>(* 1 *) b</div>
  $ echo '<div> a (* 1 *)  b </div>' | fmt
  <div>a (* 1 *) b</div>

Comments TODO:
  $ echo '<div> (* 1 *)   </div>' | fmt
  ocamlformat-mlx: Cannot process "<standard input>".
    Please report this bug at https://github.com/ocaml-ppx/ocamlformat/issues.
    BUG: comment changed.
  File "<standard input>", line 1, characters 6-13:
  Error: comment (*  1  *) dropped.
  [1]
  $ echo '<div (* 1 *) />' | fmt
  ocamlformat-mlx: Cannot process "<standard input>".
    Please report this bug at https://github.com/ocaml-ppx/ocamlformat/issues.
    BUG: comment changed.
  File "<standard input>", line 1, characters 5-12:
  Error: comment (*  1  *) dropped.
  [1]
  $ echo '<div a=1 (* 1 *) b=2 />' | fmt
  <div a=1 (* 1 *) b=2 />
  $ echo '<div a=(* 1 *)1 />' | fmt
  <div a=(* 1 *) 1 />
  $ echo '<div a(* 1 *)=1 />' | fmt
  <div a=(* 1 *) 1 />
  $ echo '<div (* 1 *)a=1 />' | fmt
  ocamlformat-mlx: Cannot process "<standard input>".
    Please report this bug at https://github.com/ocaml-ppx/ocamlformat/issues.
    BUG: comment changed.
  File "<standard input>", line 1, characters 5-12:
  Error: comment (*  1  *) dropped.
  [1]
  $ echo '<div a=1 (* 1 *) />' | fmt
  <div a=1 (* 1 *) />

