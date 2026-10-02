# Courtesy of https://github.com/notashelf
#
# Original attribution:
# Taken and adapted from:
#  <https://github.com/lf-/dotfiles/blob/main/configs/nix/roles/cgroups/default.nix>
# Also see:
#  <https://facebookmicrosites.github.io/cgroup2/docs/fbtax-results.html>
#  Chris Down talk at LISA'21:
#   <https://www.usenix.org/conference/lisa21/presentation/down>
# And for systemd configurations used below:
#  $ `man 5 systemd.resource-control`
let
  # System critical slice is for services that are, you guessed it, critical
  # to the system and its connectivity in case it is a remote system. We would
  # like to ensure that critical services, such as SSH, Tailscale, Journal etc.
  # are kept alive so that system does remain functional.
  systemCriticalSliceConfig = {
    ManagedOOMMemoryPressure = "kill";

    # Guarantee that we have some memory available
    # for the system at all times. This is important
    # for the system to remain functional.
    MemoryMin = "192M";
    IOWeight = 1000; # default 100
    CPUWeight = 1000; # default 100
  };

  backgroundSliceConfig = {
    ManagedOOMMemoryPressure = "kill";
    ManagedOOMMemoryPressureLimit = "60%";

    # Restrict the total amount of memory services in the background slice have
    # access to. Since a *background* service should be conservative on memory
    # this is a decent enough way to make sure they do not take more resources
    # than they should be allowed to.
    MemoryHigh = "350M"; # after this point, GC will become more aggressive
    IOWeight = 200; # default 100
    CPUWeight = 350; # default 100
    CPUQuota = "15%"; # background services can have a little CPU, as a treat
  };

  userSliceConfig = {
    MemoryHigh = "11G";
    ManagedOOMMemoryPressure = "kill";
    ManagedOOMMemoryPressureLimit = "60%";
    IOWeight = 600;
    CPUWeight = 600;
  };

  appSliceConfig = {
    ManagedOOMMemoryPressure = "kill";
    ManagedOOMMemoryPressureLimit = "97%";
  };
in {
  systemd = {
    # Systemd OOMd
    # Fedora enables these options by default. See the 10-oomd-* files here:
    #  <https://src.fedoraproject.org/rpms/systemd/tree/3211e4adfcca38dfe24188e28a65b1cf385ecfd6>
    # By default it only kills cgroups. So either systemd services marked for killing under OOM
    # or (disabled by default, enabled by us) the entire user slice. Fedora used to kill root
    # and system slices, but their OOMd configuration has since changed.
    oomd = {
      enable = true;

      # Disable the provided knobs -- they are too coarse, and also swap
      # monitoring seems like a bad idea, with BTRFS anyway
      enableRootSlice = false;
      enableSystemSlice = false;
      enableUserSlices = false;

      # 5s might be too fast, worth changing if system frequently
      # experiences high memory pressure.
      settings.OOM."DefaultMemoryPressureDurationSec" = "5s";
    };

    # Control system resources
    slices = {
      # Make root logins higher priority for resources
      "user-0".sliceConfig = systemCriticalSliceConfig;

      # User slice, which is where memory-hogging applications reside. This slice
      # is pretty aggressivee, because we have to hard reboot if our system dies.
      "user-1000".sliceConfig = userSliceConfig;

      # Critical services that should always be
      # available, regardless of current load.
      "host-critical" = {
        description = "Host Critical (Ensures that services to keep the system alive remain alive)";
        unitConfig = {
          # Required to avoid a dependency cycle on systemd-oomd. Systemd will
          # actually guess this right but we should fix it anyway.
          DefaultDependencies = false;
        };

        sliceConfig = systemCriticalSliceConfig;
      };

      # Make sure that the system services are always available.
      # This contains useful services like Bagel, usbguard, seatd
      # and so on. We would like them to remain alive and well so
      # that the system remains functional.
      system = {
        sliceConfig = {
          ManagedOOMMemoryPressure = "kill";
          ManagedOOMMemoryPressureLimit = "45%";

          IOWeight = 100;
        };
      };

      # Services that will run silently in the background, without being allowed
      # to drain too much of system resources, or create too much system noise. We
      # want to restrict resources, but not necessarily kill those services since
      # they may still be critical to successful operations, e.g., snapshot services.
      background = {
        description = "Background (Low-priority background services with limited resources)";
        unitConfig = {
          # Required to avoid a dependency cycle on systemd-oomd. Systemd will
          # actually guess this right but we should fix it anyway.
          DefaultDependencies = false;
        };

        sliceConfig = backgroundSliceConfig;
      };
    };

    # Also manage user slices. Worth nothing that background.slice exits under
    # both `systemd.slices` and `systemd.user.slices`. We would like to separate
    # *user* background services, and system background services. On another
    # hand, app.slice is only under `systemd.user.slices`
    user.slices = {
      background.sliceConfig = backgroundSliceConfig;
      app.sliceConfig = appSliceConfig;
    };

    # Pick a few services under `systemd.services` to mark as host-critical
    # and thus protect them from aggressive OOM killing.
    services = {
      # We'd rather not have our system clock stalled by an OOM kill.
      chronyd = {
        serviceConfig = {
          Slice = "host-critical.slice";
        };
      };

      # Protect Tailscale daemon as it will most likely
      # be routing traffic for us. We would like it to
      # remain alive and well for SSH or other services.
      tailscaled = {
        serviceConfig = {
          Slice = "host-critical.slice";
        };
      };

      # Keep OOMd alive so that it can continue to
      # kill heavy processes to *potentially* save
      # the system from load.
      systemd-oomd = {
        serviceConfig = {
          Slice = "host-critical.slice";
        };
      };

      # Retain the system journal so that we may continue
      # logging and documenting even under heavy load.
      # Should the system crash, this will come in handy
      # for debugging.
      systemd-journald = {
        serviceConfig = {
          Slice = "host-critical.slice";
        };
      };
    };
  };
}
