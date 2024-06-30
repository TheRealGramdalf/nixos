### Remote users

- https://github.com/nix-community/home-manager/blob/master/nixos/common.nix#L100-L104
  - This is what causes the failiure if you enable `useUserPackages`. The fix is to either not `useUserPackages`, or to modify `users.users` so it doesn't create users
  - https://github.com/NixOS/nixpkgs/blob/55445baeaf437fcff9da417182b6e68c9487e968/nixos/modules/config/users-groups.nix#L754-L762
    - This is what causes the error on the NixOS side of things. This should be modifiable so that 
  
- https://github.com/nix-community/home-manager/blob/master/nixos/common.nix#L34-L35
  - This is what causes the failiure if you `lib.mkForce` `home.username` and `home.homeDirectory`. Since it is always evaluated, it will throw an error if the user does not exist.
  - Also see https://github.com/nix-community/home-manager/commit/ca4126e3c568be23a0981c4d69aed078486c5fce. According to this logic, this should also go in an `mkIf` statement
- 32 char user limit
  - https://github.com/systemd/systemd/blob/73df6cd3ee4ac88953a91cd20707f7f5b8fa7d21/docs/USER_NAMES.md?plain=1#L82-L87
  - See https://github.com/kanidm/kanidm/discussions/2826
  - This may not be an issue when it comes to NixOS, since systemd should be in "relaxed" mode regarding Kanidm users. The issue is mainly that NixOS asserts the same