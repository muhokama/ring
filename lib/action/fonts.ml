let run (module R : Sigs.RESOLVER) =
  Batch_copy.run ~extension:[ "woff2" ] ~source:R.Source.fonts
    ~target:R.Target.fonts
