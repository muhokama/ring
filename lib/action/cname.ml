let run (module R : Sigs.RESOLVER) =
  Yocaml.Action.copy_file ~into:R.Target.root R.Source.cname
