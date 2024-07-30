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
