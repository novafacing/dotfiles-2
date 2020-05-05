# chaos -- my laptop

{ pkgs, ... }:
{
  imports = [
    ../personal.nix   # common settings
    ./hardware-configuration.nix
  ];

  modules = {
    desktop = {
      bspwm.enable = true;

      apps.rofi.enable = true;
      apps.discord.enable = true;
      # apps.skype.enable = true;
      apps.daw.enable = true;        # making music
      apps.graphics.enable = true;   # raster/vector/sprites
      apps.recording.enable = true;  # recording screen/audio
      # apps.vm.enable = true;       # virtualbox for testing

      term.default = "xst";
      term.st.enable = true;

      browsers.default = "firefox";
      browsers.firefox.enable = true;

      # gaming.emulators.psx.enable = true;
      # gaming.steam.enable = true;
    };

    editors = {
      default = "nvim";
      emacs.enable = false;
      vim.enable = false;
    };

    dev = {
      # cc.enable = true;
      # common-lisp.enable = true;
      # rust.enable = true;
      # lua.enable = true;
      # lua.love2d.enable = true;
    };

    media = {
      mpv.enable = true;
      spotify.enable = true;
    };

    shell = {
      direnv.enable = true;
      git.enable = true;
      gnupg.enable = true;
      # weechat.enable = true;
      pass.enable = true;
      tmux.enable = true;
      # ranger.enable = true;
      zsh.enable = true;
    };

    services = {
      # syncthing.enable = true;
    };

    # themes.aquanaut.enable = true;
    themes.fluorescence.enable = true;
  };

  programs.ssh.startAgent = true;

  # Networking settings
  networking.networkmanager.enable = true;
  networking.interfaces.enp0s31f6.useDHCP = true;
  networking.interfaces.wlp2s0.useDHCP = true;
  networking.enableIPv6 = true;
  networking.firewall.allowPing = true;
  networking.firewall.allowedTCPPorts = [];
  networking.firewall.allowedUDPPorts = [];

  hardware.opengl.enable = true;


  time.timeZone = "America/Indianapolis/Indiana";
  # time.timeZone = "Europe/Copenhagen";

  # Optimize power use
  environment.systemPackages = [ 
    pkgs.acpi 
  ];
  powerManagement.powertop.enable = true;
  # Monitor backlight control
  programs.light.enable = true;
}
