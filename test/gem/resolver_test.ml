(* A dummy resolver *)
module R = Gem.Resolver.Make (struct
  let source = Yocaml.Path.rel []
  let target = Yocaml.Path.(source / "_www")
end)

let%expect_test "Resolve some path" =
  List.iter
    (fun path -> print_endline @@ Yocaml.Path.to_string path)
    [
      R.Source.root;
      R.Target.root;
      R.Source.data;
      R.Source.static;
      R.Source.css;
      R.Source.templates;
      R.Source.template "layout.html";
      R.Source.template "test.html";
      R.Source.template "test.tpl.html";
      R.Source.template "layout.jingo.html";
    ];
  [%expect
    {|
    ./
    ./_www
    ./data
    ./static
    ./static/css
    ./static/templates
    ./static/templates/layout.html
    ./static/templates/test.html
    ./static/templates/test.tpl.html
    ./static/templates/layout.jingo.html
    |}]
