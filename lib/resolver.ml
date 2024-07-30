module Make (R : Sigs.RESOLVABLE) = struct
  include R
  open Yocaml

  module Source = struct
    let root = R.source
    let binary = Path.rel [ Sys.argv.(0) ]
    let data = Path.(R.source / "data")
    let static = Path.(R.source / "static")
    let css = Path.(static / "css")
    let templates = Path.(static / "templates")
    let template file = Path.(templates / file)
    let members = Path.(data / "members")
    let chain = Path.(data / "chain.yml")
    let common_deps = [ binary; chain ]
  end

  module Target = struct
    let root = R.target
    let cache = Path.(R.target / "cache")
    let opml = Path.(R.target / "opml")
    let ring_opml = Path.(opml / "ring.opml")
  end
end
