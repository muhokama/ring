let run (module R : Sigs.RESOLVER) =
  let open Yocaml.Eff in
  let* cache = Yocaml.Action.restore_cache ~on:`Target R.Target.cache in
  let* chain =
    Yocaml_yaml.Eff.read_file_as_metadata
      (module Model.Chain.Metadata)
      ~on:`Source R.Source.chain
  in
  let+ cache, members =
    let where path =
      Yocaml.Path.has_extension "yml" path ||
      Yocaml.Path.has_extension "yaml" path
    in
    Yocaml.Action.fold ~only:`Files
      ~where
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
  (cache, Model.Chain.init ~chain ~members)
