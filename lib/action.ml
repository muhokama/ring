let init_chain (module R : Sigs.RESOLVER) =
  let open Yocaml.Eff in
  let* cache = Yocaml.Action.restore_cache ~on:`Target R.Target.cache in
  let* chain =
    Yocaml_yaml.Eff.read_file_as_metadata
      (module Model.Chain)
      ~on:`Source R.Source.chain
  in
  let+ cache, members =
    Yocaml.Action.fold ~only:`Files
      ~where:(Yocaml.Path.has_extension "yml")
      ~state:[] R.Source.members
      (fun path state cache ->
        let+ member =
          Yocaml_yaml.Eff.read_file_as_metadata
            (module Model.Member)
            ~on:`Source path
        in
        (cache, member :: state))
      cache
  in
  (cache, Chain.init ~chain ~members)

let init_message (module R : Sigs.RESOLVER) =
  Yocaml.Eff.logf ~level:`Debug "ring.muhokama [source: `%a`, target: `%a`]"
    Yocaml.Path.pp R.source Yocaml.Path.pp R.target

let final_message _cache = Yocaml.Eff.log ~level:`Debug "ring.muhokama done"

let generate_opml (module R : Sigs.RESOLVER) chain =
  Yocaml.Action.write_static_file R.Target.ring_opml
    (let open Yocaml.Task in
     Yocaml.Pipeline.track_files (R.Source.members :: R.Source.common_deps)
     >>> const chain
     >>> Chain.to_opml)

let process_chain_member (module R : Sigs.RESOLVER) pred_or_succ current_member
    target_member =
  let target =
    R.Target.member_redirection
      ~id:(Model.Member.id current_member)
      pred_or_succ
  in
  Yocaml.Action.write_static_file target
    (let open Yocaml.Task in
     Yocaml.Pipeline.track_files R.Source.common_deps
     >>> const target_member
     >>> empty_body ()
     >>> Yocaml_jingoo.Pipeline.as_template
           (module Model.Member)
           (R.Source.template "redirect.html")
     >>> drop_first ())

let process_chain (module R : Sigs.RESOLVER) chain =
  let process_chain_member = process_chain_member (module R) in
  Yocaml.Action.batch_list (Chain.to_list chain)
    (fun (curr, (pred, succ)) cache ->
      let open Yocaml.Eff in
      cache
      |> process_chain_member `Pred curr pred
      >>= process_chain_member `Succ curr succ)

let process_all (module R : Sigs.RESOLVER) () =
  let open Yocaml.Eff in
  let* () = init_message (module R) in
  let* cache, chain = init_chain (module R) in
  return cache
  >>= Yocaml.Action.copy_file ~into:R.Target.root R.Source.cname
  >>= generate_opml (module R) chain
  >>= process_chain (module R) chain
  >>= Yocaml.Action.store_cache R.Target.cache
  >>= final_message
