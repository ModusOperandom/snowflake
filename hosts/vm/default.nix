{ pkgs, config, lib, ... }: {

  imports = [ ./hardware.nix ];

  modules = {
    shell = {
      default = "zsh";
      toolset = {
        git.enable = true;
        gnupg.enable = true;
      };
    };
    networking.networkManager.enable = true;
    services.ssh.enable = true;

    themes.active = "catppuccin";
    desktop = {
      gnome.enable = true;
      terminal = {
        default = "alacritty";
        alacritty.enable = true;
      };
      editors = {
        default = "nvim";
        neovim.enable = true;
        vscodium.enable = true;
      };
      browsers = {
        default = "firefox";
        firefox = {
          enable = true;
          #privacy.enable = true;
        };
      };
      toolset = {
        player = {
          music.enable = false;
          video.enable = true;
        };
        communication = {
          base.enable = true;
          matrix.withDaemon.enable = false;
        };
        readers = {
          enable = true;
          program = "zathura";
        };
      };
      distractions = {
        steam.enable = true;
        lutris.enable = true;
      };
    };
  };
}
