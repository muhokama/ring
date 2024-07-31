let run (module R : Sigs.RESOLVER) cache =
  (* We pass [cache] in order to add more rules. *)
  cache
  |> Batch_copy.run ~extension:[ "svg"; "png" ] ~source:R.Source.static_images
       ~target:R.Target.images
