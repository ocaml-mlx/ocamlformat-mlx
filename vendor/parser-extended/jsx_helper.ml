open Printf
open Asttypes
open Longident
open Parsetree
open Ast_helper

let make_loc (startpos, endpos) =
  {
    Location.loc_start = startpos;
    Location.loc_end = endpos;
    Location.loc_ghost = false;
  }

let mkloc = Location.mkloc
let mkexp ~loc d = Exp.mk ~loc:(make_loc loc) d

let mkjsxexp ~loc:loc' e =
  let e = mkexp ~loc:loc' e in
  let loc = make_loc loc' in
  let pexp_attributes = [ Attr.mk ~loc { txt = "JSX"; loc } (PStr []) ] in
  { e with pexp_attributes }

let rec equal_longindent a b =
  match a, b with
  | Longident.Lident a, Longident.Lident b -> String.equal a b
  | Ldot (pa, a), Ldot (pb, b) ->
      String.equal a.txt b.txt && equal_longindent pa.txt pb.txt
  | Lapply _, _ | _, Lapply _ -> assert false
  | _ -> false

let make_jsx_element ~raise ~loc:_ ~tag ~end_tag ~props ~children () =
  let () =
    match end_tag with
    | None -> ()
    | Some (end_tag, (_, end_loc_e)) ->
        let eq =
          match tag, end_tag with
          | (`Module, _, s), (`Module, _, e) -> equal_longindent s e
          | (`Value, _, s), (`Value, _, e) -> equal_longindent s e
          | _ -> false
        in
        if not eq then
          let _, (end_loc_s, _), _ = end_tag in
          let end_loc = end_loc_s, end_loc_e in
          let _, start_loc, tag = tag in
          let tag = Longident.flatten tag |> String.concat "." in
          raise
            Syntaxerr.(
              Error
                (Unclosed
                   ( make_loc start_loc,
                     sprintf "<%s>" tag,
                     make_loc end_loc,
                     sprintf "</%s>" tag )))
  in
  let tag =
    match tag with
    | `Value, loc, txt ->
        mkexp ~loc (Pexp_ident { loc = make_loc loc; txt })
    | `Module, loc, txt ->
        let txt = Longident.Ldot (mkloc txt (make_loc loc), mkloc "createElement" (make_loc loc)) in
        mkexp ~loc (Pexp_ident { loc = make_loc loc; txt })
  in
  let props =
    let prop_exp ~loc name =
      let id = mkloc (Lident name.txt) (make_loc loc) in
      mkexp ~loc (Pexp_ident id)
    in
    List.map
      (function
        | loc, `Prop_punned name -> Labelled {txt=name.txt;loc = make_loc loc}, prop_exp ~loc name
        | loc, `Prop_opt_punned name -> Optional {txt=name.txt;loc = make_loc loc}, prop_exp ~loc name
        | _loc, `Prop (name, expr) -> Labelled name, expr
        | _loc, `Prop_opt (name, expr) -> Optional name, expr)
      props
  in
  let unit =
    Exp.mk ~loc:Location.none
      (Pexp_construct ({ txt = Lident "()"; loc = Location.none }, None))
  in
  let props = (Labelled {txt="children"; loc=children.pexp_loc}, children) :: props in
  Pexp_apply (tag, (Nolabel, unit) :: props)

(** A [@JSX] application that can be printed with JSX syntax. *)
type element = {
  tag : string;
  tag_loc : Location.t;
  props : (arg_label * expression) list;
  children_loc : Location.t;
  children : expression list;
}

(** Classify a [@JSX] application. JSX syntax can only express applications
    of the exact shape produced by [make_jsx_element]: an identifier tag
    applied to one unlabelled [()] argument, one [~children] argument that
    is a list literal, and labelled or optional props. Hand-written [@JSX]
    applications may have any other shape (see
    ocaml-mlx/ocamlformat-mlx#12), in which case [None] is returned and the
    application must be printed as a regular application. *)
let classify_element ~attrs e0 args =
  let tag =
    let rec ident_of = function
      | Lident name -> Some name
      | Ldot (id, name) ->
        Option.map (fun path -> path ^ "." ^ name.txt) (ident_of id.txt)
      | Lapply _ -> None
    in
    match e0.pexp_desc with
    | Pexp_ident { txt = Lident name; loc } -> Some (name, loc)
    | Pexp_ident { txt = Ldot (id, name); loc = _ } ->
      Option.map
        (fun path ->
          let tag =
            (* [<Foo />] is parsed as [Foo.createElement]. *)
            match name.txt with
            | "createElement" -> path
            | name -> path ^ "." ^ name
          in
          (tag, e0.pexp_loc))
        (ident_of id.txt)
    | _ -> None
  in
  let units, children, props =
    List.fold_right
      (fun arg (units, children, props) ->
        match arg with
        | ( Nolabel,
            { pexp_desc = Pexp_construct ({ txt = Lident "()"; _ }, None);
              pexp_attributes = [];
              _ } ) ->
          (() :: units, children, props)
        | ( Labelled { txt = "children"; _ },
            { pexp_desc = Pexp_list es; pexp_attributes = []; pexp_loc; _ } )
          ->
          (units, (pexp_loc, es) :: children, props)
        | ( Labelled { txt = "children"; _ },
            { pexp_desc = Pexp_construct ({ txt = Lident "[]"; _ }, None);
              pexp_attributes = [];
              pexp_loc;
              _ } ) ->
          (units, (pexp_loc, []) :: children, props)
        | arg -> (units, children, arg :: props))
      args ([], [], [])
  in
  let is_prop = function
    | Labelled { txt = "children"; _ }, _ ->
      false (* punned or not a list literal *)
    | (Labelled _ | Optional _), _ -> true
    | Nolabel, _ -> false
  in
  match (attrs, tag, units, children) with
  | ( [ { attr_name = { txt = "JSX"; _ }; attr_payload = PStr []; _ } ],
      Some (tag, tag_loc),
      [ () ],
      [ (children_loc, children) ] )
    when List.for_all is_prop props ->
    Some { tag; tag_loc; props; children_loc; children }
  | _ -> None
