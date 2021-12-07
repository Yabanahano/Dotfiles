{ config, pkgs, lib, ... }:

let
  pluginGit = ref: repo: pkgs.vimUtils.buildVimPluginFrom2Nix {
    pname = "${lib.strings.sanitizeDerivationName repo}";
    version = ref;
    src = builtins.fetchGit {
      url = "https://github.com/${repo}.git";
      ref = ref;
    };
  };

  plugin = pluginGit "HEAD";
in
{
  programs.neovim = {
    enable = true;
    package = pkgs.neovim-nightly;
    extraConfig = ''
      colorscheme rose-pine
    '';
    plugins = with pkgs.vimPlugins; [
      # This will make your neovim better
      (plugin "rose-pine/neovim")
    ];
  };
}
