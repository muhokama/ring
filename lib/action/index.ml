let run (module R : Sigs.RESOLVER) _chain =
  Yocaml.Action.write_static_file R.Target.index
    (let open Yocaml.Task in
     R.track_common_dependencies
     >>> Yocaml.Pipeline.track_file R.Source.members
     >>> Yocaml_yaml.Pipeline.read_file_with_metadata
           (module Model.Page)
           R.Source.index
     >>> Yocaml_omd.content_to_html ()
     >>> Yocaml_jingoo.Pipeline.as_template
           (module Model.Page)
           (R.Source.template "layout.html")
     >>> drop_first ())
