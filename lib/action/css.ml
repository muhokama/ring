let run (module R : Sigs.RESOLVER) =
  Yocaml.Action.Static.write_file R.Target.css
    (Yocaml.Pipeline.pipe_files ~separator:"\n"
       Yocaml.Path.
         [
           R.Source.css / "fonts.css";
           R.Source.css / "reset.css";
           R.Source.css / "style.css";
         ])
