Files whose name OCamlFormat knows as OCaml are lexed as OCaml, so spellings
that mlx reserves keep their OCaml meaning:

  $ cat > a.ml <<EOF
  > let f x y = x<y
  > let g a b = a <><= b
  > let h a b = a//>b
  > EOF
  $ ocamlformat-mlx --enable-outside-detected-project a.ml
  let f x y = x < y
  let g a b = a <><= b
  let h a b = a //> b

  $ echo 'val f : [<foo] -> unit' > a.mli
  $ ocamlformat-mlx --enable-outside-detected-project a.mli
  val f : [< foo ] -> unit

In .mlx files, "<y" starts a JSX element, as in mlx-pp:

  $ echo 'let f x y = x<y' > b.mlx
  $ ocamlformat-mlx --enable-outside-detected-project b.mlx
  ocamlformat-mlx: ignoring "b.mlx" (syntax error)
  File "b.mlx", line 2, characters 0-0:
  Error: Syntax error
  [1]

Standard input follows --name, and is mlx without it:

  $ echo 'let f x y = x<y' | ocamlformat-mlx --enable-outside-detected-project --name a.ml -
  let f x y = x < y
  $ echo 'let f x y = x<y' | ocamlformat-mlx --enable-outside-detected-project --impl -
  ocamlformat-mlx: ignoring "<standard input>" (syntax error)
  File "<standard input>", line 2, characters 0-0:
  Error: Syntax error
  [1]

JSX in .mlx files is unchanged:

  $ echo '<div className="a">child <Foo.bar x=1 /></div>' > c.mlx
  $ ocamlformat-mlx --enable-outside-detected-project c.mlx
  <div className="a">child <Foo.bar x=1 /></div>
