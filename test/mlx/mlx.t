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

Prop punning:
  $ echo '<div className />' | fmt --margin=50
  <div className />

  $ echo '<div className=className />' | fmt --margin=50
  <div className />

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

  $ echo '<div> <a /> (* 1 *) <b /> </div>' | fmt
  <div><a /> (* 1 *) <b /></div>
  $ echo '<div>  (* 1 *) <b /> </div>' | fmt
  <div>(* 1 *) <b /></div>
  $ echo '<div> <a /> (* 1 *)  </div>' | fmt
  <div><a /> (* 1 *)</div>
  $ echo '<div>  (* 1 *)  </div>' | fmt
  <div> (* 1 *)</div>

  $ echo '((* before a parenthesised JSX child *) <form/>)' | fmt
  (* before a parenthesised JSX child *) <form />
  $ echo '(<form/> (* after a parenthesised JSX child *))' | fmt
  <form /> (* after a parenthesised JSX child *)
  $ echo '(if cond then (* before a JSX branch *) <form/> else JSX.null)' | fmt
  if cond then (* before a JSX branch *) <form /> else JSX.null
  $ echo 'if cond then (* before a JSX branch *) <form/> else JSX.null' | fmt
  if cond then (* before a JSX branch *) <form /> else JSX.null

Test for a lexer hack:
  $ echo '[<element />; <element />]' | fmt
  [ <element />; <element /> ]
  $ echo '[<M.element />; <M.element />]' | fmt
  [ <M.element />; <M.element /> ]
  $ echo '[<element> 1 </element>]' | fmt
  [ <element>1</element> ]
  $ echo '[<M.element> 1 </M.element>]' | fmt
  [ <M.element>1</M.element> ]

JSX elements as props:
  $ echo 'let _ = <div element=(<span />) />' | fmt
  let _ = <div element=(<span />) />
  $ echo 'let _ = <div element=(<Componient />) />' | fmt
  let _ = <div element=(<Componient />) />
  $ echo 'let _ = <Big element=(<Component />) />' | fmt
  let _ = <Big element=(<Component />) />

  $ echo 'let _ = <Big>(<Component />)</Big>' | fmt
  let _ = <Big><Component /></Big>

  $ echo 'let _ = <Big>(React.string children)</Big>' | fmt
  let _ = <Big>(React.string children)</Big>

  $ echo 'let _ = <Big>(match x with | A -> "33" | B -> "44")</Big>' | fmt
  let _ = <Big>(match x with A -> "33" | B -> "44")</Big>

JSX in tuples:
  $ echo 'let _ = (<div />, <span />)' | fmt
  let _ = (<div />, <span />)
  $ echo 'let _ = (1, <span />, "text")' | fmt
  let _ = (1, <span />, "text")
  $ echo 'let _ = (<div>content</div>, foo)' | fmt
  let _ = (<div>content</div>, foo)

JSX in records:
  $ echo 'let _ = { element = <div /> }' | fmt
  let _ = { element = <div /> }
  $ echo 'let _ = { element = <Component /> }' | fmt
  let _ = { element = <Component /> }
  $ echo 'let _ = { foo = 1; element = <div />; bar = 2 }' | fmt
  let _ = { foo = 1; element = <div />; bar = 2 }

JSX in options/variants:
  $ echo 'let _ = Some <div />' | fmt
  let _ = Some <div />
  $ echo 'let _ = Some (<div />)' | fmt
  let _ = Some <div />
  $ echo 'let _ = Ok <Component />' | fmt
  let _ = Ok <Component />
  $ echo 'let _ = Woo <Component />, 3' | fmt
  let _ = (Woo <Component />, 3)

JSX in function calls:
  $ echo 'let _ = render <div />' | fmt
  let _ = render <div />
  $ echo 'let _ = render (<div />)' | fmt
  let _ = render <div />
  $ echo 'let _ = foo <div /> <span />' | fmt
  let _ = foo <div /> <span />
  $ echo 'let _ = ReactDOM.render <div /> container' | fmt
  let _ = ReactDOM.render <div /> container

JSX in arrays:
  $ echo 'let _ = [|<div />; <span />|]' | fmt
  let _ = [| <div />; <span /> |]
  $ echo 'let _ = [|<Component />|]' | fmt
  let _ = [| <Component /> |]

JSX in let bindings:
  $ echo 'let x = <div />' | fmt
  let x = <div />
  $ echo 'let x = <Component />' | fmt
  let x = <Component />
  $ echo 'let x = <div>content</div>' | fmt
  let x = <div>content</div>

JSX in pattern matching:
  $ echo 'match x with | A -> <div /> | B -> <span />' | fmt
  match x with A -> <div /> | B -> <span />
  $ echo 'match x with | Some y -> <div>y</div> | None -> <span />' | fmt
  match x with Some y -> <div>y</div> | None -> <span />

JSX in if expressions:
  $ echo 'if x then <div /> else <span />' | fmt
  if x then <div /> else <span />
  $ echo 'let _ = if cond then <Component /> else <Other />' | fmt
  let _ = if cond then <Component /> else <Other />

JSX in sequences:
  $ echo 'let _ = (<div />; <span />)' | fmt
  let _ =
    <div />;
    <span />
  $ echo '<div />; <span />' | fmt
  <div />;
  <span />

JSX with infix operators:
  $ echo 'let _ = x |> render <div />' | fmt
  let _ = x |> render <div />
  $ echo 'let _ = <div /> :: <span /> :: []' | fmt
  let _ = [ <div />; <span /> ]
  $ echo 'let _ = [<div />; <span />]' | fmt
  let _ = [ <div />; <span /> ]

  $ echo 'let _ = <Big>(<Lola />)</Big>' | fmt
  let _ = <Big><Lola /></Big>

JSX element closed directly before "|]" inside an array literal, and
before "}" inside a record/braced expression (regression test for the
lexer treating ">|]" as the ">|" operator followed by "]", and ">}" as a
single GREATERRBRACE token, instead of giving the ">" back to close the
JSX tag):
  $ echo 'let _ = [|<div>aa</div>|]' | fmt
  let _ = [| <div>aa</div> |]
  $ echo 'let _ = [|<div>aa</div>; <div>bb</div>|]' | fmt
  let _ = [| <div>aa</div>; <div>bb</div> |]
  $ echo 'let _ = [<div>aa</div>]' | fmt
  let _ = [ <div>aa</div> ]

  $ echo 'let _ = {x = <div>a</div>}' | fmt
  let _ = { x = <div>a</div> }
  $ echo 'let _ = {x = <div>a</div>; y = 1}' | fmt
  let _ = { x = <div>a</div>; y = 1 }
  $ echo 'let r = {r with x = <div>a</div>}' | fmt
  let r = { r with x = <div>a</div> }

Object override still parses and formats stably, both spaced and unspaced,
since the grammar now closes `{< ... >}` with two tokens (GREATER RBRACE)
instead of the single GREATERRBRACE token:
  $ echo 'let _ = object val x = 1 method m = {< x = 2 >} end' | fmt
  let _ =
    object
      val x = 1
      method m = {<x = 2>}
    end
  $ echo 'let _ = object val x = 1 method m = {<x = 2>} end' | fmt
  let _ =
    object
      val x = 1
      method m = {<x = 2>}
    end

Splitting ">}" into GREATER RBRACE means the final GREATER of an override
field ending in an unparenthesized comparison is grammatically
indistinguishable from a continued infix ">", both right before the closer
and elsewhere in the field list; the printer keeps such fields parenthesized
so the output still re-parses:
  $ echo 'let _ = object val x = true method m = {< x = (1 > 2) >} end' | fmt
  let _ =
    object
      val x = true
      method m = {<x = (1 > 2)>}
    end
  $ echo 'let _ = object val x = true val y = 1 method m = {< x = (1 > 2); y = 5 >} end' | fmt
  let _ =
    object
      val x = true
      val y = 1
      method m = {<x = (1 > 2); y = 5>}
    end

Operator sanity: only the exact sequences ">|]" and ">}" are special-cased,
so ">|" still lexes as an ordinary operator everywhere else, including
right before a closing "|]" that isn't immediately preceded by ">":
  $ echo 'let (>|) a b = a
  > let _ = 1>|2' | fmt
  let ( >| ) a b = a
  let _ = 1 >| 2
  $ echo 'let (>|) a b = a
  > let _ = [|1>|2|]' | fmt
  let ( >| ) a b = a
  let _ = [| 1 >| 2 |]

Raw identifiers in JSX:
  $ echo 'let _ = <\#lazy />' | fmt
  let _ = <\#lazy />
  $ echo 'let _ = <\#lazy>child</\#lazy>' | fmt
  let _ = <\#lazy>child</\#lazy>
  $ echo 'let _ = <element loading=`\#lazy />' | fmt
  let _ = <element loading=`\#lazy />
  $ echo 'let _ = <\#foo />' | fmt
  let _ = <\#foo />

Hand-written [@JSX] applications are canonicalized to JSX syntax when
expressible (ocaml-mlx/ocamlformat-mlx#12):
  $ echo 'let _ = ReactDOM.Client.render root ((App.createElement ~children:[] ()) [@JSX ])' | fmt
  let _ = ReactDOM.Client.render root <App />
  $ echo 'let _ = ((App.createElement ~children:[x; y] ()) [@JSX])' | fmt
  let _ = <App>x y</App>
  $ echo 'let _ = ((App.createElement ~children:[] ~foo:1 ?bar ()) [@JSX])' | fmt
  let _ = <App foo=1 ?bar />
  $ echo 'let _ = ((div ~children:[] ()) [@JSX])' | fmt
  let _ = <div />
  $ echo 'let _ = ((Foo.div ~children:[x] ()) [@JSX])' | fmt
  let _ = <Foo.div>x</Foo.div>

Hand-written [@JSX] applications that JSX syntax cannot express are kept as
regular applications:
  $ echo 'let _ = ((App.createElement ~children ()) [@JSX])' | fmt
  let _ = App.createElement ~children () [@JSX]
  $ echo 'let _ = ((App.createElement ~children:(make_children ()) ()) [@JSX])' | fmt
  let _ = App.createElement ~children:(make_children ()) () [@JSX]
  $ echo 'let _ = ((App.createElement ~children:[]) [@JSX])' | fmt
  let _ = App.createElement ~children:[] [@JSX]
  $ echo 'let _ = ((App.createElement ()) [@JSX])' | fmt
  let _ = App.createElement () [@JSX]
  $ echo 'let _ = ((App.createElement x ~children:[] ()) [@JSX])' | fmt
  let _ = App.createElement x ~children:[] () [@JSX]
  $ echo 'let _ = ((App.createElement ~children:[] ~children:[] ()) [@JSX])' | fmt
  let _ = App.createElement ~children:[] ~children:[] () [@JSX]
  $ echo 'let _ = (((get_component ()) ~children:[] ()) [@JSX])' | fmt
  let _ = (get_component ()) ~children:[] () [@JSX]

Object types whose opening "<" is not followed by a space (the lexer would
otherwise read "<m" as the start of a JSX element; a type context can never
contain JSX, so this is unambiguous):
  $ echo 'let f (x : <m : int>) = x#m' | fmt
  let f (x : < m : int >) = x#m
  $ echo 'let f (x : <m : int; n : float>) = x#m' | fmt
  let f (x : < m : int ; n : float >) = x#m
  $ echo "let f (x : <m : 'a. 'a -> 'a>) = x#m" | fmt
  let f (x : < m : 'a. 'a -> 'a >) = x#m
  $ echo 'let f : <m : int> -> unit = fun _ -> ()' | fmt
  let f : < m : int > -> unit = fun _ -> ()

Regression guards: the spaced form, "< .. >", and the JSX expression form
must keep working:
  $ echo 'let f (x : < m : int >) = x#m' | fmt
  let f (x : < m : int >) = x#m
  $ echo 'let f (x : < .. >) = x' | fmt
  let f (x : < .. >) = x
  $ echo 'let f = <m />' | fmt
  let f = <m />

Idempotency check:
  $ echo 'let f (x : <m : int>) = x#m' | fmt | fmt
  let f (x : < m : int >) = x#m
