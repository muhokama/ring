open Model_util

type t = { page : Page.t; articles : Article.t list }

let from_page = Yocaml.Task.lift (fun (page, articles) -> { page; articles })

let fetch ?limit chain path =
  Yocaml.Task.from_effect (fun () ->
      let open Yocaml.Eff in
      let* files =
        read_directory ~on:`Source ~only:`Files
          ~where:(Yocaml.Path.has_extension "yml")
          path
      in

      let+ articles =
        List.traverse
          (fun file ->
            Yocaml_yaml.Eff.read_file_as_metadata
              (module Article)
              ~on:`Source file)
          files
      in
      limit
      |> Option.fold ~none:articles ~some:(fun limit ->
             articles |> Stdlib.List.filteri (fun i _ -> i > limit))
      |> Stdlib.List.sort (fun a b -> Article.sort b a)
      |> Stdlib.List.filter (Article.authors_in_chain chain))

let index ?limit chain path =
  let open Yocaml.Task in
  lift (fun x -> (x, ())) >>> second (fetch ?limit chain path) >>> from_page

let normalize { page; articles } =
  let open Yocaml.Data in
  Page.normalize page
  @ [
      ("articles", list_of (fun x -> record (Article.normalize x)) articles);
      ("has_articles", has_list articles);
    ]
