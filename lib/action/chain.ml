let member (module R : Sigs.RESOLVER) pred_or_succ current_member target_member
    =
  let target =
    R.Target.member_redirection
      ~id:(Model.Member.id current_member)
      pred_or_succ
  in
  Yocaml.Action.write_static_file target
    (let open Yocaml.Task in
     R.track_common_dependencies
     >>> const target_member
     >>> empty_body ()
     >>> Yocaml_jingoo.Pipeline.as_template
           (module Model.Member)
           (R.Source.template "redirect.html")
     >>> drop_first ())

let index (module R : Sigs.RESOLVER) current_member pred succ =
  let target = R.Target.member ~id:(Model.Member.id current_member) in
  Yocaml.Action.write_static_file target
    (let open Yocaml.Task in
     R.track_common_dependencies
     >>> Yocaml.Pipeline.track_file R.Source.members
     >>> Model.Member_page.from_member current_member pred succ
     >>> empty_body ()
     >>> Yocaml_jingoo.Pipeline.as_template
           (module Model.Member_page)
           (R.Source.template "member.html")
     >>> Yocaml_jingoo.Pipeline.as_template
           (module Model.Member_page)
           (R.Source.template "layout.html")
     >>> drop_first ())

let run (module R : Sigs.RESOLVER) chain =
  let member = member (module R) in
  let index = index (module R) in
  Yocaml.Action.batch_list (Model.Chain.to_list chain)
    (fun (curr, (pred, succ)) cache ->
      let open Yocaml.Eff in
      cache
      |> member `Pred curr pred
      >>= member `Succ curr succ
      >>= index curr pred succ)
