module Make (R : Sigs.RESOLVABLE) = struct
  include R
  open Yocaml

  module Source = struct
    let root = R.source
    let binary = Path.rel [ Sys.argv.(0) ]
    let data = Path.(R.source / "data")
    let static = Path.(R.source / "static")
    let css = Path.(static / "css")
    let fonts = Path.(static / "fonts")
    let templates = Path.(static / "templates")
    let template file = Path.(templates / file)
    let members = Path.(data / "members")
    let chain = Path.(data / "chain.yml")
    let common_deps = [ binary; chain ]
    let cname = Path.(static / "CNAME")
    let index = Path.(data / "index.md")
    let static_images = Path.(static / "images")
    let avatars = Path.(data / "avatars")
  end

  module Target = struct
    let root = R.target
    let cache = Path.(R.target / "cache")
    let opml = Path.(R.target / "opml")
    let ring_opml = Path.(opml / "ring.opml")
    let members = Path.(R.target / "u")
    let css = Path.(R.target / "css")
    let fonts = Path.(R.target / "fonts")
    let index = Path.(R.target / "index.html")
    let images = Path.(R.target / "images")
    let avatars = Path.(images / "avatars")
    let member ~id = Path.(members / id / "index.html")

    let member_redirection ~id pred_or_succ =
      let target = Path.(members / id) in
      match pred_or_succ with
      | `Pred -> Path.(target / "pred" / "index.html")
      | `Succ -> Path.(target / "succ" / "index.html")
  end

  let track_common_dependencies = Yocaml.Pipeline.track_files Source.common_deps
end
