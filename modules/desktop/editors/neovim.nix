{ config
, options
, lib
, pkgs
, inputs
, ...
}:
with lib;
with lib.my;

let cfg = config.modules.desktop.editors.neovim;
in {
  options.modules.desktop.editors.neovim = {
    agasaya.enable = mkBoolOpt false; # lua
    ereshkigal.enable = mkBoolOpt false; # fnl
  };

  config = mkMerge [
    {
      nixpkgs.overlays = [ inputs.nvim-nightly.overlay ];

      user.packages = with pkgs; [
        neovide
        (mkIf (!config.modules.develop.cc.enable) gcc) # Treesitter
      ];

      hm.programs.neovim = {
        enable = true;
        package = pkgs.neovim-nightly;
        viAlias = true;
        vimAlias = true;
        vimdiffAlias = true;
      };
    }

    (mkIf cfg.agasaya.enable {
      modules.develop.lua.enable = true;

      home.configFile = {
        agasaya-config = {
          source = "${inputs.nvim-dir}/agasaya";
          target = "nvim";
          recursive = true;
        };

        agasaya-init = {
          target = "nvim/init.lua";
          text = ''
            -- THIS (`init.lua`) FILE WAS GENERATED BY HOME-MANAGER.
            -- REFRAIN FROM MODIFYING IT DIRECTLY!

            local fn = vim.fn
            local install_path = fn.stdpath("data") .. "/site/pack/packer/opt/packer.nvim"
            if fn.empty(fn.glob(install_path)) > 0 then
                _G.packer_bootstrap = fn.system({
                    "git",
                    "clone",
                    "--depth",
                    "1",
                    "https://github.com/wbthomason/packer.nvim",
                    install_path,
                })
                print("Installing packer.nvim")
                vim.cmd([[packadd packer.nvim]])
            end

            -- Point Nvim to correct sqlite path
            vim.g.sqlite_clib_path = "${pkgs.sqlite.out}/lib/libsqlite3.so"

            -- Call-forward Agasaya:
            require("core").init()
          '';
        };
      };
    })

    (mkIf cfg.ereshkigal.enable {
      modules.develop.lua.fnlized.enable = true;

      home.configFile = {
        ereshkigal-config = {
          source = "${inputs.nvim-dir}/ereshkigal";
          target = "nvim";
          recursive = true;
        };
        ereshkigal-init = {
          target = "nvim/init.lua";
          text = ''
            -- THIS (`init.lua`) FILE WAS GENERATED BY HOME-MANAGER.
            -- REFRAIN FROM MODIFYING IT DIRECTLY!

            local function fprint(string, ...)
                print(string.format(string, ...))
            end

            local function plugin_status(status)
                if not status then
                    return "start/"
                else
                    return "opt/"
                end
            end

            local function assert_installed(plugin, branch, status)
                local _, _, plugin_name = string.find(plugin, [[%S+/(%S+)]])
                local plugin_path = vim.fn.stdpath("data")
                    .. "/site/pack/packer/"
                    .. plugin_status(status)
                    .. plugin_name
                if vim.fn.empty(vim.fn.glob(plugin_path)) > 0 then
                    fprint(
                        "Couldn't find '%s'. Cloning a new copy to %s",
                        plugin_name,
                        plugin_path
                    )
                    if branch > 0 then
                        vim.fn.system({
                            "git",
                            "clone",
                            "https://github.com/" .. plugin,
                            "--branch",
                            branch,
                            plugin_path,
                        })
                    else
                        vim.fn.system({
                            "git",
                            "clone",
                            "https://github.com/" .. plugin,
                            plugin_path,
                        })
                    end
                end
            end

            assert_installed("wbthomason/packer.nvim", nil, true)
            assert_installed("rktjmp/hotpot.nvim", "nightly")

            -- Point Nvim to correct sqlite path
            vim.g.sqlite_clib_path = "${pkgs.sqlite.out}/lib/libsqlite3.so"

            if pcall(require, "hotpot") then
                require("hotpot").setup({
                    modules = { correlate = true },
                    provide_require_fennel = true,
                })
                require("core.init")
            else
                print("Failed to require Hotpot")
            end
          '';
        };
      };
    })
  ];
}
