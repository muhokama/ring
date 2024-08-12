let run (module R : Sigs.RESOLVER) chain =
  Yocaml.Action.write_static_file R.Target.blog
    (let open Yocaml.Task in
     R.track_common_dependencies
     >>> Yocaml.Pipeline.track_file R.Source.articles
     >>> Yocaml_yaml.Pipeline.read_file_with_metadata
           (module Model.Page)
           R.Source.blog
     >>> first @@ Model.Articles.index chain R.Source.articles
     >>> Yocaml_omd.content_to_html ()
     >>> Yocaml_jingoo.Pipeline.as_template
           (module Model.Articles)
           (R.Source.template "blog.html")
     >>> Yocaml_jingoo.Pipeline.as_template
           (module Model.Articles)
           (R.Source.template "layout.html")
     >>> drop_first ())
