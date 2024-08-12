let init_message (module R : Sigs.RESOLVER) =
  Yocaml.Eff.logf ~level:`Debug "ring.muhokama [source: `%a`, target: `%a`]"
    Yocaml.Path.pp R.source Yocaml.Path.pp R.target

let final_message _cache = Yocaml.Eff.log ~level:`Debug "ring.muhokama done"

let run (module R : Sigs.RESOLVER) () =
  let open Yocaml.Eff in
  let* () = init_message (module R) in
  let* cache, chain = Init.run (module R) in
  return cache
  >>= Cname.run (module R)
  >>= Fonts.run (module R)
  >>= Css.run (module R)
  >>= Images.run (module R)
  >>= Articles.run (module R) chain
  >>= Atom.run (module R) chain
  >>= Opml.run (module R) chain
  >>= Chain.run (module R) chain
  >>= Index.run (module R) chain
  >>= Yocaml.Action.store_cache R.Target.cache
  >>= final_message
