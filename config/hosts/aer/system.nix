{...}: {
  system.etc.overlay = {
    enable = true;
    mutable = false;
  };
  users.mutableUsers = false;
}