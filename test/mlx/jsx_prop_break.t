Setup:
  $ alias fmt="ocamlformat-mlx - --impl --enable-outside-detected-project"

A JSX prop value that does not fit on the prop line starts on its own line,
indented by 2 from the prop name. Short values and punned props are unchanged:

  $ cat > in0.mlx <<'EOF'
  > let a = <SidebarItem report=(ContentGapReportWithLongName { targetAndCompetitors; filters = CaContentGapFilter.getDefault (); extra = None }) currentReport />
  > EOF
  $ fmt < in0.mlx > out0.mlx; cat out0.mlx
  let a =
    <SidebarItem
      report=
        (ContentGapReportWithLongName
           {
             targetAndCompetitors;
             filters = CaContentGapFilter.getDefault ();
             extra = None;
           })
      currentReport
    />
  $ fmt < out0.mlx | diff out0.mlx -

  $ cat > in1.mlx <<'EOF'
  > let b = <SidebarItem url=(match active with | true -> "" | false -> CaUrl.toUrl (Report report) ~origin:Internal ~tracking:true ()) currentReport />
  > EOF
  $ fmt < in1.mlx > out1.mlx; cat out1.mlx
  let b =
    <SidebarItem
      url=
        (match active with
        | true -> ""
        | false -> CaUrl.toUrl (Report report) ~origin:Internal ~tracking:true ())
      currentReport
    />
  $ fmt < out1.mlx | diff out1.mlx -

  $ cat > in2.mlx <<'EOF'
  > let c = <SidebarItem ?status=(Some (SidebarAddon.Status.make ~label:"a long label here" ~tone:Warning ~icon:None ())) currentReport />
  > EOF
  $ fmt < in2.mlx > out2.mlx; cat out2.mlx
  let c =
    <SidebarItem
      ?status=
        (Some
           (SidebarAddon.Status.make ~label:"a long label here" ~tone:Warning
              ~icon:None ()))
      currentReport
    />
  $ fmt < out2.mlx | diff out2.mlx -

  $ cat > in3.mlx <<'EOF'
  > let d = <SidebarItem report=(LinkIntersect { x; y }) currentReport />
  > EOF
  $ fmt < in3.mlx > out3.mlx; cat out3.mlx
  let d = <SidebarItem report=(LinkIntersect { x; y }) currentReport />
  $ fmt < out3.mlx | diff out3.mlx -

  $ cat > in4.mlx <<'EOF'
  > let e = <SidebarItem
  >       label=(CaUrl.showReportTitle report)
  >             (* first *)
  >             (* second *)
  >       url=(match active with | true -> "" | false -> CaUrl.toUrl (Report report) ~origin:Internal ~tracking:true ())
  >       active
  >     />
  > EOF
  $ fmt < in4.mlx > out4.mlx; cat out4.mlx
  let e =
    <SidebarItem
      label=(CaUrl.showReportTitle report)
      (* first *)
      (* second *)
      url=
        (match active with
        | true -> ""
        | false -> CaUrl.toUrl (Report report) ~origin:Internal ~tracking:true ())
      active
    />
  $ fmt < out4.mlx | diff out4.mlx -

  $ cat > in5.mlx <<'EOF'
  > let f = <Outer><Inner report=(ContentGapReportWithLongName { targetAndCompetitors; filters = CaContentGapFilter.getDefault (); extra = None }) currentReport /></Outer>
  > EOF
  $ fmt < in5.mlx > out5.mlx; cat out5.mlx
  let f =
    <Outer>
      <Inner
        report=
          (ContentGapReportWithLongName
             {
               targetAndCompetitors;
               filters = CaContentGapFilter.getDefault ();
               extra = None;
             })
        currentReport
      />
    </Outer>
  $ fmt < out5.mlx | diff out5.mlx -
