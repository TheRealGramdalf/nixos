_: let
  lock-true = {
    Value = true;
    Status = "locked";
  };
in {
  programs.firefox.policies = {
    # Ad-hoc user preferences, managed by policy
    Preferences = {
      "gfx.webrender.all" = lock-true;
      "layers.acceleration.force-enabled" = lock-true;
      "media.ffmpeg.encoder.enabled" = lock-true;
      "media.ffmpeg.vaapi.enabled" = lock-true;
      "media.hardware-video-decoding.force-enabled" = lock-true;
    };
  };
}
