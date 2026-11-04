
#!/usr/bin/env -S just --justfile
# ^ A shebang isn't required, but allows a justfile to be executed
#   like a script, with `./justfile test`, for example.

log := "warn"

export JUST_LOG := log

clean:
  deadnix --edit
  statix fix
  nix fmt

geniso:
  nix build .#nixosConfigurations.iso.config.system.build.isoImage

genguiso:
  nix build .#nixosConfigurations.guiso.config.system.build.isoImage

checkhosts:
  nix eval .#nixosConfigurations.aer.config.system.build.toplevel
  nix eval .#nixosConfigurations.aerwiar.config.system.build.toplevel
  nix eval .#nixosConfigurations.atreus.config.system.build.toplevel
  nix eval .#nixosConfigurations.muffin-time.config.system.build.toplevel
