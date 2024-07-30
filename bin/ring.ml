let run_build target source log_level =
  let module Resolver = Gem.Resolver.Make (struct
    let source = source
    let target = target
  end) in
  Yocaml_eio.run ~level:log_level (Gem.Action.process_all (module Resolver))

let run_watch target source log_level port =
  let module Resolver = Gem.Resolver.Make (struct
    let source = source
    let target = target
  end) in
  Yocaml_eio.serve ~target:Resolver.target ~level:log_level ~port
    (Gem.Action.process_all (module Resolver))

open Cmdliner

let exits = Cmd.Exit.defaults
let version = "dev"

let path_conv =
  Arg.conv ~docv:"PATH"
    ((fun str -> str |> Yocaml.Path.from_string |> Result.ok), Yocaml.Path.pp)

let port_conv =
  Arg.conv' ~docv:"PORT"
    ( (fun str ->
        match int_of_string_opt str with
        | None -> Result.error (str ^ " is not a valid port value")
        | Some x when x < 0 -> Result.error (str ^ " is < 0")
        | Some x when x > 9999 -> Result.error (str ^ " is > 9999")
        | Some x -> Result.ok x),
      fun ppf -> Format.fprintf ppf "%04d" )

let log_level_conv =
  Arg.conv ~docv:"LEVEL"
    ( (fun str ->
        match String.(str |> trim |> lowercase_ascii) with
        | "app" -> Result.ok `App
        | "info" -> Result.ok `Info
        | "error" -> Result.ok `Error
        | "warning" -> Result.ok `Warning
        | _ -> Result.ok `Debug),
      fun ppf -> function
        | `App -> Format.fprintf ppf "app"
        | `Debug -> Format.fprintf ppf "debug"
        | `Info -> Format.fprintf ppf "info"
        | `Error -> Format.fprintf ppf "error"
        | `Warning -> Format.fprintf ppf "warning" )

let target_arg =
  let default = Yocaml.Path.rel [ "_www" ] in
  let doc = "The directory where the ring will be built" in
  let arg =
    Arg.info ~doc ~docs:Manpage.s_common_options [ "target"; "output" ]
  in
  Arg.(value (opt path_conv default arg))

let source_arg =
  let default = Yocaml.Path.rel [] in
  let doc = "The directory used as source" in
  let arg =
    Arg.info ~doc ~docs:Manpage.s_common_options [ "source"; "input" ]
  in
  Arg.(value (opt path_conv default arg))

let port_arg =
  let default = 8888 in
  let doc = "The port used to serve the development server" in
  let arg = Arg.info ~doc ~docs:Manpage.s_common_options [ "port"; "listen" ] in
  Arg.(value (opt port_conv default arg))

let log_level_arg default =
  let doc =
    "The log-level (app | info | debug | error | warning), by default"
  in
  let arg = Arg.info ~doc ~docs:Manpage.s_common_options [ "log-level" ] in
  Arg.(value (opt log_level_conv default arg))

let bug_report =
  "The application's source code is published on \
   <https://github.com/muhokama/ring>. Feel free to contribute or report bugs \
   on <https://github.com/muhokama/ring/issues>."

let description =
  "ring.muhokama is free software that lets you build a static site that \
   describes a webring, in homage to the webrings of the 1990s, a return to \
   the small-web."

let build =
  let doc =
    "Build the ring in a given TARGET, based on a given SOURCE with a given \
     LOG_LEVEL"
  in
  let man =
    [
      `S Manpage.s_description; `P description; `S Manpage.s_bugs; `P bug_report;
    ]
  in
  let info = Cmd.info "build" ~version ~doc ~exits ~man in
  let term =
    Term.(const run_build $ target_arg $ source_arg $ log_level_arg `Debug)
  in
  Cmd.v info term

let watch =
  let doc =
    "Build the ring and launch the dev-server in a given TARGET, based on a \
     given SOURCE with a given LOG_LEVEL listen to a dedicated PORT"
  in
  let man =
    [
      `S Manpage.s_description; `P description; `S Manpage.s_bugs; `P bug_report;
    ]
  in
  let info = Cmd.info "watch" ~version ~doc ~exits ~man in
  let term =
    Term.(
      const run_watch $ target_arg $ source_arg $ log_level_arg `Info $ port_arg)
  in
  Cmd.v info term

let index =
  let doc = "ring.muhokama" in
  let man =
    [
      `S Manpage.s_description; `P description; `S Manpage.s_bugs; `P bug_report;
    ]
  in
  let info = Cmd.info "dune exec bin/ring.exe" ~version ~doc ~man in
  let default = Term.(ret (const (`Help (`Pager, None)))) in
  Cmd.group info ~default [ build; watch ]

let () = exit @@ Cmd.eval index
