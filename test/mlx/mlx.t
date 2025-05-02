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
  $ echo '<main className="some" className="another" className="third" />' | fmt --margin=50
  <main
    className="some"
    className="another"
    className="third"
  />

  $ echo '<div className="some" className="another" className="third" ><div className="some" className="another" className="third" /></div>' | fmt --margin=50
  <div
    className="some"
    className="another"
    className="third">
    <div
      className="some"
      className="another"
      className="third"
    />
  </div>

  $ echo '<div><div className="some" className="another" className="third" /></div>' | fmt --margin=50
  <div>
    <div
      className="some"
      className="another"
      className="third"
    />
  </div>

Prop wrapping with comments:
  $ echo '<body><div (* this className is nice *) className="some" className=("another" (* this className is not *)) className="third" /></body>' | fmt --margin=50
  <body>
    <div
      (* this className is nice *)
      className="some"
      className="another"
                (* this className is not *)
      className="third"
    />
  </body>

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
