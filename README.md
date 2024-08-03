> [!WARNING]  
> This project uses a [developing version of
> YOCaml](https://gitlab.com/funkywork/yocaml) (to experiment with its
> expressiveness), so it is naturally also experimental and, above all, **work
> in progress** (and usable for the moment, but check back regularly to see how
> things are progressing :D).

# ring.muhokama.fun

> **ring.muhokama.fun** is a [webring](https://en.wikipedia.org/wiki/Webring)
> built with [YOCaml](https://github.com/xhtmlboi/yocaml) which produces a
> static site. The medium-term aim is to create a small community, in homage to
> the [small-web](https://ar.al/2020/08/07/what-is-the-small-web/) of people
> with personal digital spaces (blog, wiki, site, galleries) who are used to
> exchanging information on common platforms. The project is largely (and
> freely) inspired by [webring de Merveilles](https://webring.xxiivv.com/)

<!-- markdown-toc start - Don't edit this section. Run M-x markdown-toc-refresh-toc -->
**Table of Contents**

- [ring.muhokama.fun](#ringmuhokamafun)
    - [Contribute to the content of the webring](#contribute-to-the-content-of-the-webring)
        - [Join the chain](#join-the-chain)
            - [Creating your identity](#creating-your-identity)
            - [Adding the identity to the chain](#adding-the-identity-to-the-chain)
            - [Linking the webring on your website](#linking-the-webring-on-your-website)
    - [Contribute to the generator](#contribute-to-the-generator)
        - [Setting up the development environment](#setting-up-the-development-environment)
    - [Run the binary `ring.exe`](#run-the-binary-ringexe)
    - [Launching tests](#launching-tests)
    - [Project updates](#project-updates)
    - [Generating documentation locally](#generating-documentation-locally)

<!-- markdown-toc end -->


## Contribute to the content of the webring

If you feel that you have something in common with the members of the ring, you
can of course add your personal space to the webring!

### Join the chain

#### Creating your identity

The process is fairly straightforward: just create a `your-ident.yml` file in
the [data/members/](data/members) directory. You can draw inspiration from the
members already created, but the minimum data to be supplied are :

```yaml
id: your-ident
main_link:
  url: your-website-url
```

> [!WARNING]  
> Your id must have the same value as the file name (without the extension).

Here's a slightly more expansive example that takes advantage of default
settings, inspired by my entry in the webring:

```yaml
id: xvw
display_name: Xavier Van de Woestyne
bio: I'm a Belgian developer living in France (Nantes), very interested
  in statically typed functional programming.
location: France, Nantes
main_link:
  url: https://xvw.lol
  lang: fra
main_feed:
  url: https://xvw.lol/atom.xml
  lang: fra
additional_links:
  - title: X
    url: https://x.com/vdwxv
  - title: Mastodon
    url: https://merveilles.town/xvw
  - title: Github
    url: https://github.com
additional_feeds:
  - title: Journal
    url: https://xvw.lol/journal.xml
```

For the moment, add-on information is used relatively little (the additional
feeds are used to generate the OPML file) but in the near future, it is likely
that this data will be used, for example, to build profile pages.

#### Adding the identity to the chain

Now that your identity has been created, you need to add it to the chain. To do
this, simply add your id to the [data/chain.yml](data/chain.yml) file, and
you're done! You can refers to [Setting up the development
environment](#setting-up-the-development-environment) in order to test locally
your addition.

#### Linking the webring on your website

As its aim is to create links between different sites, it's a good idea to add
the Webring to your personal site. It's fun to add the Webring to your personal
site. When you are added to the Webring (and it is activated). You will have two
dedicated links:

- `https://ring.muhokama.fun/u/<YOUR-IDENT>/pred` which redirects to the
  previous member of the web ring
- `https://ring.muhokama.fun/u/<YOUR-IDENT>/succ` which redirects to the next
  member of the web ring
  
An example that could be seen on your page would be: 

```html
Hey, this site is part of 
<a href="https://ring.muhokama.fun">ring.muhokama.fun!</a><br />
<a href="https://ring.muhokama.fun/u/<YOUR-IDENT>/pred">Previous</a> 
| <a href="https://ring.muhokama.fun/u/<YOUR-IDENT>/succ">Next</a>
```

But of course you're free to decide how you want it to look!

### Area of interest

The webring index displays a (probably non-exhaustive) list of participants'
interests. If for some obscure reason you find that references are missing, you
can modify the `interests` section of the [data/index.md](data/index.md) page.


## Contribute to the generator

The Webring is a project that uses version 2 of
[YOCaml](https://github.com/xhtmlboi/yocaml), a static site generator written in
[OCaml](https://ocaml.org), which is very flexible and fun.

The project is divided into five parts:
- `lib/` contains the library code used to describe the generator. This is where
  all the webring's logic is to be found. (The library is called `Gem` (_because
  I have a dubious sense of humour_)
- `bin/` contains the binary code used to generate the site. It can be invoked
  using the command `dune exec bin/ring.exe --help`. The binary simply invokes
  the logical pipelines described in `lib`.
- `data` contains the static data used to build the ring (participants,
  participant chain, etc.). This is generally the part that is important for
  adding or moderating participants in the ring.
- `static` contains the static elements (images, css, templates) used to build
  the HTML pages generated by the generator (for _front-end afficionados_).

### Setting up the development environment

To work, we assume that a version greater than or equal to `2.2.0~beta1` of
[OPAM](https://opam.ocaml.org) is installed on your machine ([Install
OPAM](https://opam.ocaml.org/doc/Install.html), [upgrade to version
`2.2.0~xxxx`](https://opam.ocaml.org/blog/opam-2-2-0-beta2/#Try-it)).

> [!TIP]  
> We're relying on version `2.2.x` to support the `dev-setup` flag, which allows
> development dependencies to be packaged, making it very practical to install
> locally all the elements needed to create a pleasant development environment.

When you have a suitable version of OPAM, you can run the following command to
build a [local switch](https://opam.ocaml.org/blog/opam-local-switches/) to
create a sandboxed environment (with a good version of OCaml, and all the
dependencies installed locally).

```shell
opam update
opam switch create . --deps-only --with-dev-setup --with-test --with-doc -y
eval $(opam env)
```

And that's all there is to it. Launching `dune build` should build the project!
At present, the project simply prints to standard output, but you can build your
project in `bin/`. YOCaml and its various plugins will be accessible in the
scope of this directory. The setup should work with Vim and Emacs (if they are
configured to work with OCaml) and with any editor configured to use LSP (Merlin
and OCaml-lsp-server being development dependencies of the project).

The setup should work with Vim and Emacs (if they are configured to work with
OCaml) and with any editor configured to use LSP (Merlin and OCaml-lsp-server
being development dependencies of the project).


## Run the binary `ring.exe`

Just run the `ring.exe` binary compiled from `bin/ring.ml`, which should display
the `manpage`, giving information on how to interact with the binary, like this:

```shell
dune exec bin/ring.exe
```

Broadly speaking, here are the two main actions proposed by the `ring.exe`
binary:

- `dune exec bin/ring.exe` display the manpage of the binary
- `dune exec bin/ring.exe -- build [COMMON_OPTIONS]` builds the ring in `_www`
  using the current directory as source
- `dune exec bin/ring.exe -- build [COMMON_OPTIONS] [--port PORT]` launches a
  development server that rebuilds the ring each time a page is refreshed

The common options are:

- `--target PATH` describes the compilation target (the directory where the ring
  is to be built)
- `--source PATH` describes the compilation source (the directory where the data of the ring are located)
- `--log-level (info | app | debug | error | warning)` describes the log-level

## Launching tests

The build procedure is based on `dune`, without any particular sorcery, so
issuing the following command is enough to run the tests:

```shell
dune test
```

For more information on [dune](https://dune.build/) testing, please go to the
[relevant manual page](https://dune.readthedocs.io/en/stable/tests.html).

## Project updates

When you have retrieved a new version of the project (from
[github.com/muhokama/ring](https://github.com/muhokama/ring) for example), you
can run the following command to make sure that all the dependencies are
present:

```shell
opam update
opam install . --deps-only --with-test --with-doc --with-dev-setup -y
```

This is important because, for the moment, **ring** depends on a version of
YOCaml that is currently under development.

## Generating documentation locally

You can view the documentation for the entire project (and its dependencies)
locally by running the following command:

```shell
dune build @doc-new
```

The doc will be generated in the following directory:
`_build/default/_doc_new/html/docs/index.html` (with
[Sherlodoc](https://doc.sherlocode.com/) for easy search by type).

