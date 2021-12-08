{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    initExtra = ''
      # KeyBind
      # bindkey "''${key[Up]}" up-line-or-search
      bindkey "^ " autosuggest-accep

      # Load Powerlevel10k
      [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
    '';
    shellAliases = {
      ls = "exa --icons";
      la = "exa --icons -la";
      lg = "exa --icons -la | grep";
      update = "sudo nixos-rebuild switch -I nixos-config=$HOME/dotfiles/configuration.nix & ./$HOME/dotfiles/utils/nvim-lua-config.sh";
    };
    zplug = {
      enable = true;
      plugins = [
	{ name = "romkatv/powerlevel10k"; tags = [ as:theme depth:1 ]; }
	{ name = "zsh-users/zsh-autosuggestions"; }
	{ name = "Yabanahano/auto-ls"; }
	{ name = "b4b4r07/enhancd"; }
	{ name = "zdharma-continuum/fast-syntax-highlighting"; }
	# { name = "marlonrichert/zsh-autocomplete"; }
	# { name = "spaceship-prompt/spaceship-prompt"; }
      ];
    };
  };
}
