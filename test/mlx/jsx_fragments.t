Setup:
  $ alias fmt="ocamlformat-mlx - --impl --enable-outside-detected-project"

Empty fragment (a tag with no children prints self-closed, a fragment cannot):
  $ echo 'let x = <></>' | fmt | fmt
  let x = <></>
  $ echo 'let x = <div></div>' | fmt | fmt
  let x = <div />

  $ echo 'let x = <> </>' | fmt | fmt
  let x = <></>
  $ echo 'let x = <div> </div>' | fmt | fmt
  let x = <div />

Children:
  $ echo 'let x = <>child</>' | fmt | fmt
  let x = <>child</>
  $ echo 'let x = <div>child</div>' | fmt | fmt
  let x = <div>child</div>

  $ echo 'let x = <>a b c</>' | fmt | fmt
  let x = <>a b c</>
  $ echo 'let x = <div>a b c</div>' | fmt | fmt
  let x = <div>a b c</div>

  $ echo 'let x = <><A /><B /></>' | fmt | fmt
  let x = <><A /> <B /></>
  $ echo 'let x = <div><A /><B /></div>' | fmt | fmt
  let x = <div><A /> <B /></div>

  $ echo 'let x = <><div>a</div><span>b</span></>' | fmt | fmt
  let x = <><div>a</div> <span>b</span></>
  $ echo 'let x = <div><div>a</div><span>b</span></div>' | fmt | fmt
  let x = <div><div>a</div> <span>b</span></div>

Long children break like a tag:
  $ echo 'let x = <>(React.string "a very long child text number one") (React.string "a very long child text number two") (React.string "three")</>' | fmt | fmt
  let x =
    <>
      (React.string "a very long child text number one")
      (React.string "a very long child text number two")
      (React.string "three")
    </>
  $ echo 'let x = <div>(React.string "a very long child text number one") (React.string "a very long child text number two") (React.string "three")</div>' | fmt | fmt
  let x =
    <div>
      (React.string "a very long child text number one")
      (React.string "a very long child text number two")
      (React.string "three")
    </div>

Nesting:
  $ echo 'let x = <div><></></div>' | fmt | fmt
  let x = <div><></></div>
  $ echo 'let x = <div><div></div></div>' | fmt | fmt
  let x = <div><div /></div>

  $ echo 'let x = <div><>a b</></div>' | fmt | fmt
  let x = <div><>a b</></div>
  $ echo 'let x = <div><div>a b</div></div>' | fmt | fmt
  let x = <div><div>a b</div></div>

  $ echo 'let x = <><div /></>' | fmt | fmt
  let x = <><div /></>
  $ echo 'let x = <div><div /></div>' | fmt | fmt
  let x = <div><div /></div>

  $ echo 'let x = <><>a</></>' | fmt | fmt
  let x = <><>a</></>
  $ echo 'let x = <div><div>a</div></div>' | fmt | fmt
  let x = <div><div>a</div></div>

  $ echo 'let x = <div a=(<>x</>) />' | fmt | fmt
  let x = <div a=(<>x</>) />
  $ echo 'let x = <div a=(<div>x</div>) />' | fmt | fmt
  let x = <div a=(<div>x</div>) />

List literal:
  $ echo 'let x = [<>a</>; <>b</>]' | fmt | fmt
  let x = [ <>a</>; <>b</> ]
  $ echo 'let x = [<div>a</div>; <div>b</div>]' | fmt | fmt
  let x = [ <div>a</div>; <div>b</div> ]

Spread:
  $ echo 'let x = <>...xs</>' | fmt | fmt
  let x = <>...xs</>
  $ echo 'let x = <div>...xs</div>' | fmt | fmt
  let x = <div>...xs</div>

  $ echo 'let x = <> ... xs </>' | fmt | fmt
  let x = <>...xs</>
  $ echo 'let x = <div> ... xs </div>' | fmt | fmt
  let x = <div>...xs</div>

  $ echo 'let x = <>... xs</>' | fmt | fmt
  let x = <>...xs</>
  $ echo 'let x = <div>... xs</div>' | fmt | fmt
  let x = <div>...xs</div>

  $ echo 'let x = <>...(List.map f xs)</>' | fmt | fmt
  let x = <>...(List.map f xs)</>
  $ echo 'let x = <div>...(List.map f xs)</div>' | fmt | fmt
  let x = <div>...(List.map f xs)</div>

  $ echo 'let x = <>...(List.map render_item_with_a_long_name some_long_list_of_items_here_for_breaking)</>' | fmt | fmt
  let x =
    <>
      ...(List.map render_item_with_a_long_name
            some_long_list_of_items_here_for_breaking)
    </>
  $ echo 'let x = <div>...(List.map render_item_with_a_long_name some_long_list_of_items_here_for_breaking)</div>' | fmt | fmt
  let x =
    <div>
      ...(List.map render_item_with_a_long_name
            some_long_list_of_items_here_for_breaking)
    </div>

Function argument (a fragment needs parentheses, a tag does not):
  $ echo 'let x = f (<>a</>)' | fmt | fmt
  let x = f (<>a</>)
  $ echo 'let x = f (<div>a</div>)' | fmt | fmt
  let x = f <div>a</div>

  $ echo 'let x = f x (<>a</>)' | fmt | fmt
  let x = f x (<>a</>)
  $ echo 'let x = f x (<div>a</div>)' | fmt | fmt
  let x = f x <div>a</div>

  $ echo 'let x = f ~a:(<>a</>) (<>b</>)' | fmt | fmt
  let x = f ~a:<>a</> (<>b</>)
  $ echo 'let x = f ~a:(<div>a</div>) (<div>b</div>)' | fmt | fmt
  let x = f ~a:<div>a</div> <div>b</div>

Comments:
  $ echo 'let x = <> (* c *) a</>' | fmt | fmt
  let x = <> (* c *) a</>
  $ echo 'let x = <div> (* c *) a</div>' | fmt | fmt
  let x = <div> (* c *) a</div>

  $ echo 'let x = <>a (* c *) b</>' | fmt | fmt
  let x = <>a (* c *) b</>
  $ echo 'let x = <div>a (* c *) b</div>' | fmt | fmt
  let x = <div>a (* c *) b</div>

  $ echo 'let x = <>a (* c *)</>' | fmt | fmt
  let x = <>a (* c *) </>
  $ echo 'let x = <div>a (* c *)</div>' | fmt | fmt
  let x = <div>a (* c *) </div>

  $ echo 'let x = <> (* only *) </>' | fmt | fmt
  let x = <> (* only *) </>
  $ echo 'let x = <div> (* only *) </div>' | fmt | fmt
  let x = <div> (* only *) </div>

  $ echo 'let x = <>(* c *) ...xs</>' | fmt | fmt
  let x = <>(* c *) ...xs</>
  $ echo 'let x = <div>(* c *) ...xs</div>' | fmt | fmt
  let x = <div>(* c *) ...xs</div>

  $ echo 'let x = <>...xs (* c *)</>' | fmt | fmt
  let x = <>...xs (* c *)</>
  $ echo 'let x = <div>...xs (* c *)</div>' | fmt | fmt
  let x = <div>...xs (* c *)</div>

Margin:
  $ echo 'let x = <><A className="some" /><B className="another" /></>' | fmt --margin=30 | fmt --margin=30
  let x =
    <>
      <A className="some" />
      <B className="another" />
    </>
  $ echo 'let x = <div><A className="some" /><B className="another" /></div>' | fmt --margin=30 | fmt --margin=30
  let x =
    <div>
      <A className="some" />
      <B className="another" />
    </div>

The operator <> keeps working:

  $ echo 'let x = a <> b' | fmt | fmt
  let x = a <> b
  $ echo 'let x = f x <> g y' | fmt | fmt
  let x = f x <> g y
  $ echo 'let x = (<>) a b' | fmt | fmt
  let x = a <> b
  $ echo 'let x = a <>b' | fmt | fmt
  let x = a <> b
  $ echo 'let x = a<>b' | fmt | fmt
  let x = a <> b
  $ echo 'let x = <>a</> <> <>b</>' | fmt | fmt
  let x = <>a</> <> <>b</>

The operator </> keeps working:

  $ echo 'let (</>) a b = a' | fmt | fmt
  let ( </> ) a b = a
  $ echo 'let _ = a </> b' | fmt | fmt
  let _ = a </> b
  $ echo 'let _ = a</>b' | fmt | fmt
  let _ = a </> b
  $ echo 'let _ = ( </> ) a b' | fmt | fmt
  let _ = a </> b
  $ echo 'let _ = M.(</>)' | fmt | fmt
  let _ = M.( </> )
  $ echo 'let _ = <>(a + b)</>' | fmt | fmt
  let _ = <>(a + b)</>
  $ echo 'let _ = <>(a </> b)</>' | fmt | fmt
  let _ = <>(a </> b)</>
  $ echo 'let _ = a </> <>b</>' | fmt | fmt
  let _ = a </> <>b</>
  $ echo 'let _ = <>a</> </> <>b</>' | fmt | fmt
  let _ = <>a</> </> <>b</>
  $ echo 'let _ = a </> <div />' | fmt | fmt
  let _ = a </> <div />
  $ echo 'let _ = aaaaaaaaaaaaaaaaaaaa </> bbbbbbbbbbbbbbbbbbbbbbb </> cccccccccccccccccccccc </> dddddddddddddddddddd </> eeeeeeeeeeeeeeeeeeee' | fmt | fmt
  let _ =
    aaaaaaaaaaaaaaaaaaaa </> bbbbbbbbbbbbbbbbbbbbbbb </> cccccccccccccccccccccc
    </> dddddddddddddddddddd </> eeeeeeeeeeeeeeeeeeee
  $ echo 'let _ = <>aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa</> </> <>bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb</> </> <>cccccccccccccccccccccccc</>' | fmt | fmt
  let _ =
    <>aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa</>
    </> <>bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb</>
    </> <>cccccccccccccccccccccccc</>

A </> after fragment children closes the fragment:

  $ echo 'let _ = <>a </> b</>' | fmt
  ocamlformat-mlx: ignoring "<standard input>" (syntax error)
  File "<standard input>", line 2, characters 0-0:
  Error: Syntax error
  [1]
