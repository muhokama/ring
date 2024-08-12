module Metadata = struct
  type t = string list

  let entity_name = "Chain"
  let neutral = Ok []

  let validate =
    let open Yocaml.Data.Validation in
    (null & const []) / list_of Yocaml.Slug.validate
end

module SMap = Map.Make (String)

type elt = { pred : Member.t; curr : Member.t; succ : Member.t }
type t = elt list

let empty = []

let from_member_list = function
  | [] -> []
  | x :: xs ->
      let first = x in
      let rec aux snd pred acc = function
        | [] -> [ { pred = first; curr = first; succ = first } ]
        | curr :: succ :: xs ->
            let snd = Option.value ~default:curr snd in
            let hdl = { pred; curr; succ } :: acc in
            aux (Some snd) curr hdl (succ :: xs)
        | [ curr ] ->
            let latest =
              {
                pred = curr;
                curr = first;
                succ = Option.value ~default:curr snd;
              }
            in
            let hdl = { pred; curr; succ = first } :: acc in
            hdl @ [ latest ]
      in
      xs |> aux None first [] |> List.rev

let init ~chain ~members =
  let members =
    List.fold_left
      (fun acc member ->
        let key = Member.id member in
        SMap.add key member acc)
      SMap.empty members
  in
  let chain = List.filter_map (fun x -> SMap.find_opt x members) chain in
  from_member_list chain

let fold f start chain =
  List.fold_left
    (fun acc { pred; curr; succ } -> f acc ~pred ~curr ~succ)
    start chain

let to_list = List.map (fun { pred; curr; succ } -> (curr, (pred, succ)))

let ring_feed =
  Yocaml_syndication.Opml.subscription ~title:"ring.muhokama.fun"
    ~description:"federated blog of Muhokama webring"
    ~html_url:"https://ring.muhokama.fun"
    ~feed_url:"https://ring.muhokama.fun/atom.xml" ()

let to_opml =
  let open Yocaml.Task in
  List.concat_map (fun { curr; _ } -> Member.to_outline curr)
  |>> lift (fun outlines -> ring_feed :: outlines)
  >>> Yocaml_syndication.Opml.opml2_from ~title:"ring.muhokama.fun" ()

let normalize_elt { pred; curr; succ } =
  let open Yocaml.Data in
  record
    (Member.normalize curr
    @ [ ("pred", string @@ Member.id pred); ("succ", string @@ Member.id succ) ]
    )

let unknow_author = Yocaml_syndication.Person.make "Unknown author"
let normalize = Yocaml.Data.list_of normalize_elt
let is_empty = List.is_empty

let to_authors chain =
  match List.map (fun { curr; _ } -> Member.as_author curr) chain with
  | [] -> (* Should never happen *) Yocaml.Nel.singleton unknow_author
  | x :: xs -> Yocaml.Nel.(x :: xs)

let as_author chain id =
  chain
  |> List.find_map (fun { curr; _ } ->
         if String.equal (Member.id curr) id then Some curr else None)
  |> Option.fold ~none:unknow_author (* Should never happen *)
       ~some:Member.as_author
