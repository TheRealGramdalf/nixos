{...}: {
  users = {
    users."timekpr-remote" = {
      isSystemUser = true;
      group = "timekpr-remote";
      openssh.authorizedKeys.keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDPoQi1V9bMnKNoOtF4n1TOUcvd0O+eUkW9vPh3YE1GmlLPCN6UsZTBhvZWqZpI84CVWDzpltrUjQNFkshLA3MZZb+Sft2jrx2B5kQ0TaEdSU+G9MBVCG2hWdabqF2ow/E8NlRY24z+m3DHsAtclGwgZ+XMHD50xdovT9xxnEbK4JEZVnmC0WEEcfisTELltEX+e3Q/laKRkArXFVxNh29mNNQkGFp+cLPXMocM7EctLtdfUdLZeryonptp1VspwRyU0UzmwxEYay8HhbRc53x37fVWNeCvJSWhCb5ATB0XYN/ZcoNTxyF/Vqa3/5PCiUdvvRCGUfB3gLtIz0gjUn8mYLhlT3Uu0AVXSIvh6VfTJ5EIpZPPYVwAW5AGKlbmMhwz9yxfxL89NJE/xpP5CUpnHbBzTsMnTMCDwmUrRfyW/FaYE5M2WihrkSPaLAOeLngwhD15pqbR/U46hf7PRTbuHR7GvIUbBmXV8MlitLGg92x+WiK41wWBAsx8fbUkxXEPTn0YNx5wVdOr6Be3hae6r5s6UBu5geXDvbRoP84rabGzoz4jA6F3dsT0ZROwf+0imP9VJoiix91Vrvk7oVYZBo8+iYnlu0/HtlrLi+iYuSDPRxnrjPnCu2Np6mRYj6ZkRhWDxJcaVd7+33eEJiMgDWV0J84Kc2ukhSHQtx3BMQ=="
      ];
    };
    groups = {
      "timekpr-remote" = {};
    };
  };

  services.timekpr = {
    enable = true;
    adminUsers = [
      "timekpr-remote"
    ];
  };
}