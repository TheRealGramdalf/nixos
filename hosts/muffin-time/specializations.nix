{
  specialisation."fullblast".configuration = {
    services = {
      # Control the malfunctioning fan
      thinkfan = {
        # The fan should always be running full blast, if not there's
        # something wrong with the sensor config
        levels = [
          [
            7 # Level 7, aka full (monitored) blast
            0
            32767
          ]
        ];
      };
    };
  };
  specialisation."aggressive".configuration = {
    services = {
      # Control the malfunctioning fan
      thinkfan = {
        # See https://www.desmos.com/calculator/ldzn6pj5pl
        # for a visualization of the fan curve. The meaning
        # can be found at https://www.mankier.com/5/thinkfan.conf.legacy
        levels = [
          [
            0
            0
            45
          ]
          [
            1
            40
            55
          ]
          [
            2
            50
            61
          ]
          [
            4
            52
            63
          ]
          [
            6
            56
            65
          ]
          [
            7
            60
            32767
          ]
        ];
      };
    };
  };
}
