{ config
, options
, lib
, pkgs
, ...
}:
with lib;
with lib.my;

let cfg = config.modules.desktop.editors;
in {
  options.modules.desktop.editors = {
    default = mkOption {
      type = with types; str;
      default = "nvim";
      description = "Default editor for text manipulation";
      example = "emacs";
    };
  };

  config = mkMerge [
    (mkIf (cfg.default != null) {
      env.EDITOR = cfg.default;
    })

    (mkIf (cfg.default == "nvim" || cfg.default == "emacs") {
      user.packages = with pkgs; [
        imagemagick
        editorconfig-core-c
        sqlite

        # module dependencies
        ## checkers: aspell
        (aspellWithDicts (dict: with dict; [ en en-computers en-science ]))

        ## JS/TS + Markdown 
        deno

        ## lsp: LaTeX + Org-Mode
        pandoc
        tectonic
        texlab
      ];
    })
  ];
}
