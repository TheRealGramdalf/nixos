{pkgs, ... }: {
  fonts.packages = with pkgs; [
    corefonts # arial, times new roman
    vista-fonts # cambria, calibri
  ];
}