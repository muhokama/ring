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
   yocaml
   yocaml_jingoo
   yocaml_yaml
   yocaml_omd
   yocaml_eio
   yocaml_syndication

   (ocamlformat :with-dev-setup)
   (ocp-indent :with-dev-setup)
   (merlin :with-dev-setup)
   (utop :with-dev-setup)
   (ocaml-lsp-server :with-dev-setup)

   (odoc :with-doc)
   (sherlodoc :with-doc)))
