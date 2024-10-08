```nix
    readNixFilesRecursive = path:
      lib.pipe path [
        lib.filesystem.listFilesRecursive
        (builtins.filter (name: lib.hasSuffix ".nix" name))
      ];
```