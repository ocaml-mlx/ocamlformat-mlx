  $ export PATH=$PWD:$PATH
  $ echo 'let x = 1' > a.ml
  $ echo 'let x = 2' > b.ml
  $ ocamlformat a.ml b.ml
  ocamlformat-mlx: Must specify exactly one input file without --inplace or
                   --check
  [1]

  $ ocamlformat --output x.ml a.ml b.ml
  ocamlformat-mlx: Must specify exactly one input file without --inplace or
                   --check
  [1]

  $ touch a.mli
  $ ocamlformat --impl --check a.mli b.ml
  ocamlformat-mlx: Cannot specify --impl or --intf with multiple inputs
  [1]

  $ ocamlformat --name foo.ml --check a.mli b.ml
  ocamlformat-mlx: Cannot specify --name with multiple inputs
  [1]
