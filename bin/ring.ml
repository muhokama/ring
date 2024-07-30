open Yocaml

module Resolver = Gem.Resolver.Make (struct
  let source = Path.rel []
  let target = Path.rel [ "_www" ]
end)

let () = Yocaml_eio.run ~level:`Debug (Gem.Action.process_all (module Resolver))
