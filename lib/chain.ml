module SMap = Map.Make (String)

type elt = {
  pred : Model.Member.t;
  curr : Model.Member.t;
  succ : Model.Member.t;
}

type t = elt list

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
        let key = Model.Member.id member in
        SMap.add key member acc)
      SMap.empty members
  in
  let chain = List.filter_map (fun x -> SMap.find_opt x members) chain in
  from_member_list chain

let fold f start chain =
  List.fold_left
    (fun acc { pred; curr; succ } -> f acc ~pred ~curr ~succ)
    start chain
