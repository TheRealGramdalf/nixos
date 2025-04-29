{ ... }: {
  services.loki = {
    enable = true;
    user = "b1bf4973-4355-4f39-a675-905fb3641a34";
    group = "b1bf4973-4355-4f39-a675-905fb3641a34";
    dataDir = "/persist/services/loki";
    configuration = "";
  }
}