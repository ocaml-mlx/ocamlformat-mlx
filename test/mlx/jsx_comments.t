Setup:
  $ alias fmt="ocamlformat-mlx - --impl --enable-outside-detected-project"

Comments before, between and after JSX children are kept and the formatting
is idempotent (formatting the output again produces the same text):

  $ printf 'let view label =\n  <div className="row">\n    (* Explains why children are laid out this way. *)\n    <span>(React.string label)</span>\n  </div>\n' | fmt | fmt
  let view label =
    <div className="row">
      (* Explains why children are laid out this way. *)
      <span>(React.string label)</span>
    </div>

  $ echo 'let view label = <div className="row"><span>(React.string label)</span> (* Between or last. *) <b /></div>' | fmt | fmt
  let view label =
    <div className="row">
      <span>(React.string label)</span> (* Between or last. *) <b />
    </div>

  $ echo 'let view items = <div className="row"><A /> (* Between siblings. *) <B /> (* Last child. *)</div>' | fmt | fmt
  let view items =
    <div className="row">
      <A /> (* Between siblings. *) <B /> (* Last child. *)
    </div>

  $ printf 'let view items =\n  <div className="row">\n    <A /> (* Between siblings. *)\n    <B />\n  </div>\n' | fmt | fmt
  let view items = <div className="row"><A /> (* Between siblings. *) <B /></div>

  $ echo 'let only () = <div>(* only child *)</div>' | fmt | fmt
  let only () = <div> (* only child *) </div>

  $ printf 'let v =\n  <Grid>\n    (* c *)\n    <ReportFooter />\n  </Grid>\n' | fmt | fmt
  let v =
    <Grid>
      (* c *)
      <ReportFooter />
    </Grid>

  $ printf 'let v =\n  <Grid>\n    (* c *)\n    <ReportFooter footer />\n  </Grid>\n' | fmt | fmt
  let v =
    <Grid>
      (* c *)
      <ReportFooter footer />
    </Grid>

  $ printf 'let v =\n  <Grid>\n    (* c *)\n    <ReportFooter footer=x />\n  </Grid>\n' | fmt | fmt
  let v =
    <Grid>
      (* c *)
      <ReportFooter footer=x />
    </Grid>

A comment before the tag's first prop is kept, on a component and on a DOM
element alike:

  $ echo 'let view () = <Foo (* before first prop *) prop=x>child</Foo>' | fmt | fmt
  let view () = <Foo (* before first prop *) prop=x>child</Foo>
  $ echo 'let view () = <div (* before first prop *) prop=x>child</div>' | fmt | fmt
  let view () = <div (* before first prop *) prop=x>child</div>

A comment between two props is kept:

  $ echo 'let view () = <div a=1 (* between props *) b=2 />' | fmt | fmt
  let view () = <div a=1 (* between props *) b=2 />

A comment next to a prop whose value is itself a JSX element is kept:

  $ echo 'let view () = <div logoEl=(<Img />) (* jsx-valued prop *) other=1 />' | fmt | fmt
  let view () = <div logoEl=(<Img /> (* jsx-valued prop *)) other=1 />

A comment next to a punned prop cannot be printed on the bare punned form
(there is nowhere to attach it), so the prop is desugared to its explicit
`label=label` form instead of dropping the comment:

  $ echo 'let view label = <A label (* punned prop *) other=1 />' | fmt | fmt
  let view label = <A label=label (* punned prop *) other=1 />

A comment after a labelled JSX argument keeps both the label and the
comment, including when the call wraps across lines because of a trailing
function argument:

  $ echo 'let _ = f ~toKey:g ~intersperse:<Divider /> (* c *) (fun x -> x)' | fmt | fmt
  let _ = f ~toKey:g ~intersperse:<Divider /> (* c *) (fun x -> x)

  $ printf 'let f () =\n  RR.list list ~toKey:(fun (spec, chartProps) -> chartProps##dataKey)\n    ~intersperse:<Divider /> (* trailing comment *)\n    (fun (spec, chartProps) ->\n      let compareDataKey = 1 in\n      compareDataKey)\n' | fmt | fmt
  let f () =
    RR.list list
      ~toKey:(fun (spec, chartProps) -> chartProps##dataKey)
      ~intersperse:<Divider /> (* trailing comment *)
      (fun (spec, chartProps) ->
        let compareDataKey = 1 in
        compareDataKey)

An element or a DOM tag carrying an attribute besides `[@JSX]` is still
sugared into JSX syntax, with the extra attribute(s) printed after the
element; the `[@JSX]` marker can be anywhere in the original attribute list:

  $ echo 'let _ = (<Foo />) [@mel.as "and"]' | fmt | fmt
  let _ = <Foo /> [@mel.as "and"]
  $ echo 'let _ = <div>x</div> [@ocaml.doc "d"]' | fmt | fmt
  let _ = <div>x</div> [@ocaml.doc "d"]
  $ echo 'let _ = (<Foo />) [@mel.as "and"] [@another "b"]' | fmt | fmt
  let _ = <Foo /> [@mel.as "and"] [@another "b"]
  $ echo 'let _ = (Foo.createElement () ~children:[]) [@mel.as "and"] [@JSX]' | fmt | fmt
  let _ = <Foo /> [@mel.as "and"]
