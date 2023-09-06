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

Props expressions:
  $ echo '<div className=1 />' | fmt --margin=50
  <div className=1 />
  $ echo '<div className=(not x) />' | fmt --margin=50
  <div className=(not x) />
  $ echo '<div className=(1+1) />' | fmt --margin=50
  <div className=(1 + 1) />
  $ echo '<div className=!a />' | fmt --margin=50
  <div className=!a />

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
  $ echo '<App> a  (* 1 *)  </App>' | fmt
  <App>a (* 1 *)</App>
  $ echo '<App.name> a  (* 1 *)  </App.name>' | fmt
  <App.name>a (* 1 *)</App.name>

  $ echo '<div>  (* 1 *) b </div>' | fmt
  <div>(* 1 *) b</div>
  $ echo '<App>  (* 1 *) b </App>' | fmt
  <App>(* 1 *) b</App>
  $ echo '<App.name>  (* 1 *) b </App.name>' | fmt
  <App.name>(* 1 *) b</App.name>

  $ echo '<div> a (* 1 *)  b </div>' | fmt
  <div>a (* 1 *) b</div>
  $ echo '<App> a (* 1 *)  b </App>' | fmt
  <App>a (* 1 *) b</App>
  $ echo '<App.name> a (* 1 *)  b </App.name>' | fmt
  <App.name>a (* 1 *) b</App.name>

  $ echo '<div> (* 1 *)   </div>' | fmt
  <div> (* 1 *)</div>
  $ echo '<App> (* 1 *)   </App>' | fmt
  <App> (* 1 *)</App>
  $ echo '<App.name> (* 1 *)   </App.name>' | fmt
  <App.name> (* 1 *)</App.name>

  $ echo '<div a=1 (* 1 *) b=2 />' | fmt
  <div a=1 (* 1 *) b=2 />
  $ echo '<div a=(* 1 *)1 />' | fmt
  <div a=(* 1 *) 1 />
  $ echo '<div a(* 1 *)=1 />' | fmt
  <div a=(* 1 *) 1 />
  $ echo '<div a=1 (* 1 *) />' | fmt
  <div a=1 (* 1 *) />

  $ echo '<div (* 1 *)a=1 />' | fmt
  <div (* 1 *) a=1 />
  $ echo '<App (* 1 *)a=1 />' | fmt
  <App (* 1 *) a=1 />
  $ echo '<App.name (* 1 *)a=1 />' | fmt
  <App.name (* 1 *) a=1 />

  $ echo '<div (* 1 *) />' | fmt
  <div (* 1 *) />
  $ echo '<App (* 1 *) />' | fmt
  <App (* 1 *) />
  $ echo '<App.name (* 1 *) />' | fmt
  <App.name (* 1 *) />
