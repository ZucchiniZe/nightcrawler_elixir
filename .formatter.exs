# Used by "mix format"
[
  inputs: ["mix.exs", "{config,lib,test}/**/*.{ex,exs}"],
  subdirectories: ["apps/*"],
  import_deps: [:phoenix, :ecto]
]
