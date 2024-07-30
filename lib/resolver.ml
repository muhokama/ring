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
    let cname = Path.(static / "CNAME")
  end

  module Target = struct
    let root = R.target
    let cache = Path.(R.target / "cache")
    let opml = Path.(R.target / "opml")
    let ring_opml = Path.(opml / "ring.opml")
    let members = Path.(R.target / "u")

    let member_redirection ~id pred_or_succ =
      let target = Path.(members / id) in
      match pred_or_succ with
      | `Pred -> Path.(target / "pred" / "index.html")
      | `Succ -> Path.(target / "succ" / "index.html")
  end
end
