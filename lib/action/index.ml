let run (module R : Sigs.RESOLVER) chain =
  Yocaml.Action.write_static_file R.Target.index
    (let open Yocaml.Task in
     R.track_common_dependencies
     >>> Yocaml.Pipeline.track_file R.Source.members
     >>> Yocaml_yaml.Pipeline.read_file_with_metadata
           (module Model.Index)
           R.Source.index
     >>> first @@ Model.Index.merge_chain chain
     >>> Yocaml_omd.content_to_html ()
     >>> Yocaml_jingoo.Pipeline.as_template
           (module Model.Index)
           (R.Source.template "index.html")
     >>> Yocaml_jingoo.Pipeline.as_template
           (module Model.Index)
           (R.Source.template "layout.html")
     >>> drop_first ())
