let run (module R : Sigs.RESOLVER) chain =
  Yocaml.Action.write_static_file R.Target.ring_opml
    (let open Yocaml.Task in
     R.track_common_dependencies
     >>> Yocaml.Pipeline.track_file R.Source.members
     >>> const chain
     >>> Model.Chain.to_opml)
