type t = { current : Member.t; predecessor : Member.t; successor : Member.t }

let init ~current ~predecessor ~successor =
  Yocaml.Task.const { current; predecessor; successor }

let normalize { current; predecessor; successor } =
  let open Yocaml.Data in
  [
    ("current", record @@ Member.normalize current);
    ("predecessor", record @@ Member.normalize predecessor);
    ("successor", record @@ Member.normalize successor);
  ]
