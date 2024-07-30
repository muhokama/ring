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

let final_message _cache = Yocaml.Eff.log ~level:`Debug "ring.muhokama done"

let generate_opml (module R : Sigs.RESOLVER) chain =
  Yocaml.Action.write_static_file R.Target.ring_opml
    (let open Yocaml.Task in
     Yocaml.Pipeline.track_files (R.Source.members :: R.Source.common_deps)
     >>> const chain
     >>> Chain.to_opml)

let process_all (module R : Sigs.RESOLVER) () =
  let open Yocaml.Eff in
  let* cache, chain = init_chain (module R) in
  return cache
  >>= generate_opml (module R) chain
  >>= Yocaml.Action.store_cache R.Target.cache
  >>= final_message
