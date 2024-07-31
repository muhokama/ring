let has_extension ext_list path =
  List.exists (fun ext -> Yocaml.Path.has_extension ext path) ext_list

let run ?extension ~source ~target cache =
  let where = Option.map (fun ext -> has_extension ext) extension in
  Yocaml.Action.batch ~only:`Files ?where source
    (Yocaml.Action.copy_file ~into:target)
    cache
