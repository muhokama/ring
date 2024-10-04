(lang dune 3.16)
(name ring)
(version dev)
(generate_opam_files)
(executables_implicit_empty_intf)

(source (github muhokama/ring ))
(license GPL-3.0-or-later)
(authors "Xavier Van de Woestyne <xaviervdw@gmail.com>")
(maintainers "Xavier Van de Woestyne <xaviervdw@gmail.com>")

(package
  (name ring)
  (synopsis "A dead-simple webring")
  (description "A webring for fans of mechanics and functional programming")
  (depends

   (ocaml (>= 5.1.1))
   (dune (>= 3.16.0))

   (yocaml (>= 2.0.0))
   (yocaml_jingoo (>= 2.0.0))
   (yocaml_yaml (>= 2.0.0))
   (yocaml_omd (>= 2.0.0))
   (yocaml_eio (>= 2.0.0))
   (yocaml_syndication (>= 2.0.0))

   (cmdliner (= 1.3.0))

   ppx_expect

   (ocamlformat :with-dev-setup)
   (ocp-indent :with-dev-setup)
   (merlin :with-dev-setup)
   (utop :with-dev-setup)
   (ocaml-lsp-server :with-dev-setup)

   (odoc :with-doc)
   (sherlodoc :with-doc)))
