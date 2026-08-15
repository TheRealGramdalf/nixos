{config, pkgs, lib, ...}: let
  name = "languagetool";
  dataDir = "/persist/services/languagetool";
in {
  services.languagetool = {
    enable = true;
    allowOrigin = "*";
    settings = {
      languageModel = "${dataDir}/ngrams";
      fasttextModel = "${dataDir}/fasttext/lid.176.bin";
      fasttextBinary = "${lib.getExe pkgs.fasttext}";
      trustXForwardForHeader = true;
    };
  };

  services.cone.extraFiles."${name}".settings = {
    http.routers."${name}" = {
      service = "${name}";
      rule = "Host(`${name}.aer.dedyn.io`)";
      middlewares = "local-only";
    };
    http.services."${name}".loadBalancer.servers = [{url = "http://127.0.0.1:${toString config.services.languagetool.port}";}];
  };
}
