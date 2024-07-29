module Make (R : Sigs.RESOLVABLE) = struct
  include R
  open Yocaml

  module Source = struct
    let root = R.source
    let data = Path.(R.source / "data")
    let static = Path.(R.source / "static")
    let css = Path.(static / "css")
    let templates = Path.(static / "templates")
    let template file = Path.(templates / file)
  end

  module Target = struct
    let root = R.target
    let cache = Path.(R.target / "cache")
    let data = Path.(R.target / "data")
    let members = Path.(data / "members")
    let chain = Path.(data / "chain.yml")
  end
end
