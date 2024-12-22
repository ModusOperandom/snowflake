{ pkgs, config, lib, ... }: {

  imports = [ ./hardware.nix ];

  modules = {
    shell = {
      default = "fish";
      toolset = {
        git.enable = true;
        gnupg.enable = true;
      };
    };
    networking.networkManager.enable = true;
    services.ssh.enable = true;

    themes.active = "catppuccin";
    develop = {
      nix = {
        enable = true;
      };
    };
    virtualize = {
      enable = true;
    };
    desktop = {
      gnome.enable = true;
      extensions = {
        rofi.enable = true;
      };
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
        };
        chromium = {
          enable = true;
        };
      };
      toolset = {
        player = {
          music.enable = false;
          video.enable = true;
        };
        communication = {
          base.enable = true;
        };
        readers = {
          enable = true;
          program = "zathura";
        };
      };
      distractions = {
        steam.enable = true;
        lutris.enable = false;
      };
    };
  };
}
