include Base
include Stdio

module Fpath = Fpath
module List = List_ext
module String = String_ext
module Warning = Warning
module Format = Stdlib.Format
module Filename = Stdlib.Filename

let normalized_path_to_string p =
  let cwd = Fpath.v (Stdlib.Sys.getcwd ()) in
  let p = match Fpath.relativize ~root:cwd p with Some p -> p | None -> p in
  fst (Fpath.split_volume p) ^ String.concat ~sep:"/" (Fpath.segs p)

let ( >> ) f g x = g (f x)

let impossible msg = failwith msg

let check f x =
  assert (
    ignore (f x) ;
    true ) ;
  x
