let run (module R : Sigs.RESOLVER) chain =
  Yocaml.Action.write_static_file R.Target.atom
    (let open Yocaml.Task in
     R.track_common_dependencies
     >>> Yocaml.Pipeline.track_file R.Source.articles
     >>> Model.Articles.atom chain R.Source.articles)
