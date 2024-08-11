type t = { page : Page.t; member : Member.t; pred : Member.t; succ : Member.t }

let from_member member pred succ =
  Yocaml.Task.lift (fun () ->
      let name = Member.display_name member in
      let id = Member.id member in
      let page =
        Page.make ~title:name ~description:("Page of " ^ name) ~sub_path:id ()
      in
      { page; member; pred; succ })

let normalize { page; member; pred; succ } =
  let open Yocaml.Data in
  Page.normalize page
  @ [
      ("member", record @@ Member.normalize member);
      ("pred", record @@ Member.normalize pred);
      ("succ", record @@ Member.normalize succ);
    ]
