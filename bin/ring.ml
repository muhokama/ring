open Yocaml

module Resolver = Gem.Resolver.Make (struct
  let source = Path.rel []
  let target = Path.rel [ "_www" ]
end)

let final_message _cache = Eff.log ~level:`Debug "ring.muhokama done"

let generate_opml chain =
  Action.write_static_file Resolver.Target.ring_opml
    (let open Task in
     Pipeline.track_files
       (Resolver.Source.members :: Resolver.Source.common_deps)
     >>> const chain
     >>> Gem.Chain.to_opml)

let process_all () =
  let open Eff in
  let* cache, chain = Gem.Action.init_chain (module Resolver) in
  return cache
  >>= generate_opml chain
  >>= Action.store_cache Resolver.Target.cache
  >>= final_message

let () = Yocaml_eio.run ~level:`Debug process_all
