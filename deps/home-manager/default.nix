let thunk = builtins.fromJSON (builtins.readFile ./thunk.json);
in (builtins.fetchGit {
  inherit (thunk) url rev;
})
