let run (module R : Sigs.RESOLVER) =
  Batch_copy.run ~extension:[ "css" ] ~source:R.Source.css ~target:R.Target.css
